//
//  Album.swift
//  VimeoNetworking
//
//  Created on 10/25/2018.
//  Copyright (c) Vimeo (https://vimeo.com)
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

@objc public class EmbedShare: VIMObjectMapper {
    @objc var html: String?
}

@objc public class Album: VIMModelObject {
    
    private struct Constant {
        struct Key {
            static let Name = "name"
            static let Description = "description"
            static let Logo = "custom_logo"
            static let CreatedTime = "created_time"
            static let ModifiedTime = "modified_time"
            static let User = "user"
            static let Privacy = "privacy"
            static let Embed = "embed"
        }
        
        struct Value {
            static let Name = "albumName"
            static let Description = "albumDescription"
            static let Logo = "albumLogo"
            static let CreatedTime = "createdTime"
            static let ModifiedTime = "modifiedTime"
        }
        
        struct Class {
            static let Picture = VIMPicture.self
            static let PictureCollection = VIMPictureCollection.self
            static let Privacy = VIMPrivacy.self
            static let User = VIMUser.self
            static let Embed = EmbedShare.self
        }
    }
    
    @objc public var albumName: String?
    @objc public var albumDescription: String?
    @objc public var albumLogo: VIMPictureCollection?
    @objc public var createdTime: NSDate?
    @objc public var modifiedTime: NSDate?
    @objc public var privacy: VIMPrivacy?
    @objc public var duration: NSNumber?
    @objc public var uri: String?
    @objc public var link: String?
    @objc public var embed: EmbedShare?
    @objc public var pictures: VIMPictureCollection?
    @objc public var user: VIMUser?
    @objc public var theme: String?
    
    public override func getObjectMapping() -> Any! {
        return [
            Constant.Key.Name : Constant.Value.Name,
            Constant.Key.Description : Constant.Value.Description,
            Constant.Key.Logo : Constant.Value.Logo,
            Constant.Key.CreatedTime : Constant.Value.CreatedTime,
            Constant.Key.ModifiedTime : Constant.Value.ModifiedTime
        ]
    }
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        switch key {
        case Constant.Key.User:
            return Constant.Class.User
        case Constant.Key.Privacy:
            return Constant.Class.Privacy
        case Constant.Key.Logo:
            return Constant.Class.PictureCollection
        case Constant.Key.Embed:
            return Constant.Class.Embed
        default:
            return nil
        }
    }
}