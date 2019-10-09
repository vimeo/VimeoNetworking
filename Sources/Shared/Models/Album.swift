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

@objc public class AlbumEmbed: VIMObjectMapper {
    @objc public var html: String?
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
            static let Pictures = "pictures"
            static let Metadata = "metadata"
            static let Connections = "connections"
            static let Interactions = "interactions"
        }
        
        struct Value {
            static let Name = "albumName"
            static let Description = "albumDescription"
            static let Logo = "albumLogo"
            static let CreatedTime = "createdTimeString"
            static let ModifiedTime = "modifiedTimeString"
            static let VideoThumbnails = "videoThumbnails"
            static let Password = "password"
        }
        
        struct Class {
            static let PictureCollection = VIMPictureCollection.self
            static let Privacy = VIMPrivacy.self
            static let User = VIMUser.self
            static let Embed = AlbumEmbed.self
            static let MutableDictionary = NSMutableDictionary.self
        }
        
        struct Collections {
            static let Pictures = "pictures"
            static let Array = NSArray.self
        }
    }
    
    @objc public var albumName: String?
    @objc public var albumDescription: String?
    @objc public var albumLogo: VIMPictureCollection?
    @objc public var createdTimeString: String?
    @objc public var createdTime: Date?
    @objc public var modifiedTimeString: String?
    @objc public var modifiedTime: Date?
    @objc public var privacy: VIMPrivacy?
    @objc public var duration: NSNumber?
    @objc public var uri: String?
    @objc public var link: String?
    @objc public var embed: AlbumEmbed?
    @objc public var videoThumbnails: NSArray?
    @objc public var user: VIMUser?
    @objc public var theme: String?
    @objc private var metadata: [String: Any]?
    @objc private var connections: [String: Any]?
    @objc private var interactions: [String: Any]?
    
    public override func getObjectMapping() -> Any? {
        return [
            Constant.Key.Name : Constant.Value.Name,
            Constant.Key.Description : Constant.Value.Description,
            Constant.Key.Logo : Constant.Value.Logo,
            Constant.Key.CreatedTime : Constant.Value.CreatedTime,
            Constant.Key.ModifiedTime : Constant.Value.ModifiedTime,
            Constant.Key.Pictures : Constant.Value.VideoThumbnails
        ]
    }
    
    public override func getClassForObjectKey(_ key: String?) -> AnyClass? {
        switch key {
        case Constant.Key.User:
            return Constant.Class.User
        case Constant.Key.Privacy:
            return Constant.Class.Privacy
        case Constant.Key.Logo:
            return Constant.Class.PictureCollection
        case Constant.Key.Embed:
            return Constant.Class.Embed
        case Constant.Key.Metadata:
            return Constant.Class.MutableDictionary
        default:
            return nil
        }
    }
    
    public override func getClassForCollectionKey(_ key: String?) -> AnyClass? {
        switch key {
        case Constant.Collections.Pictures:
            return Constant.Class.PictureCollection
        default:
            return nil
        }
    }
    
    public override func didFinishMapping() {
        self.createdTime = self.formatDate(from: self.createdTimeString)
        self.modifiedTime = self.formatDate(from: self.modifiedTimeString)
        self.parseConnections()
        self.parseInteractions()
    }
    
    public func connection(named connectionName: String) -> VIMConnection? {
        return self.connections?[connectionName] as? VIMConnection
    }

    public func interaction(named interactionName: String) -> VIMInteraction? {
        return self.interactions?[interactionName] as? VIMInteraction
    }
    
    // MARK: - Convenience
    
    public func isPasswordProtected() -> Bool {
        return self.privacy?.view == Constant.Value.Password
    }
    
    // MARK: - Private

    private func parseConnections() {
        guard let dictionary = self.metadata?[Constant.Key.Connections] as? [String: Any] else { return }
        
        var connections = [String: Any]()
        for (key, value) in dictionary {
            if let valueDict = value as? [String: Any] {
                connections[key] = VIMConnection(keyValueDictionary: valueDict)
            }
        }
        self.connections = connections
    }

    private func parseInteractions() {
        guard let dictionary = self.metadata?[Constant.Key.Interactions] as? [String: Any] else { return }

        var interactions = [String: Any]()
        for (key, value) in dictionary {
            if let valueDict = value as? [String: Any] {
                interactions[key] = VIMInteraction(keyValueDictionary: valueDict)
            }
        }
        self.interactions = dictionary
    }
    
    private func formatDate(from dateString: String?) -> Date? {
        guard let dateString = dateString,
            let date = VIMModelObject.dateFormatter().date(from: dateString) else {
                return nil
        }
        
        return date
    }
}
