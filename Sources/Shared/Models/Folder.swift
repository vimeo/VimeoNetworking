//
//  Folder.swift
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

public class Folder: VIMModelObject, ConnectionsProviding, ConnectionsParsing {
    
    /// The created time for the `Folder`
    @objc public private(set) var createdTime: NSDate?
    
    /// The meta data for the `Folder`
    @objc internal var metadata: Metadata?
    
    /// The modified time for the `Folder`
    @objc public private(set) var modifiedTime: NSDate?

    /// The modified time by the user for the `Folder`
    @objc public private(set) var lastUserActionEventDate: NSDate?
    
    /// The name for the `Folder`
    @objc public private(set) var name: String?
    
    /// The resource key for the `Folder`
    @objc public private(set) var resourceKey: String?
    
    /// The Slack webhook ID
    @objc public private(set) var slackIncomingWebhooksId: NSNumber?
    
    /// The Slack integration channel
    @objc public private(set) var slackIntegrationChannel: String?
    
    /// The Slack language preference for notifications on channel
    @objc public private(set) var slackLanguagePreference: String?
    
    /// The user preferences for Slack notifications
    @objc public private(set) var slackUserPreferences: [String]?
    
    /// The URI for the `Folder`
    @objc public private(set) var uri: String?
    
    /// The user that owns the `Folder`
    @objc public private(set) var user: VIMUser?
    
    /// The connections associated with the `Folder`
    public internal(set) var connections: [Folder.ConnectionKeys: VIMConnection] = [:]
    
    /// The Slack language preference for the `Folder`, mapped to a Swift-only enum
    public private(set) var languagePreference: SlackLanguagePreference?
    
    /// The Slack user preferences for the `Folder`, mapped to a Swift-only enum
    public private(set) var userPreferences: [SlackUserPreferences]?

    // MARK: - VIMModelObject overrides
    
    public override func didFinishMapping() {
        
        if let metadata = self.metadata {
            self.connections = self.parse(metadata)
        }
        
        if let slackLanguagePreferenceString = self.slackLanguagePreference {
            self.languagePreference = SlackLanguagePreference(rawValue: slackLanguagePreferenceString)
        }
        
        if let slackUserPreferences = self.slackUserPreferences {
            self.userPreferences = slackUserPreferences.compactMap { SlackUserPreferences(rawValue: $0) }
        }
    }
    
    public override func getObjectMapping() -> Any {
        return Mappings.membersByEncodingKeys
    }
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        return Mappings.classesByEncodingKeys[key]
    }
}

extension Folder {
    
    struct Mappings {
        
        static let membersByEncodingKeys = [
            "created_time": "createdTime",
            "modified_time": "modifiedTime",
            "last_user_action_event_date": "lastUserActionEventDate",
            "resource_key": "resourceKey",
            "slack_incoming_webhooks_id": "slackIncomingWebhooksId",
            "slack_integration_channel": "slackIntegrationChannel"
        ]
        
        static let classesByEncodingKeys = [
            "user": VIMUser.self
        ]
    }
}

// MARK: - ConnectionsParsing

extension Folder {
    
    public enum ConnectionKeys: String, MetadataKeys {
        case videos
        case teamMembers = "team_members"
    }
    
    var connectionMapping: [Folder.ConnectionKeys: VIMConnection.Type] {
        return [:]
    }
}

// MARK: - Nested Types

extension Folder {
    
    public enum SlackLanguagePreference: String {
        case de = "de-DE"
        case en
        case es
        case fr = "fr-FR"
        case ja = "ja-JP"
        case ko = "ko-KR"
        case pt = "pt-BR"
    }
    
    public enum SlackUserPreferences: String {
        case collectionChange = "COLLECTION_CHANGE"
        case privacyChange = "PRIVACY_CHANGE"
        case reviewPage = "REVIEW_PAGE"
        case videoDetail = "VIDEO_DETAIL"
    }
}
