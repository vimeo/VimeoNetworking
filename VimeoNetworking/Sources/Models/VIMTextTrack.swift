//
//  VIMTextTrack.swift
//  VimeoNetworking
//
//  Created by Balatbat, Bryant on 3/18/18.
//

import Foundation

public enum TextTrackType: String
{
    case captions = "captions"
    case subtitles = "subtitles"
}

public class VIMTextTrack: VIMModelObject
{
    /// Determines if this text track is active.
    @objc dynamic public var active: Bool = false
    
    /// The readonly url of the text track file, intended for use with HLS playback.
    @objc dynamic public private(set) var hlsLink: String?
    
    /// Read-only HLS playback text track file expiration time.
    @objc dynamic public private(set) var hlsLinkExpiresTime: NSNumber?
    
    /// The language code for this text track. To see a full list, request /languages?filter=texttrack
    @objc dynamic public private(set) var language: String?
    
    /// The read-only url of the text track file. If this is the first time you created the resource, you can upload to this link.
    @objc dynamic public private(set) var link: String?
    
    /// Read-only text track file expiration time.
    @objc dynamic public private(set) var linkExpiresTime: NSNumber?
    
    /// The descriptive name of this text track.
    @objc dynamic public private(set) var name: String?
    
    /// The type of text track (caption or subtitle).
    @objc dynamic public private(set) var type: String?
    
    /// The type of text track converted to an enum.
    public var textTrackType: TextTrackType?
    {
        guard let type = self.type else
        {
            return nil
        }
        
        return TextTrackType(rawValue: type)
    }
    
    /// The container's relative URI.
    @objc dynamic public private(set) var uri: String?
    
    // MARK: - VIMModelObject
    
    override public func getObjectMapping() -> Any?
    {
        return [
            Constants.HLSLinkKey: "hlsLink",
            Constants.HLSLinkExpiresTimeKey: "hlsLinkExpiresTime",
            Constants.LinkExpiresTimeKey: "linkExpiresTime",
        ]
    }
}

private extension VIMTextTrack
{
    struct Constants
    {
        static let HLSLinkKey = "hls_link"
        static let HLSLinkExpiresTimeKey = "hls_link_expires_time"
        static let LinkExpiresTimeKey = "link_expires_time"
    }
}
