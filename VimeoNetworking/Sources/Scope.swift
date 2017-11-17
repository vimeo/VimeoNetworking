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

import Foundation

/// `Scope` describes a permission that your application requests from the API
public enum Scope: String
{
    /// View public videos
    case Public = "public"
    
    /// View private videos
    case Private = "private"
    
    /// View Vimeo On Demand purchase history
    case Purchased = "purchased"
    
    /// Create new videos, groups, albums, etc.
    case Create = "create"
    
    /// Edit videos, groups, albums, etc.
    case Edit = "edit"
    
    /// Delete videos, groups, albums, etc.
    case Delete = "delete"
    
    /// Interact with a video on behalf of a user, such as liking a video or adding it to your watch later queue
    case Interact = "interact"
    
    /// Upload a video
    case Upload = "upload"
    
    /// Receive live-related statistics.
    case Stats = "stats"
    
    /**
     Combines an array of scopes into a scope string as expected by the api
     
     - parameter scopes: an array of `Scope` values
     
     - returns: a string of space-separated scope strings
     */
    public static func combine(_ scopes: [Scope]) -> String
    {
        return scopes.map({ $0.rawValue }).joined(separator: " ")
    }
}
