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

class VimeoRequestSerializer: AFJSONRequestSerializer
{
    private static let AcceptHeaderKey = "Accept"
    private static let AuthorizationHeaderKey = "Authorization"
    
    // MARK: 
    
    private var authTokenBlock: AuthTokenBlock
    
    // MARK: - Initialization
    
    init(authTokenBlock: AuthTokenBlock, version: String = VimeoDefaultAPIVersionString)
    {
        self.authTokenBlock = authTokenBlock
        
        super.init()

        self.setValue("application/vnd.vimeo.*+json; version=\(version)", forHTTPHeaderField: self.dynamicType.AcceptHeaderKey)
        self.writingOptions = .PrettyPrinted
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func requestWithMethod(method: String, URLString: String, parameters: AnyObject?, error: NSErrorPointer) -> NSMutableURLRequest
    {
        var request = super.requestWithMethod(method, URLString: URLString, parameters: parameters, error: error)
       
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    override func requestBySerializingRequest(request: NSURLRequest, withParameters parameters: AnyObject?, error: NSErrorPointer) -> NSURLRequest?
    {
        if let request = super.requestBySerializingRequest(request, withParameters: parameters, error: error)
        {
            var mutableRequest = request.mutableCopy() as! NSMutableURLRequest
            mutableRequest = self.setAuthorizationHeader(request: mutableRequest)
            
            return mutableRequest.copy() as? NSURLRequest
        }
        
        return nil
    }
    
    override func requestWithMultipartFormRequest(request: NSURLRequest, writingStreamContentsToFile fileURL: NSURL, completionHandler handler: ((NSError?) -> Void)?) -> NSMutableURLRequest
    {
        var request = super.requestWithMultipartFormRequest(request, writingStreamContentsToFile: fileURL, completionHandler: handler)
    
        request = self.setAuthorizationHeader(request: request)
        
        return request
    }
    
    // MARK: Private API

    private func setAuthorizationHeader(request request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        if let token = self.authTokenBlock()
        {
            let value = "Bearer \(token)"
            request.setValue(value, forHTTPHeaderField: self.dynamicType.AuthorizationHeaderKey)
        }
        
        return request
    }
}
