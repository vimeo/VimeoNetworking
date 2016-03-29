//
//  Request+Authentication.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/23/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

private let GrantTypeKey = "grant_type"
private let ScopeKey = "scope"
private let CodeKey = "code"
private let RedirectURIKey = "redirect_uri"
private let UsernameKey = "username"
private let PasswordKey = "password"
private let DisplayNameKey = "display_name"
private let EmailKey = "email"
private let TokenKey = "token"

private let GrantTypeClientCredentials = "client_credentials"
private let GrantTypeAuthorizationCode = "authorization_code"
private let GrantTypePassword = "password"
private let GrantTypeFacebook = "facebook"

private let AuthenticationPathClientCredentials = "/oauth/authorize/client"
private let AuthenticationPathAccessToken = "oauth/authorize/password"
private let AuthenticationPathUsers = "users"
private let AuthenticationPathFacebookToken = "oauth/authorize/facebook"
private let AuthenticationPathCodeGrant = "oauth/access_token"

typealias AuthenticationRequest = Request<VIMAccountNew>

extension Request
{
    static func postClientCredentialsGrant(scopes scopes: [Scope]) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [GrantTypeKey: GrantTypeClientCredentials,
                                                         ScopeKey: Scope.combine(scopes)]
        
        return Request(method: .POST, path: AuthenticationPathClientCredentials, parameters: parameters)
    }
    
    static func postCodeGrant(code code: String, redirectURI: String) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [GrantTypeKey: GrantTypeAuthorizationCode,
                                                         CodeKey: code,
                                                         RedirectURIKey: redirectURI]
        
        return Request(method: .POST, path: AuthenticationPathCodeGrant, parameters: parameters)
    }
    
    static func postLogin(username username: String, password: String, scopes: [Scope]) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [GrantTypeKey: GrantTypePassword,
                                                         ScopeKey: Scope.combine(scopes),
                                                         UsernameKey: username,
                                                         PasswordKey: password]
        
        return Request(method: .POST, path: AuthenticationPathAccessToken, parameters: parameters)
    }
    
    static func postJoin(name name: String, email: String, password: String, scopes: [Scope]) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [ScopeKey: Scope.combine(scopes),
                                                         DisplayNameKey: name,
                                                         EmailKey: email,
                                                         PasswordKey: password]
        
        return Request(method: .POST, path: AuthenticationPathUsers, parameters: parameters)
    }
    
    static func postLoginFacebook(facebookToken facebookToken: String, scopes: [Scope]) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [GrantTypeKey: GrantTypeFacebook,
                                                         ScopeKey: Scope.combine(scopes),
                                                         TokenKey: facebookToken]
        
        return Request(method: .POST, path: AuthenticationPathFacebookToken, parameters: parameters)
    }
    
    static func postJoinFacebook(facebookToken facebookToken: String, scopes: [Scope]) -> Request
    {
        let parameters: VimeoClient.RequestParameters = [ScopeKey: Scope.combine(scopes),
                                                         TokenKey: facebookToken]
        
        return Request(method: .POST, path: AuthenticationPathUsers, parameters: parameters)
    }
}