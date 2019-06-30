//
//  Scope.swift
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

/// An access token has one or more scopes, or general domains. The scopes determine the types of access that token
/// does and doesn't permit. During the authentication process, you can specify exactly which scopes your app needs
/// based on the cases below. If you try to make an API request with an access token that doesn't have the right scope,
/// the API will deny the request.
///
/// - Public: Access public member data.
/// - Private: Access private member data. Required for any scope other than public.
/// - Purchased: Access a member's Vimeo On Demand purchase history.
/// - Create: Create new Vimeo resources like albums, groups, channels, and portfolios. To create new videos, you need the upload scope.
/// - Edit: Edit existing Vimeo resources, including videos.
/// - Delete: Delete existing Vimeo resources, including videos.
/// - Interact: Interact with Vimeo resources, such as liking a video or following a member.
/// - Upload: Upload videos.
/// - Stats: Receive live-related statistics.
/// - PromoCodes: Add, remove, and review Vimeo On Demand promotions.
/// - VideoFiles: Access video files belonging to members with Vimeo PRO membership or higher.
///
/// - Note: An authenticated access token with the `public` scope is identical to an unauthenticated access token,
///         except that you can use the `/me` endpoint to refer to the currently logged-in user. Accessing `/me` with
///         an unauthenticated access token generates an error.
public enum Scope: String, CaseIterable {
    case Public = "public"
    case Private = "private"
    case Purchased = "purchased"
    case Create = "create"
    case Edit = "edit"
    case Delete = "delete"
    case Interact = "interact"
    case Upload = "upload"
    case Stats = "stats"
    case PromoCodes = "promo_codes"
    case VideoFiles = "video_files"
    case Email = "email"
    
    /// Combines an array of scopes into a scope string as expected by the API.
    ///
    /// - Parameter scopes: An array of `Scope` values
    /// - Returns: A string of space-separated scope strings
    public static func combine(_ scopes: [Scope]) -> String {
        return scopes.map({ $0.rawValue }).joined(separator: " ")
    }
}
