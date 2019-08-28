//
//  UserItem.swift
//  VimeoNetworking
//
//  Created by Song, Alexander on 8/09/19.
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
public class UserItem: VIMModelObject {

    public convenience init(video: VIMVideo) {
        self.init(userItemType: .video)
        self.video = video
    }

    public convenience init(folder: Folder) {
        self.init(userItemType: .folder)
        self.folder = folder
    }

    private convenience init(userItemType: UserItemType) {
        self.init()
        self.userItemType = userItemType
        self.type = userItemType.rawValue
    }

    /// The `Folder` for the `UserItem` if one exists
    public internal(set) var folder: Folder?

    /// The item type for the `UserItem` represented by a string
    public internal(set) var type: String?

    /// The item type for the `UserItem`, mapped to a Swift-only enum
    public internal(set) var userItemType: UserItemType?

    /// The video of the `UserItem` if one exists
    public internal(set) var video: VIMVideo?

    public override func didFinishMapping() {
        if let type = type {
            userItemType = UserItemType(rawValue: type)
        }
    }

    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        return Mappings.classesByEncodingKeys[key]
    }
}

extension UserItem {
    public enum UserItemType: String {
        case folder
        case video
    }

    private struct Mappings {
        static let classesByEncodingKeys = [
            "folder": Folder.self,
            "video": VIMVideo.self
        ]
    }
}
