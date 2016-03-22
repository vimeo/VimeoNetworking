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

typealias AuthTokenBlock = Void -> String?

class VimeoSessionManager: AFHTTPSessionManager
{    
    // MARK: - Default Session Initialization
    
    static func defaultSessionManager(authToken authToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, authToken: authToken)
    }

    static func defaultSessionManager(authTokenBlock authTokenBlock: AuthTokenBlock) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, authTokenBlock: authTokenBlock)
    }

    // MARK: - Background Session Initialization
    
    static func backgroundSessionManager(identifier identifier: String, authToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = VimeoSessionManager.backgroundSessionConfiguration(identifier: identifier)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, authToken: authToken)
    }

    static func backgroundSessionManager(identifier identifier: String, authTokenBlock: AuthTokenBlock) -> VimeoSessionManager
    {
        let sessionConfiguration = VimeoSessionManager.backgroundSessionConfiguration(identifier: identifier)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, authTokenBlock: authTokenBlock)
    }

    // MARK: Initialization
    
    convenience init(sessionConfiguration: NSURLSessionConfiguration, authToken: String)
    {
        self.init(sessionConfiguration: sessionConfiguration, authTokenBlock: { () -> String in
            return authToken
        })
    }
    
    init(sessionConfiguration: NSURLSessionConfiguration, authTokenBlock: AuthTokenBlock)
    {        
        super.init(baseURL: VimeoBaseURLString, sessionConfiguration: sessionConfiguration)
        
        self.requestSerializer = VimeoRequestSerializer(authTokenBlock: authTokenBlock)
        self.responseSerializer = VimeoResponseSerializer()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Private API
    
    // Would prefer that this live in a NSURLSessionConfiguration extension but the method name would conflict [AH] 2/5/2016
    
    private static func backgroundSessionConfiguration(identifier identifier: String) -> NSURLSessionConfiguration
    {
        let sessionConfiguration: NSURLSessionConfiguration
        
        if #available(iOS 8.0, OSX 10.10, *)
        {
            sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        }
        else
        {
            sessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfiguration(identifier)
        }

        return sessionConfiguration
    }
}
