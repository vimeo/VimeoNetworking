//
//  Request+Me.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
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

/// `Request` that returns a single `VIMUser`
public typealias UserRequest = Request<VIMUser>

/// `Request` that returns an array of `VIMUser`
public typealias UserListRequest = Request<[VIMUser]>

public extension Request {
    private static var MeUserURI: String { return "/me" }
    private static var FollowingPathFormat: String { return "%@/following" }
    private static var FollowersPathFormat: String { return "%@/followers" }
    private static var UsersPath: String { return "/users" }

    private static var QueryKey: String { return "query" }
    
    /**
     Create a request to get the current user
     
     - returns: a new `Request`
     */
    static func getMeRequest() -> Request {
        return self.getUserRequest(userURI: self.MeUserURI)
    }
    
    /**
     Create a request to get the current user's following list
     
     - returns: a new `Request`
     */
    static func getMeFollowingRequest() -> Request {
        return self.getUserFollowingRequest(forUserURI: self.MeUserURI)
    }
    
    /**
     Create a request to get the current user's followers list
     
     - returns: a new `Request`
     */
    static func getMeFollowersRequest() -> Request {
        return self.getUserFollowersRequest(forUserURI: self.MeUserURI)
    }
    
    /**
     Create a request to get a specific user
     
     - parameter userURI: the specific user's URI
     
     - returns: a new `Request`
     */
    static func getUserRequest(userURI: String) -> Request {
        return Request(path: userURI)
    }
    
    /**
     Create a request to get a specific user's following list
     
     - parameter userURI: the specific user's URI
     
     - returns: a new `Request`
     */
    static func getUserFollowingRequest(forUserURI userURI: String) -> Request {
        return Request(path: String(format: self.FollowingPathFormat, userURI))
    }
    
    /**
     Create a request to get a specific user's followers list
     
     - parameter userURI: the specific user's URI
     
     - returns: a new `Request`
     */
    static func getUserFollowersRequest(forUserURI userURI: String) -> Request {
        return Request(path: String(format: self.FollowersPathFormat, userURI))
    }
    
    // MARK: - Search
    
    /**
     Create a request to search for users
     
     - parameter query:       the string query to use for the search
     - parameter refinements: optionally, search refinement parameters to add to the query
     
     - returns: a new `Request`
     */
    static func queryUsers(withQuery query: String, refinements: VimeoClient.RequestParametersDictionary? = nil) -> Request {
        var parameters = refinements ?? [:]
        
        parameters[self.QueryKey] = query
        
        return Request(path: self.UsersPath, parameters: parameters)
    }
    
    // MARK: - Edit User
    
    /**
     Create a request to edit a user's metadata
     
     - parameter userURI:    the URI of the user to edit
     - parameter parameters: the updated parameters
     
     - returns: the new `Request`
     */
    static func patchUser(withUserURI userURI: String, parameters: VimeoClient.RequestParametersDictionary) -> Request {
        return Request(method: .patch, path: userURI, parameters: parameters)
    }
}
