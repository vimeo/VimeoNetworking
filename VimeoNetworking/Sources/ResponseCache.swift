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

private typealias ResponseDictionaryClosure = (responseDictionary: VimeoClient.ResponseDictionary?) -> Void

private protocol Cache
{
    func setResponseDictionary(responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
    
    func responseDictionary(forKey key: String, completion: ResponseDictionaryClosure)
    
    func removeResponseDictionary(forKey key: String)
    
    func removeAllResponseDictionaries()
}

/// Response cache handles the storage of JSON response dictionaries indexed by their associated `Request`.  It contains both memory and disk caching functionality
final internal class ResponseCache
{
    /**
     Stores a response dictionary for a request.
     
     - parameter responseDictionary: the response dictionary to store
     - parameter request:            the request associated with the response
     */
    func setResponse<ModelType>(responseDictionary: VimeoClient.ResponseDictionary, forRequest request: Request<ModelType>)
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
    func responseForRequest<ModelType>(request: Request<ModelType>, completion: ResultCompletion<VimeoClient.ResponseDictionary?>.T)
    {
        let key = request.cacheKey
        
        self.memoryCache.responseDictionary(forKey: key) { (responseDictionary) in
            
            if responseDictionary != nil
            {
                completion(result: .Success(result: responseDictionary))
            }
            else
            {
                self.diskCache.responseDictionary(forKey: key, completion: { (responseDictionary) in
                    
                    completion(result: .Success(result: responseDictionary))
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
    
    private let memoryCache = ResponseMemoryCache()
    
    private class ResponseMemoryCache: Cache
    {
        private let cache = NSCache()
        
        private func setResponseDictionary(responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
        {
            self.cache.setObject(responseDictionary, forKey: key)
        }
        
        private func responseDictionary(forKey key: String, completion: ResponseDictionaryClosure)
        {
            let responseDictionary = self.cache.objectForKey(key) as? VimeoClient.ResponseDictionary
            
            completion(responseDictionary: responseDictionary)
        }
        
        private func removeResponseDictionary(forKey key: String)
        {
            self.cache.removeObjectForKey(key)
        }
        
        private func removeAllResponseDictionaries()
        {
            self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Disk Cache
    
    private let diskCache = ResponseDiskCache()
    
    private class ResponseDiskCache: Cache
    {
        private let queue = dispatch_queue_create("com.vimeo.VIMCache.diskQueue", DISPATCH_QUEUE_CONCURRENT)
        
        private func setResponseDictionary(responseDictionary: VimeoClient.ResponseDictionary, forKey key: String)
        {
            dispatch_barrier_async(self.queue) {
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(responseDictionary)
                
                let fileManager = NSFileManager()
                
                let directoryURL = self.cachesDirectoryURL()
                
                guard let directoryPath = directoryURL.path,
                    let filePath = self.fileURLForKey(key: key)?.path
                else
                {
                    assertionFailure("no cache path found")
                    
                    return
                }
                
                do
                {
                    if !fileManager.fileExistsAtPath(directoryPath)
                    {
                        try fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    let success = fileManager.createFileAtPath(filePath, contents: data, attributes: nil)
                    
                    if !success
                    {
                        print("ResponseDiskCache could not store object")
                    }
                }
                catch let error
                {
                    print("ResponseDiskCache error: \(error)")
                }
            }
        }
        
        private func responseDictionary(forKey key: String, completion: ResponseDictionaryClosure)
        {
            dispatch_async(self.queue) {
                
                guard let filePath = self.fileURLForKey(key: key)?.path
                    else
                {
                    assertionFailure("no cache path found")
                    
                    return
                }
                
                guard let data = NSData(contentsOfFile: filePath)
                else
                {
                    completion(responseDictionary: nil)
                    
                    return
                }
                
                var responseDictionary: VimeoClient.ResponseDictionary? = nil
                
                do
                {
                    try ExceptionCatcher.doUnsafe
                    {
                        responseDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? VimeoClient.ResponseDictionary
                    }
                }
                catch let error
                {
                    print("error decoding response dictionary: \(error)")
                }
                
                completion(responseDictionary: responseDictionary)
            }
        }
        
        private func removeResponseDictionary(forKey key: String)
        {
            dispatch_barrier_async(self.queue) {
                
                let fileManager = NSFileManager()
                
                guard let filePath = self.fileURLForKey(key: key)?.path
                    else
                {
                    assertionFailure("no cache path found")
                    
                    return
                }
                
                do
                {
                    try fileManager.removeItemAtPath(filePath)
                }
                catch
                {
                    print("could not remove disk cache for \(key)")
                }
            }
        }
        
        private func removeAllResponseDictionaries()
        {
            dispatch_barrier_async(self.queue) {
                
                let fileManager = NSFileManager()
                
                guard let directoryPath = self.cachesDirectoryURL().path
                else
                {
                    assertionFailure("no cache directory")
                    
                    return
                }
                
                do
                {
                    try fileManager.removeItemAtPath(directoryPath)
                }
                catch
                {
                    print("could not clear disk cache")
                }
            }
        }
        
        // MARK: - directories
        
        private func cachesDirectoryURL() -> NSURL
        {
            guard let directory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first
            else
            {
                fatalError("no cache directories found")
            }
            
            return NSURL(fileURLWithPath: directory)
        }
        
        private func fileURLForKey(key key: String) -> NSURL?
        {
            guard let fileURL = self.cachesDirectoryURL().URLByAppendingPathComponent(key) else
            {
                assertionFailure("Unable to create cache file URL.")
                
                return nil
            }
            
            return fileURL
        }
    }
}
