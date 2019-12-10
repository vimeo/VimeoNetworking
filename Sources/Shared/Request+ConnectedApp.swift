//
//  Request+ConnectedApp.swift
//  VimeoNetworking
//
//  Copyright © 2019 Vimeo. All rights reserved.
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

public extension Request {

    /// Returns a fetch request of all connected apps for the authenticated user.
    static func connectedApps() -> Request {
        return Request(path: .connectedAppsURI)
    }

    /// Returns a fetch request for a single connected app.
    /// - Parameter appType: The `ConnectedAppType` to fetch data for.
    static func connectedApp(_ appType: ConnectedAppType) -> Request {
        return Request(path: .connectedAppsURI + appType.stringValue)
    }

    /// Returns a `put` request for connecting the provided app type to the current authenticated user's account.
    /// - Parameters:
    ///   - appType: The app platform for which the connection will be established.
    ///   - token: An authentication token from the provided platfrom, used to establish the connection.
    static func connect(to appType: ConnectedAppType, with token: String) -> Request {
        let uri: String = .connectedAppsURI + appType.stringValue

        var tokenKey: String
        switch appType {
        case .twitter:
            tokenKey = .accessTokenSecret
        case .facebook, .linkedin, .youtube:
            tokenKey = .authCode
        }

        let parameters = [tokenKey: token]

        return Request(method: .put, path: uri, parameters: parameters)
    }

    /// Returns a request to `delete` the connection to the specified app.
    /// - Parameter appType: The `ConnectedAppType` to disassociate from the authenticated user.
    static func deleteConnectedApp(_ appType: ConnectedAppType) -> Request {
        let uri: String = .connectedAppsURI + appType.stringValue
        return Request(method: .delete, path: uri)
    }
}

private extension String {
    static let appType = "app_type"
    static let connectedAppsURI = "/me/connected_apps/"

    /// Token request parameter key for Facebook.
    static let accessToken = "access_token"

    /// Token request parameter key for Twitter.
    static let accessTokenSecret = "access_token_secret"

    /// Token request parameter key for LinkedIn and YouTube.
    static let authCode = "auth_code"
}
