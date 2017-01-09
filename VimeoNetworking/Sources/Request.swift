//
//  Request.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
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
import AFNetworking

/// Describes how a request should query the cache
public enum CacheFetchPolicy
{
        /// Only request cached responses.  No network request is made.
    case CacheOnly
    
        /// Try to load from both cache and network, note that two results may be returned when using this method (cached, then network)
    case CacheThenNetwork
    
        /// Only try to load the request from network.  The cache is not queried
    case NetworkOnly
    
        /// First try the network request, then fallback to cache if it fails
    case TryNetworkThenCache
    
    /**
     Construct the default cache fetch policy for a given `Method`
     
     - parameter method: the request `Method`
     
     - returns: the default cache policy for the provided `Method`
     */
    static func defaultPolicyForMethod(method: VimeoClient.Method) -> CacheFetchPolicy
    {
        switch method
        {
        case .GET:
            return .CacheThenNetwork
        case .DELETE, .PATCH, .POST, .PUT:
            return .NetworkOnly
        }
    }
}

/// Describes how a request should handle retrying after failure
public enum RetryPolicy
{
        /// Only one attempt is made, no retry behavior
    case SingleAttempt
    
    /**
      Retry a request a specified number of times, starting with a specified delay
     
     - parameter attemptCount: maximum number of times this request should be retried
     - parameter initialDelay: the delay (in seconds) until first retry. The next delay is doubled with each retry to provide `back-off` behavior, which tends to lead to a greater probability of recovery
     */
    case MultipleAttempts(attemptCount: Int, initialDelay: NSTimeInterval)
    
    /**
     Construct the default retry policy for a given `Method`
     
     - parameter method: the request `Method`
     
     - returns: the default retry policy for the given `Method`
     */
    static func defaultPolicyForMethod(method: VimeoClient.Method) -> RetryPolicy
    {
        switch method
        {
        case .GET, .DELETE, .PATCH, .POST, .PUT:
            return .SingleAttempt
        }
    }
}

extension RetryPolicy
{
    /// Convenience `RetryPolicy` constructor that provides a standard multiple attempt policy
    static let TryThreeTimes: RetryPolicy = .MultipleAttempts(attemptCount: 3, initialDelay: 2.0)
}

/**
 *  Describes a single request.
 *
 *  `<ModelType>` is the type of the expected response model object
 */
public struct Request<ModelType: MappableResponse>
{
    // TODO: Make these static when Swift supports it [RH] (5/24/16)
    private let PageKey = "page"
    private let PerPageKey = "per_page"
    
    // MARK: -
    
        /// HTTP method (e.g. `.GET`, `.POST`)
    public let method: VimeoClient.Method
    
        /// request url path (e.g. `/me`, `/videos/123456`)
    public let path: String
    
        /// any parameters to include with the request
    public let parameters: AnyObject?

        /// query a nested JSON key path for the response model object to be returned
    public let modelKeyPath: String?
    
        /// describes how this request should query for cached responses
    internal(set) public var cacheFetchPolicy: CacheFetchPolicy
    
        /// whether a successful response to this request should be stored in cache
    public let shouldCacheResponse: Bool
    
        /// describes how the request should handle retrying after failure
    internal(set) public var retryPolicy: RetryPolicy
    
    // MARK: -
    
    /**
     Build a new request, where the generic type `ModelType` is that of the expected response model object
     
     - parameter method:              the HTTP method (e.g. `.GET`, `.POST`), defaults to `.GET`
     - parameter path:                url path for this request
     - parameter parameters:          additional parameters for this request
     - parameter modelKeyPath:        optionally query a nested JSON key path for the response model object to be returned, defaults to `nil`
     - parameter cacheFetchPolicy:    describes how this request should query for cached responses, defaults to `.CacheThenNetwork`
     - parameter shouldCacheResponse: whether the response should be stored in cache, defaults to `true`
     - parameter retryPolicy:         describes how the request should handle retrying after failure, defaults to `.SingleAttempt`
     
     - returns: an initialized `Request`
     */
    public init(method: VimeoClient.Method = .GET,
                path: String,
                parameters: AnyObject? = nil,
                modelKeyPath: String? = nil,
                cacheFetchPolicy: CacheFetchPolicy? = nil,
                shouldCacheResponse: Bool? = nil,
                retryPolicy: RetryPolicy? = nil)
    {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.modelKeyPath = modelKeyPath
        self.cacheFetchPolicy = cacheFetchPolicy ?? CacheFetchPolicy.defaultPolicyForMethod(method)
        self.shouldCacheResponse = shouldCacheResponse ?? (method == .GET)
        self.retryPolicy = retryPolicy ?? RetryPolicy.defaultPolicyForMethod(method)
    }
    
        /// Returns a fully-formed URI comprised of the path plus a query string of any parameters
    public var URI: String
    {
        let URI = self.path
        
        let components = NSURLComponents(string: URI)

        if let parameters = self.parameters as? VimeoClient.RequestParametersDictionary
        {
            let queryString = AFQueryStringFromParameters(parameters)
            
            if queryString.characters.count > 0
            {
                components?.query = queryString
            }
        }
        
        return components!.string!
    }
    
    // MARK: Copying requests
    
    internal func associatedPageRequest(newPath newPath: String) -> Request<ModelType>
    {
        // Since page response paging paths bake the paging parameters into the path,
        // strip them out and upsert them back into the body parameters.
        
        let (updatedPath, query) = newPath.splitLinkString()
        
        var updatedParameters = (self.parameters as? VimeoClient.RequestParametersDictionary) ?? [:]
        
        if let queryParametersDictionary = query?.parametersDictionaryFromQueryString()
        {
            queryParametersDictionary.forEach { (key, value) in
                
                updatedParameters[key] = value
            }
        }
        
        return Request(method: self.method,
                       path: updatedPath,
                       parameters: updatedParameters,
                       modelKeyPath: self.modelKeyPath,
                       cacheFetchPolicy: self.cacheFetchPolicy,
                       shouldCacheResponse: self.shouldCacheResponse,
                       retryPolicy: self.retryPolicy)
    }
}
