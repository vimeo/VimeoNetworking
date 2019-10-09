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

/// Describes how a request should handle retrying after failure
public enum RetryPolicy {
        /// Only one attempt is made, no retry behavior
    case singleAttempt
    
    /**
      Retry a request a specified number of times, starting with a specified delay
     
     - parameter attemptCount: maximum number of times this request should be retried
     - parameter initialDelay: the delay (in seconds) until first retry. The next delay is doubled with each retry to provide `back-off` behavior, which tends to lead to a greater probability of recovery
     */
    case multipleAttempts(attemptCount: Int, initialDelay: TimeInterval)
    
    /**
     Construct the default retry policy for a given `Method`
     
     - parameter method: the request `Method`
     
     - returns: the default retry policy for the given `Method`
     */
    static func defaultPolicyForMethod(for method: VimeoClient.Method) -> RetryPolicy {
        switch method {
        case .GET, .DELETE, .PATCH, .POST, .PUT:
            return .singleAttempt
        }
    }
}

extension RetryPolicy {
    /// Convenience `RetryPolicy` constructor that provides a standard multiple attempt policy
    static let TryThreeTimes: RetryPolicy = .multipleAttempts(attemptCount: 3, initialDelay: 2.0)
}

/**
 *  Describes a single request.
 *
 *  `<ModelType>` is the type of the expected response model object
 */
public struct Request<ModelType: MappableResponse> {
    // TODO: Make these static when Swift supports it [RH] (5/24/16)
    private let PageKey = "page"
    private let PerPageKey = "per_page"
    
    // MARK: -
    
        /// HTTP method (e.g. `.GET`, `.POST`)
    public let method: VimeoClient.Method
    
        /// request url path (e.g. `/me`, `/videos/123456`)
    public let path: String
    
        /// any parameters to include with the request
    public let parameters: Any?

        /// query a nested JSON key path for the response model object to be returned
    public let modelKeyPath: String?
    
        /// describes how this request should query for cached responses
    public let useCache: Bool
    
        /// whether a successful response to this request should be stored in cache
    public let cacheResponse: Bool
    
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
                parameters: Any? = nil,
                modelKeyPath: String? = nil,
                useCache: Bool = false,
                cacheResponse: Bool = false,
                retryPolicy: RetryPolicy? = nil) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.modelKeyPath = modelKeyPath
        self.useCache = useCache
        self.cacheResponse = cacheResponse
        self.retryPolicy = retryPolicy ?? RetryPolicy.defaultPolicyForMethod(for: method)
    }
    
        /// Returns a fully-formed URI comprised of the path plus a query string of any parameters
    public var URI: String {
        let URI = self.path
        
        var components = URLComponents(string: URI)

        if let parameters = self.parameters as? VimeoClient.RequestParametersDictionary {
            let queryString = AFQueryStringFromParameters(parameters)
            
            if queryString.count > 0 {
                components?.query = queryString
            }
        }
        
        return components?.string?.removingPercentEncoding ?? ""
    }
    
    // MARK: Copying requests
    
    internal func associatedPageRequest(withNewPath newPath: String) -> Request<ModelType> {
        // Since page response paging paths bake the paging parameters into the path,
        // strip them out and upsert them back into the body parameters.
        
        let (updatedPath, query) = newPath.splitLinkString()
        
        var updatedParameters = (self.parameters as? VimeoClient.RequestParametersDictionary) ?? [:]
        
        if let queryParametersDictionary = query?.parametersDictionaryFromQueryString() {
            queryParametersDictionary.forEach { (key, value) in
                
                updatedParameters[key] = value
            }
        }
        
        return Request(method: self.method,
                       path: updatedPath,
                       parameters: updatedParameters,
                       modelKeyPath: self.modelKeyPath,
                       useCache: self.useCache,
                       cacheResponse: self.cacheResponse,
                       retryPolicy: self.retryPolicy)
    }
}
