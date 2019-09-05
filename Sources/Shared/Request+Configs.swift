//
//  Request+Configs.swift
//  Pods
//
//  Created by King, Gavin on 10/31/16.
//
//

import Foundation

extension Request {
    /**
     Create a `Request` to get the app configs
     
     - parameter fromCache: request the configs from the local cache
     
     - returns: a new `Request`
     */
    public static func configsRequest(fromCache cache: Bool) -> Request {
        let path = "/configs"
        
        if cache {
            return Request(method: .get, path: path, useCache: true)
        }
        else {
            return Request(method: .get, path: path, cacheResponse: true)
        }
    }
}
