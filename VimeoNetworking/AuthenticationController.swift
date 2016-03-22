//
//  AuthenticationController.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/21/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

struct AuthenticationConfiguration
{
    let clientKey: String
    let clientSecret: String
    let scope: String
}

class AuthenticationController
{
    private static let ClientCredentialsPath = "oauth/authorize/client"
    private static let ClientCredentialsGrantType = "client_credentials"
    
    typealias AuthenticationCompletion = () -> Void
    
    let configuration: AuthenticationConfiguration
    let sessionManager: VimeoSessionManager
    
    init(configuration: AuthenticationConfiguration, sessionManager: VimeoSessionManager)
    {
        self.configuration = configuration
        self.sessionManager = sessionManager
    }
    
    func authenticateWithClientCredentialsGrant(completion: AuthenticationCompletion)
    {
        
    }
    
    private func authenticate(path path: String, parameters: RequestParameters, completion: AuthenticationCompletion)
    {
        
    }
}