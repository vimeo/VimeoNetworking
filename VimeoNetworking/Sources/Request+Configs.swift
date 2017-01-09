//
//  Request+Configs.swift
//  Pods
//
//  Created by King, Gavin on 10/31/16.
//
//

import UIKit

extension Request
{
    /**
     Create a `Request` to get the app configs
     
     - parameter fromCache: request the configs from the local cache
     
     - returns: a new `Request`
     */
    public static func configsRequest(fromCache fromCache: Bool) -> Request
    {
        let path = "/configs"
        
        if fromCache
        {
            return Request(method: .GET, path: path, cacheFetchPolicy: .CacheOnly)
        }
        else
        {
            return Request(method: .GET, path: path, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: true)
        }
    }
}
