//
//  ResponseCache.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/29/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

private typealias ResponseDictionaryClosure = (_ responseDictionary: VimeoClient.ResponseDictionary?) -> Void

private protocol Cache
{
    func setResponseDictionary(_ responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
    
    func responseDictionary(forKey key: String, completion: @escaping ResponseDictionaryClosure)
    
    func removeResponseDictionary(forKey key: String)
    
    func removeAllResponseDictionaries()
}

/// Response cache handles the storage of JSON response dictionaries indexed by their associated `Request`.  It contains both memory and disk caching functionality
final internal class ResponseCache
{
    struct Constant
    {
        static let CacheDirectory = "com.vimeo.Caches"
    }
    
    /**
     Stores a response dictionary for a request.
     
     - parameter responseDictionary: the response dictionary to store
     - parameter request:            the request associated with the response
     */
    func setResponse<ModelType>(_ responseDictionary: VimeoClient.ResponseDictionary, forRequest request: Request<ModelType>)
    {
        let key = request.cacheKey
        
        self.memoryCache.setResponseDictionary(responseDictionary, forKey: key)
        self.diskCache.setResponseDictionary(responseDictionary, forKey: key)
    }
    
    /**
     Attempts to retrieve a response dictionary for a request
     
     - parameter request:    the request for which the cache should be queried
     - parameter completion: returns `.Success(ResponseDictionary)`, if found in cache, or `.Success(nil)` for a cache miss.  Returns `.Failure(NSError)` if an error occurred.
     */
    func responseForRequest<ModelType>(_ request: Request<ModelType>, completion: @escaping ResultCompletion<VimeoClient.ResponseDictionary?>.T)
    {
        let key = request.cacheKey
        
        self.memoryCache.responseDictionary(forKey: key) { (responseDictionary) in
            
            if responseDictionary != nil
            {
                completion(.success(result: responseDictionary))
            }
            else
            {
                self.diskCache.responseDictionary(forKey: key, completion: { (responseDictionary) in
                    
                    completion(.success(result: responseDictionary))
                })
            }
        }
    }

    /**
     Removes a response for a request
     
     - parameter request: the request for which to remove all cached responses
     */
    func removeResponse(forKey key: String)
    {
        self.memoryCache.removeResponseDictionary(forKey: key)
        self.diskCache.removeResponseDictionary(forKey: key)
    }
    
    /**
     Removes all responses from the cache
     */
    func clear()
    {
        self.memoryCache.removeAllResponseDictionaries()
        self.diskCache.removeAllResponseDictionaries()
    }

    // MARK: - Memory Cache
    
    fileprivate let memoryCache = ResponseMemoryCache()
    
    fileprivate class ResponseMemoryCache: Cache
    {
        fileprivate let cache = NSCache<AnyObject, AnyObject>()
        
        fileprivate func setResponseDictionary(_ responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
        {
            self.cache.setObject(responseDictionary as AnyObject, forKey: key as AnyObject)
        }
        
        fileprivate func responseDictionary(forKey key: String, completion: @escaping ResponseDictionaryClosure)
        {
            let responseDictionary = self.cache.object(forKey: key as AnyObject) as? VimeoClient.ResponseDictionary
            
            completion(responseDictionary)
        }
        
        fileprivate func removeResponseDictionary(forKey key: String)
        {
            self.cache.removeObject(forKey: key as AnyObject)
        }
        
        fileprivate func removeAllResponseDictionaries()
        {
            self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Disk Cache
    
    fileprivate let diskCache = ResponseDiskCache()
    
    fileprivate class ResponseDiskCache: Cache
    {
        fileprivate let queue = DispatchQueue(label: "com.vimeo.VIMCache.diskQueue", attributes: DispatchQueue.Attributes.concurrent)
        
        fileprivate func setResponseDictionary(_ responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
        {
            self.queue.async(flags: .barrier, execute: {
                
                let data = NSKeyedArchiver.archivedData(withRootObject: responseDictionary)
                let fileManager = FileManager()
                let directoryPath = self.cachesDirectoryURL().path
                
                guard let filePath = self.fileURLForKey(key: key)?.path else
                {
                    assertionFailure("No cache path found.")
                    return
                }
                
                do
                {
                    if !fileManager.fileExists(atPath: directoryPath)
                    {
                        try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    let success = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
                    
                    if !success
                    {
                        print("ResponseDiskCache could not store object")
                    }
                }
                catch let error
                {
                    print("ResponseDiskCache error: \(error)")
                }
            }) 
        }
        
        internal func responseDictionary(forKey key: String, completion: @escaping (VimeoClient.ResponseDictionary?) -> Void)
        {
            self.queue.async {
                
                guard let filePath = self.fileURLForKey(key: key)?.path
                    else
                {
                    assertionFailure("No cache path found.")
                    
                    return
                }
                
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
                else
                {
                    completion(nil)
                    
                    return
                }
                
                var responseDictionary: VimeoClient.ResponseDictionary? = nil
                
                do
                {
                    try ExceptionCatcher.doUnsafe
                    {
                        responseDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? VimeoClient.ResponseDictionary
                    }
                }
                catch let error
                {
                    print("Error decoding response dictionary: \(error)")
                }
                
                completion(responseDictionary)
            }
        }
        
        fileprivate func removeResponseDictionary(forKey key: String)
        {
            self.queue.async(flags: .barrier, execute: {
                
                let fileManager = FileManager()
                
                guard let filePath = self.fileURLForKey(key: key)?.path else
                {
                    // Assert to catch a badly formed filepath.
                    
                    assertionFailure("No valid cache file path found for key: \(key).")
                    
                    return
                }
                
                guard fileManager.fileExists(atPath: filePath) == true else
                {
                    // Multiple attempts to remove the cache file are possible given that
                    // a cached response won't be repopulated until another request is made.
                    // Thus we don't assert, and simply exit the method.
                    
                    print("No cache file to remove for key: \(key).")
                    
                    return
                }
                
                do
                {
                    try fileManager.removeItem(atPath: filePath)
                }
                catch let error
                {
                    print("Removal of disk cache for \(key) failed with error \(error)")
                }
            }) 
        }
        
        fileprivate func removeAllResponseDictionaries()
        {
            self.queue.async(flags: .barrier, execute: {
                
                let fileManager = FileManager()
                let directoryPath = self.cachesDirectoryURL().path
                
                guard !directoryPath.isEmpty else
                {
                    assertionFailure("No cache directory.")
                    return
                }
                
                do
                {
                    try fileManager.removeItem(atPath: directoryPath)
                }
                catch
                {
                    print("Could not clear disk cache.")
                }
            }) 
        }
        
        // MARK: - directories
        
        fileprivate func cachesDirectoryURL() -> URL
        {
            // Apple /Caches directory
            guard let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else
            {
                fatalError("No cache directories found.")
            }
            
            // We need to create a directory in `../Library/Caches folder`. Otherwise, trying to remove the Apple /Caches folder will always fail. Note that it's noticeable while testing on a device.
            return URL(fileURLWithPath: directory).appendingPathComponent(Constant.CacheDirectory, isDirectory: true)
            
            // Removed a `guard let` here since the method above doesn't return an optional. We may still want to include some error checking. [JSH] 03/13/17
        }
        
        fileprivate func fileURLForKey(key: String) -> URL?
        {
            let fileURL = self.cachesDirectoryURL().appendingPathComponent(key)
            
            // Similar to the method above, we may want additional error checking here. [JSH] 03/13/17
            
            return fileURL
        }
    }
}
