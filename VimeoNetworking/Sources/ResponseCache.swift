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

private typealias ResponseDictionaryClosure = (VimeoClient.ResponseDictionary?) -> Void

private protocol Cache
{
    func removeAllResponseDictionaries()
}

/// Response cache handles the storage of JSON response dictionaries indexed by their associated `Request`.  It contains both memory and disk caching functionality
final public class ResponseCache
{
    private struct Constant
    {
        static let CacheDirectory = "com.vimeo.Caches"
    }
    
    /// Initializer
    ///
    /// - Parameter cacheDirectory: the directory name where the cache files will be stored.  Defaults to com.vimeo.Caches.
    init(cacheDirectory: String = Constant.CacheDirectory)
    {
        self.memoryCache = ResponseMemoryCache()
        self.diskCache = ResponseDiskCache(cacheDirectory: cacheDirectory)
    }
    
    /// Revmoes all responses from the cache.
    func clear()
    {
        self.memoryCache.removeAllResponseDictionaries()
        self.diskCache.removeAllResponseDictionaries()
    }

    // MARK: - Memory Cache
    
    private let memoryCache: ResponseMemoryCache
    
    private class ResponseMemoryCache: Cache
    {
        private let cache = NSCache<AnyObject, AnyObject>()
        
        func removeAllResponseDictionaries()
        {
            self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Disk Cache
    
    private let diskCache: ResponseDiskCache
    
    private class ResponseDiskCache: Cache
    {
        private let queue = DispatchQueue(label: "com.vimeo.VIMCache.diskQueue", attributes: DispatchQueue.Attributes.concurrent)
        private let cacheDirectory: String
        
        init(cacheDirectory: String)
        {
            self.cacheDirectory = cacheDirectory
        }
        
        func removeAllResponseDictionaries()
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
        
        // MARK: - Directories
        
        private func cachesDirectoryURL() -> URL
        {
            // Apple /Caches directory
            guard let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else
            {
                fatalError("No cache directories found.")
            }
            
            // We need to create a directory in `../Library/Caches folder`. Otherwise, trying to remove the Apple /Caches folder will always fail. Note that it's noticeable while testing on a device.
            return URL(fileURLWithPath: directory).appendingPathComponent(self.cacheDirectory, isDirectory: true)
        }
        
        private func fileURL(forKey key: String) -> URL?
        {
            let fileURL = self.cachesDirectoryURL().appendingPathComponent(key)
            
            return fileURL
        }
    }
}
