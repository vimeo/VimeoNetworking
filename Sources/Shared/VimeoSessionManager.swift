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

private typealias SessionManagingDataTaskSuccess = ((URLSessionDataTask, Any?) -> Void)
private typealias SessionManagingDataTaskFailure = ((URLSessionDataTask?, Error) -> Void)
private typealias SessionManagingDataTaskProgress = (Progress) -> Void

/** `VimeoSessionManager` handles networking and serialization for raw HTTP requests.  It is a direct subclass of `AFHTTPSessionManager` and it's designed to be used internally by `VimeoClient`.  For the majority of purposes, it would be better to use `VimeoClient` and a `Request` object to better encapsulate this logic, since the latter provides richer functionality overall.
 */
final public class VimeoSessionManager: AFHTTPSessionManager, SessionManaging {
    
    // MARK: Initialization
    
    /**
     Creates a new session manager
     
     - parameter baseUrl: The base URL for the HTTP client
     - parameter sessionConfiguration: Object describing the URL session policies for this session manager
     - parameter requestSerializer:    Serializer to use for all requests handled by this session manager
     
     - returns: an initialized `VimeoSessionManager`
     */
    required public init(
        baseUrl: URL,
        sessionConfiguration: URLSessionConfiguration,
        requestSerializer: VimeoRequestSerializer
    ) {
        super.init(baseURL: baseUrl, sessionConfiguration: sessionConfiguration)
        
        self.requestSerializer = requestSerializer
        self.responseSerializer = VimeoResponseSerializer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func invalidate() {
        self.invalidateSessionCancelingTasks(false)
    }
    
    public func request(
        with endpoint: EndpointType,
        then callback: @escaping (SessionManagingResponse<Any>) -> Void
    ) -> Cancelable? {
        let path = endpoint.uri
        let parameters = endpoint.parameters
        
        let success: SessionManagingDataTaskSuccess = { dataTask, value in
            let response = SessionManagingResponse(task: dataTask, value: value, error: nil)
            callback(response)
        }
        
        let failure: SessionManagingDataTaskFailure = { dataTask, error in
            let response = SessionManagingResponse<Any>(task: dataTask, value: nil, error: error)
            callback(response)
        }
        
        switch endpoint.method {
        case .get:
            return self.get(path, parameters: parameters, progress: nil, success: success, failure: failure)
        case .post:
            return self.post(path, parameters: parameters, progress: nil, success: success, failure: failure)
        case .put:
            return self.put(path, parameters: parameters, success: success, failure: failure)
        case .patch:
            return self.patch(path, parameters: parameters, success: success, failure: failure)
        case .delete:
            return self.delete(path, parameters: parameters, success: success, failure: failure)
        case .connect, .head, .options, .trace:
            return nil
        }                
    }
}

extension VimeoSessionManager: AuthenticationListeningDelegate {
    // MARK: - Authentication
    
    /**
     Called when authentication completes successfully to update the session manager with the new access token
     
     - parameter account: the new account
     */
    public func clientDidAuthenticate(with account: VIMAccount) {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
        else {
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
    public func clientDidClearAccount() {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
            else {
            return
        }
        
        requestSerializer.accessTokenProvider = nil
    }    
}
