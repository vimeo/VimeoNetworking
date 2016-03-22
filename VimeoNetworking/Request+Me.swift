//
//  Request+Me.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

extension Request
{
    static func meRequest() -> Request
    {
        return Request(path: "/me")
    }
    
    static func meFollowingRequest() -> Request
    {
        return Request(path: "/me/following")
    }
}