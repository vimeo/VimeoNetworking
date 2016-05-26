//
//  VimeoSessionManager+Constructors.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/29/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

public extension VimeoSessionManager
{
    // MARK: - Default Session Initialization
    
    /**
     Creates an authenticated session manager with a static access token
     
     - parameter accessToken: the static access token to use for request serialization
     
     - returns: an initialized `VimeoSessionManager`
     */
    static func defaultSessionManager(accessToken accessToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfigurationNoCache()
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: { accessToken })
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    /**
     Creates a session manager with a block that provides an access token.  Note that if no access token is returned by the provider block, no Authorization header will be serialized with new requests, whereas a Basic Authorization header is required at minimum for all api endpoints.  For unauthenticated requests, use a constructor that accepts an `AppConfiguration`.
     
     - parameter accessTokenProvider: a block that provides an access token dynamically, called on each request serialization
     
     - returns: an initialized `VimeoSessionManager`
     */
    static func defaultSessionManager(accessTokenProvider accessTokenProvider: VimeoRequestSerializer.AccessTokenProvider) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfigurationNoCache()
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: accessTokenProvider)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    /**
     Creates an unauthenticated session manager with a static application configuration
     
     - parameter appConfiguration: configuration used to generate the basic authentication header
     
     - returns: an initialized `VimeoSessionManager`
     */
    static func defaultSessionManager(appConfiguration appConfiguration: AppConfiguration) -> VimeoSessionManager
    {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfigurationNoCache()
        let requestSerializer = VimeoRequestSerializer(appConfiguration: appConfiguration)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    // MARK: - Background Session Initialization
    
    /**
     Creates an authenticated background session manager with a static access token
     
     - parameter identifier: the background session identifier
     - parameter accessToken: the static access token to use for request serialization
     
     - returns: an initialized `VimeoSessionManager`
     */
    static func backgroundSessionManager(identifier identifier: String, accessToken: String) -> VimeoSessionManager
    {
        let sessionConfiguration = self.backgroundSessionConfiguration(identifier: identifier)
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: { accessToken })
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    
    /**
     Creates a background session manager with a block that provides an access token.  Note that if no access token is returned by the provider block, no Authorization header will be serialized with new requests, whereas a Basic Authorization header is required at minimum for all api endpoints.  For unauthenticated requests, use a constructor that accepts an `AppConfiguration`.
     
     - parameter identifier: the background session identifier
     - parameter accessTokenProvider: a block that provides an access token dynamically, called on each request serialization
     
     - returns: an initialized `VimeoSessionManager`
     */
    static func backgroundSessionManager(identifier identifier: String, accessTokenProvider: VimeoRequestSerializer.AccessTokenProvider) -> VimeoSessionManager
    {
        let sessionConfiguration = self.backgroundSessionConfiguration(identifier: identifier)
        let requestSerializer = VimeoRequestSerializer(accessTokenProvider: accessTokenProvider)
        
        return VimeoSessionManager(sessionConfiguration: sessionConfiguration, requestSerializer: requestSerializer)
    }
    
    /**
     Creates an unauthenticated background session manager with a static application configuration
     
     - parameter identifier: the background session identifier
     - parameter appConfiguration: configuration used to generate the basic authentication header
     
     - returns: an initialized `VimeoSessionManager`
     */
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