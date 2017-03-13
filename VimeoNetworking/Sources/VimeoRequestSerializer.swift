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
    fileprivate static let AcceptHeaderKey = "Accept"
    fileprivate static let AuthorizationHeaderKey = "Authorization"
    
    public typealias AccessTokenProvider = (Void) -> String?
    
    // MARK: 
    
    // for authenticated requests
    var accessTokenProvider: AccessTokenProvider?
    
    // for unauthenticated requests
    fileprivate let appConfiguration: AppConfiguration?
    
    // MARK: - Initialization
    
    /**
     Create a request serializer with an access token provider
     
     - parameter accessTokenProvider: when called, returns an authenticated access token
     - parameter apiVersion:          version of the API this application's requests should use
     
     - returns: an initialized `VimeoRequestSerializer`
     */
    init(accessTokenProvider: @escaping AccessTokenProvider, apiVersion: String = VimeoDefaultAPIVersionString)
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
    
    override public func request(withMethod method: String, urlString URLString: String, parameters: Any?, error: NSErrorPointer) -> NSMutableURLRequest
    {
        var request = super.request(withMethod: method, urlString: URLString, parameters: parameters, error: error)
       
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    override public func request(bySerializingRequest request: URLRequest, withParameters parameters: Any?, error: NSErrorPointer) -> URLRequest?
    {
        if let request = super.request(bySerializingRequest: request, withParameters: parameters, error: error)
        {
            var mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
            mutableRequest = self.setAuthorizationHeader(request: mutableRequest)
            
            return mutableRequest.copy() as? URLRequest
        }
        
        return nil
    }
    
    public func request(withMultipartForm request: URLRequest, writingStreamContentsToFile fileURL: URL, completionHandler handler: ((NSError?) -> Void)?) -> NSMutableURLRequest
    {
        var request = super.request(withMultipartForm: request, writingStreamContentsToFile: fileURL, completionHandler: handler as! ((Error?) -> Void)?)
    
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    // MARK: Private API
    
    fileprivate func setup(apiVersion: String)
    {
        self.setValue("application/vnd.vimeo.*+json; version=\(apiVersion)", forHTTPHeaderField: type(of: self).AcceptHeaderKey)
//        self.writingOptions = .PrettyPrinted
    }

    fileprivate func setAuthorizationHeader(request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        if let token = self.accessTokenProvider?()
        {
            let value = "Bearer \(token)"
            request.setValue(value, forHTTPHeaderField: type(of: self).AuthorizationHeaderKey)
        }
        else if let appConfiguration = self.appConfiguration
        {
            let clientID = appConfiguration.clientIdentifier
            let clientSecret = appConfiguration.clientSecret
            
            let authString = "\(clientID):\(clientSecret)"
            let authData = authString.data(using: String.Encoding.utf8)
            let base64String = authData?.base64EncodedString(options: [])
            
            if let base64String = base64String
            {
                let headerValue = "Basic \(base64String)"
                request.setValue(headerValue, forHTTPHeaderField: type(of: self).AuthorizationHeaderKey)
            }
        }
        
        return request
    }
}
