//
//  VimeoRequestSerializer.swift
//  VimeoUpload
//
//  Created by Hanssen, Alfie on 10/16/15.
//  Copyright © 2015 Vimeo. All rights reserved.
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

/** `VimeoRequestSerializer` is an `AFHTTPRequestSerializer` that primarily handles adding Vimeo-specific authorization headers to outbound requests.  It can be initialized with either a dynamic `AccessTokenProvider` or a static `AppConfiguration`.
 */
final public class VimeoRequestSerializer: AFJSONRequestSerializer
{
    private static let AcceptHeaderKey = "Accept"
    private static let AuthorizationHeaderKey = "Authorization"
    
    public typealias AccessTokenProvider = Void -> String?
    
    // MARK: 
    
    // for authenticated requests
    var accessTokenProvider: AccessTokenProvider?
    
    // for unauthenticated requests
    private let appConfiguration: AppConfiguration?
    
    // MARK: - Initialization
    
    /**
     Create a request serializer with an access token provider
     
     - parameter accessTokenProvider: when called, returns an authenticated access token
     - parameter apiVersion:          version of the API this application's requests should use
     
     - returns: an initialized `VimeoRequestSerializer`
     */
    init(accessTokenProvider: AccessTokenProvider, apiVersion: String = VimeoDefaultAPIVersionString)
    {
        self.accessTokenProvider = accessTokenProvider
        self.appConfiguration = nil
        
        super.init()

        self.setup(apiVersion: apiVersion)
    }
    
    /**
     Create a request serializer with an application configuration
     
     - parameter appConfiguration: your application's configuration
     
     - returns: an initialized `VimeoRequestSerializer`
     */
    init(appConfiguration: AppConfiguration)
    {
        self.accessTokenProvider = nil
        self.appConfiguration = appConfiguration
        
        super.init()
        
        self.setup(apiVersion: appConfiguration.apiVersion)
    }
    
    /**
     **NOT SUPPORTED**
     */
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override public func requestWithMethod(method: String, URLString: String, parameters: AnyObject?, error: NSErrorPointer) -> NSMutableURLRequest
    {
        var request = super.requestWithMethod(method, URLString: URLString, parameters: parameters, error: error)
       
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    override public func requestBySerializingRequest(request: NSURLRequest, withParameters parameters: AnyObject?, error: NSErrorPointer) -> NSURLRequest?
    {
        if let request = super.requestBySerializingRequest(request, withParameters: parameters, error: error)
        {
            var mutableRequest = request.mutableCopy() as! NSMutableURLRequest
            mutableRequest = self.setAuthorizationHeader(request: mutableRequest)
            
            return mutableRequest.copy() as? NSURLRequest
        }
        
        return nil
    }
    
    override public func requestWithMultipartFormRequest(request: NSURLRequest, writingStreamContentsToFile fileURL: NSURL, completionHandler handler: ((NSError?) -> Void)?) -> NSMutableURLRequest
    {
        var request = super.requestWithMultipartFormRequest(request, writingStreamContentsToFile: fileURL, completionHandler: handler)
    
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    // MARK: Private API
    
    private func setup(apiVersion apiVersion: String)
    {
        self.setValue("application/vnd.vimeo.*+json; version=\(apiVersion)", forHTTPHeaderField: self.dynamicType.AcceptHeaderKey)
//        self.writingOptions = .PrettyPrinted
    }

    private func setAuthorizationHeader(request request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        if let token = self.accessTokenProvider?()
        {
            let value = "Bearer \(token)"
            request.setValue(value, forHTTPHeaderField: self.dynamicType.AuthorizationHeaderKey)
        }
        else if let appConfiguration = self.appConfiguration
        {
            let clientID = appConfiguration.clientIdentifier
            let clientSecret = appConfiguration.clientSecret
            
            let authString = "\(clientID):\(clientSecret)"
            let authData = authString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64String = authData?.base64EncodedStringWithOptions([])
            
            if let base64String = base64String
            {
                let headerValue = "Basic \(base64String)"
                request.setValue(headerValue, forHTTPHeaderField: self.dynamicType.AuthorizationHeaderKey)
            }
        }
        
        return request
    }
}
