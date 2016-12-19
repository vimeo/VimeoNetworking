//
//  VimeoSessionManager.swift
//  VimeoUpload
//
//  Created by Alfred Hanssen on 10/17/15.
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

/** `VimeoSessionManager` handles networking and serialization for raw HTTP requests.  It is a direct subclass of `AFHTTPSessionManager` and it's designed to be used internally by `VimeoClient`.  For the majority of purposes, it would be better to use `VimeoClient` and a `Request` object to better encapsulate this logic, since the latter provides richer functionality overall.
 */
final public class VimeoSessionManager: AFHTTPSessionManager
{    
    // MARK: Initialization
    
    /**
     Creates a new session manager
     
     - parameter sessionConfiguration: Object describing the URL session policies for this session manager
     - parameter requestSerializer:    Serializer to use for all requests handled by this session manager
     
     - returns: an initialized `VimeoSessionManager`
     */
    required public init(sessionConfiguration: NSURLSessionConfiguration, requestSerializer: VimeoRequestSerializer)
    {        
        super.init(baseURL: VimeoBaseURLString, sessionConfiguration: sessionConfiguration)
        
        self.requestSerializer = requestSerializer
        self.responseSerializer = VimeoResponseSerializer()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Authentication
    
    /**
     Called when authentication completes successfully to update the session manager with the new access token
     
     - parameter account: the new account
     */
    func clientDidAuthenticateWithAccount(account: VIMAccount)
    {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
        else
        {
            return
        }
        
        let accessToken = account.accessToken
        requestSerializer.accessTokenProvider = {
            return accessToken
        }
    }
    
    /**
     Called when a client is logged out and the current account should be cleared from the session manager
     */
    func clientDidClearAccount()
    {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
            else
        {
            return
        }
        
        requestSerializer.accessTokenProvider = nil
    }
}
