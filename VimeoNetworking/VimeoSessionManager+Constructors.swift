//
//  VimeoSessionManager+Constructors.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/29/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

extension VimeoSessionManager
{
    // MARK: - Default Session Initialization
    
    static func defaultSessionManager(authToken authToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: { authToken })
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    static func defaultSessionManager(accessTokenProvider accessTokenProvider: VimeoRequestSerializer.AccessTokenProvider) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: accessTokenProvider)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    static func defaultSessionManager(appConfiguration appConfiguration: AppConfiguration) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let requestSerializer = VimeoRequestSerializer(appConfiguration: appConfiguration)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    // MARK: - Background Session Initialization
    
    static func backgroundSessionManager(identifier identifier: String, authToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = self.backgroundSessionConfiguration(identifier: identifier)
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: { authToken })
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    static func backgroundSessionManager(identifier identifier: String, accessTokenProvider: VimeoRequestSerializer.AccessTokenProvider) -> VimeoSessionManager
    {
        let sessionConfiguration = self.backgroundSessionConfiguration(identifier: identifier)
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: accessTokenProvider)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    static func backgroundSessionManager(identifier identifier: String, appConfiguration: AppConfiguration) -> VimeoSessionManager
    {
        let sessionConfiguration = self.backgroundSessionConfiguration(identifier: identifier)
        let requestSerializer = VimeoRequestSerializer(appConfiguration: appConfiguration)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
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