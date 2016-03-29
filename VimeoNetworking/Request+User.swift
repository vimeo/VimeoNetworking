//
//  Request+Me.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

typealias UserRequest = Request<VIMUser>
typealias UserListRequest = Request<[VIMUser]>

extension Request
{
    private static var MeUserURI: String { return "/me" }
    private static var FollowingPathFormat: String { return "%@/following" }
    
    static func getMe() -> Request
    {
        return self.getUser(userURI: self.MeUserURI)
    }
    
    static func getMeFollowing() -> Request
    {
        return self.getUserFollowing(userURI: self.MeUserURI)
    }
    
    static func getUser(userURI userURI: String) -> Request
    {
        return Request(path: userURI)
    }
    
    static func getUserFollowing(userURI userURI: String) -> Request
    {
        return Request(path: String(format: self.FollowingPathFormat, userURI))
    }
}