//
//  Scope.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/23/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

enum Scope: String
{
    case Public = "public"       // View public videos
    case Private = "private"     // View private videos
    case Purchased = "purchased" // View Vimeo On Demand purchase history
    case Create = "create"       // Create new videos, groups, albums, etc.
    case Edit = "edit"           // Edit videos, groups, albums, etc.
    case Delete = "delete"       // Delete videos, groups, albums, etc.
    case Interact = "interact"   // Interact with a video on behalf of a user, such as liking a video or adding it to your watch later queue
    case Upload = "upload"       // Upload a video
    
    static func combine(scopes: [Scope]) -> String
    {
        return scopes.reduce("") { $0 + " " + $1.rawValue }
    }
}