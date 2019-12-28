//
//  Request+Apple.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 11/21/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

extension AuthenticationRequest {

    /// Constructs a `Request` for Signing in with Apple. For internal use only.
    ///
    /// - Parameters:
    ///   - userIdentifier: the `user` stable identifier returned by `ASAuthorizationAppleIDCredential`
    ///   - token: the short-lived `authorizationCode` used to validate the authentication request
    ///   - scopes: array of `Scope` values representing permissions for app requests
    /// - Returns: new `VIMAccount` specialized `Request`
    public static func logInWithApple(
        usingIdentifier userIdentifier: String,
        token: String,
        scopes: [Scope]
    ) -> Request {
        let parameters: [String: String] = [
            .grantTypeKey: .grantTypeValue,
            .scopeKey: Scope.combine(scopes),
            .appleUserIdentifier: userIdentifier,
            .appleToken: token
        ]
        return Request(method: .post, path: .authenticationPathAppleToken, parameters: parameters)
    }

    /// Constructs a `Request` for Signing in with Apple. For internal use only.
    ///
    /// - Parameters:
    ///   - userIdentifier: the `user` stable identifier returned by `ASAuthorizationAppleIDCredential`
    ///   - token: the short-lived `authorizationCode` used to validate the authentication request
    ///   - marketingOptIn: bool indicating whether a user has opted-in to receive marketing material
    ///   - scopes: array of `Scope` values representing permissions for app requests
    /// - Returns: new `VIMAccount` specialized `Request`
    public static func joinWithApple(
        usingIdentifier userIdentifier: String,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String,
        token: String,
        marketingOptIn: Bool,
        scopes: [Scope]
    ) -> Request {
        var parameters: [String: Any] = [
            .scopeKey: Scope.combine(scopes),
            .appleUserIdentifier: userIdentifier,
            .appleToken: token,
            .emailKey: email,
            .marketingOptIn: marketingOptIn
        ]
        parameters[.firstNameKey] = firstName
        parameters[.lastNameKey] = lastName
        return Request(method: .post, path: .authenticationPathUsers, parameters: parameters)
    }

}

private extension String {
    static let appleUserIdentifier = "apple_user_identifier"
    static let appleToken = "apple_jwt"
    static let authenticationPathAppleToken = "/oauth/authorize/apple"
    static let authenticationPathUsers = "/users"
    static let emailKey = "email"
    static let firstNameKey = "first_name"
    static let grantTypeKey = "grant_type"
    static let grantTypeValue = "apple"
    static let lastNameKey = "last_name"
    static let scopeKey = "scope"
    static let marketingOptIn = "marketing_opt_in"
}
