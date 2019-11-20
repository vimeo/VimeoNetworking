//
//  TeamMember.swift
//  VimeoNetworking
//
//  Created by Song, Alexander on 6/10/19.
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

import Foundation

@objcMembers
public class TeamMember: VIMModelObject, ConnectionsProviding, ConnectionsParsing {
    
    /// The created time for the `TeamMember`
    public private(set) var createdTime: NSDate?
    
    /// The `TeamMember`'s email
    public private(set) var email: String?
    
    /// Determines whether the `TeamMember` has access to the `Folder`
    public private(set) var hasFolderAccess: Bool?
    
    /// URL user must open to join team
    public private(set) var inviteUrl: String?
    
    /// Time at which the invitee was accepted as a `TeamMember`
    public private(set) var joinedTime: NSDate?
    
    /// The metadata containing associated connections
    internal var metadata: Metadata?
    
    /// The time at which membership was last modified
    public private(set) var modifiedTime: NSDate?
    
    /// The `TeamMember`'s permission level
    public private(set) var permissionLevel: String?
    
    /// The team membership resource key
    public private(set) var resourceKey: String?
    
    /// The `TeamMember`'s role
    public private(set) var role: String?
    
    /// The status of the `TeamMember`'s status
    public private(set) var status: String?
    
    /// The unique identifier you use to access the team membership resource
    public private(set) var uri: String?
    
    /// The `VIMUser` associated with the `TeamMember`
    public private(set) var user: VIMUser?
    
    // MARK: - ConnectionsProviding
    
    public internal(set) var connections: [TeamMember.ConnectionKeys : VIMConnection] = [:]
    
    // MARK: - VIMModelObject overrides
    
    public override func didFinishMapping() {
    
        if let metadata = metadata {
            connections = parse(metadata)
        }
    }
    
    public override func getObjectMapping() -> Any? {
        return Mappings.membersByEncodingKeys
    }
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        return Mappings.classesByEncodingKeys[key]
    }
}

extension TeamMember {
    
    struct Mappings {
        
        static let membersByEncodingKeys = [
            "created_time": "createdTime",
            "has_folder_access": "hasFolderAccess",
            "invite_url": "inviteUrl",
            "joined_time": "joinedTime",
            "modified_time": "modifiedTime",
            "permission_level": "permissionLevel",
            "resource_key": "resourceKey"
        ]
        
        static let classesByEncodingKeys = [
            "user": VIMUser.self
        ]
    }
}

// MARK: - ConnectionsParsing

extension TeamMember {
    
    public enum ConnectionKeys: String, MetadataKeys {
        case owner
    }
    
    var connectionMapping: [TeamMember.ConnectionKeys: VIMConnection.Type] {
        return [.owner: TeamMemberConnection.self]
    }
}

// MARK: - Nested Types

extension TeamMember {
    
    public enum PermissionLevel: String {
        case admin = "Admin"
        case contributor = "Contributor"
        case owner = "Owner"
        case uploader = "Uploader"
    }
    
    public enum Role: String {
        case admin = "Admin"
        case contributor = "Contributor"
        case owner = "Owner"
        case uploader = "Uploader"
    }
    
    public enum Status: String {
        case accepted
        case pending
    }
}
