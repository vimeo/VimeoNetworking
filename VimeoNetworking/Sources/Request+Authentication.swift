//
//  Request+Authentication.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/23/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

private let GrantTypeKey = "grant_type"
private let ScopeKey = "scope"
private let CodeKey = "code"
private let RedirectURIKey = "redirect_uri"
private let UsernameKey = "username"
private let PasswordKey = "password"
private let DisplayNameKey = "display_name"
private let EmailKey = "email"
private let TokenKey = "token"
private let PinCodeKey = "user_code"
private let DeviceCodeKey = "device_code"
private let AccessTokenKey = "access_token"

private let GrantTypeClientCredentials = "client_credentials"
private let GrantTypeAuthorizationCode = "authorization_code"
private let GrantTypePassword = "password"
private let GrantTypeFacebook = "facebook"
private let GrantTypePinCode = "device_grant"

private let AuthenticationPathClientCredentials = "oauth/authorize/client"
private let AuthenticationPathAccessToken = "oauth/authorize/password"
private let AuthenticationPathAccessTokenVerify = "oauth/verify"
private let AuthenticationPathUsers = "users"
private let AuthenticationPathFacebookToken = "oauth/authorize/facebook"
private let AuthenticationPathCodeGrant = "oauth/access_token"
private let AuthenticationPathPinCode = "oauth/device"
private let AuthenticationPathPinCodeAuthorize = "oauth/device/authorize"
private let AuthenticationPathAppTokenExchange = "oauth/appexchange"


// MARK: -

private let AuthenticationPathTokens = "/tokens"

typealias AuthenticationRequest = Request<VIMAccount>

extension Request where ModelType: VIMAccount
{
    /**
     Construct a `Request` for client credentials grant authentication
     
     - parameter scopes: an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func clientCredentialsGrantRequest(scopes scopes: [Scope]) -> Request
    {
        let parameters = [GrantTypeKey: GrantTypeClientCredentials,
                          ScopeKey: Scope.combine(scopes)]
        
        return Request(method: .POST, path: AuthenticationPathClientCredentials, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for code grant (redirect) authentication
     
     - parameter code:        the authorization code returned by the API
     - parameter redirectURI: the URI used to relaunch your application
     
     - returns: a new `Request`
     */
    static func codeGrantRequest(code code: String, redirectURI: String) -> Request
    {
        let parameters = [GrantTypeKey: GrantTypeAuthorizationCode,
                          CodeKey: code,
                          RedirectURIKey: redirectURI]
        
        return Request(method: .POST, path: AuthenticationPathCodeGrant, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for logging in with an email and password (Vimeo internal use only)
     
     - parameter email:    the user email
     - parameter password: the user password
     - parameter scopes:   an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func logInRequest(email email: String, password: String, scopes: [Scope]) -> Request
    {
        let parameters = [GrantTypeKey: GrantTypePassword,
                          ScopeKey: Scope.combine(scopes),
                          UsernameKey: email,
                          PasswordKey: password]
        
        return Request(method: .POST, path: AuthenticationPathAccessToken, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for verifying a given access token
    
     - returns: a new `Request`
     */
    static func verifyAccessTokenRequest() -> Request
    {
        return Request(method: .GET, path: AuthenticationPathAccessTokenVerify, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for joining with a name, email, and password (Vimeo internal use only)
     
     - parameter name:     the new user name
     - parameter email:    the new user email
     - parameter password: the new user password
     - parameter scopes:   an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func joinRequest(name name: String, email: String, password: String, scopes: [Scope]) -> Request
    {
        let parameters = [ScopeKey: Scope.combine(scopes),
                          DisplayNameKey: name,
                          EmailKey: email,
                          PasswordKey: password]
        
        return Request(method: .POST, path: AuthenticationPathUsers, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for logging in with Facebook (Vimeo internal use only)
     
     - parameter facebookToken: the token returned by the Facebook SDK
     - parameter scopes:        an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func logInFacebookRequest(facebookToken facebookToken: String, scopes: [Scope]) -> Request
    {
        let parameters = [GrantTypeKey: GrantTypeFacebook,
                          ScopeKey: Scope.combine(scopes),
                          TokenKey: facebookToken]
        
        return Request(method: .POST, path: AuthenticationPathFacebookToken, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for joining with Facebook (Vimeo internal use only)
     
     - parameter facebookToken: the token returned by the Facebook SDK
     - parameter scopes:        an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func joinFacebookRequest(facebookToken facebookToken: String, scopes: [Scope]) -> Request
    {
        let parameters = [ScopeKey: Scope.combine(scopes),
                          TokenKey: facebookToken]
        
        return Request(method: .POST, path: AuthenticationPathUsers, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` for completing authentication on a connected device with a pin code (Vimeo internal use only)
     
     - parameter userCode:   the pin code presented to the user
     - parameter deviceCode: the device code returned by the api in the initial pin code request
     
     - returns: a new `Request`
     */
    static func authorizePinCodeRequest(userCode userCode: String, deviceCode: String) -> Request
    {
        let parameters = [PinCodeKey: userCode,
                          DeviceCodeKey: deviceCode]
        
        return Request(method: .POST, path: AuthenticationPathPinCodeAuthorize, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
    
    /**
     Construct a `Request` to exchange an app token granted to another Vimeo application for a new token granted to the calling application (Vimeo internal use only)
     
     - parameter accessToken: the app token that needs to be exchanged
     
     - returns: a new `Request`
     */
    static func appTokenExchangeRequest(accessToken accessToken: String) -> Request
    {
        let parameters = [AccessTokenKey: accessToken]
        
        return Request(method: .POST, path: AuthenticationPathAppTokenExchange, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
}

extension Request where ModelType: VIMNullResponse
{
    /**
     Construct a `Request` for deleting the current token
     
     - returns: a new `Request`
     */
    public static func deleteTokensRequest() -> Request
    {
        return Request(method: .DELETE, path: AuthenticationPathTokens, retryPolicy: .TryThreeTimes)
    }
    
    /**
     Construct a `Request` for resetting the user's password
     
     - parameter email: the user's email
     
     - returns: a new `Request`
     */
    public static func resetPasswordRequest(withEmail email: String) -> Request
    {
        let path = "/users/" + email + "/password/reset"
        
        return Request(method: .POST, path: path)
    }
}

// MARK: -

typealias PinCodeRequest = Request<PinCodeInfo>

extension Request where ModelType: PinCodeInfo
{
    /**
     Construct a `Request` for initiating authentication on a connected device with a pin code (Vimeo internal use only)
     
     - parameter scopes: an array of `Scope` values representing permissions your app requests
     
     - returns: a new `Request`
     */
    static func getPinCodeRequest(scopes scopes: [Scope]) -> Request
    {
        let parameters = [GrantTypeKey: GrantTypePinCode,
                          ScopeKey: Scope.combine(scopes)]
        
        return Request(method: .POST, path: AuthenticationPathPinCode, parameters: parameters, cacheFetchPolicy: .NetworkOnly, shouldCacheResponse: false)
    }
}
