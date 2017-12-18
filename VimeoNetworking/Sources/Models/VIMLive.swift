//
//  VIMLive.swift
//  VimeoNetworking
//
//  Created by Van Nguyen on 08/29/2017.
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

/// The streaming status of a live video.
///
/// - unavailable: The RTMP link is visible but not yet able to receive the stream.
/// - pending: Vimeo is working on setting up the connection.
/// - ready: The RTMP's URL is ready to receive video content.
/// - streamingPreview: The stream is in a "preview" state. It will be accessible to the public when you transition to "streaming".
/// - streaming: The stream is open and receiving content.
/// - streamingError: The stream has failed due to an error relating to the broadcaster; They may have reached their monthly broadcast limit, for example.
/// - archiving: The stream has finished, and the video is in the process of being archived, but is not ready to play yet.
/// - archiveError: There was a problem archiving the stream.
/// - done: The stream has been ended intentionally by the end-user.
public enum LiveStreamingStatus: String
{
    case unavailable = "unavailable"
    case pending = "pending"
    case ready = "ready"
    case streamingPreview = "streaming_preview"
    case streaming = "streaming"
    case streamingError = "streaming_error"
    case archiving = "archiving"
    case archiveError = "archive_error"
    case done = "done"
}

/// An object that represents the `live` field in
/// a `clip` response.
public class VIMLive: VIMModelObject
{
    private struct Constants
    {
        static let ChatKey = "chat"
    }
    
    /// The RTMP link is visible but not yet able to receive the stream.
    public static let LiveStreamStatusUnavailable = "unavailable"
    
    /// Vimeo is working on setting up the connection.
    public static let LiveStreamStatusPending = "pending"
    
    /// The RTMP's URL is ready to receive video content.
    public static let LiveStreamStatusReady = "ready"
    
    /// The stream is in a "preview" state. It will be accessible to the public when you transition to "streaming".
    public static let LiveStreamStatusStreamingPreview = "streaming_preview"
    
    /// The stream is open and receiving content.
    public static let LiveStreamStatusStreaming = "streaming"
    
    /// The stream has failed due to an error relating to the broadcaster; They may have reached their monthly broadcast limit, for example.
    public static let LiveStreamStatusStreamingError = "streaming_error"
    
    /// The stream has finished, and the video is in the process of being archived, but is not ready to play yet.
    public static let LiveStreamStatusArchiving = "archiving"
    
    /// There was a problem archiving the stream.
    public static let LiveStreamStatusArchiveError = "archive_error"
    
    /// The stream has been ended intentionally by the end-user.
    public static let LiveStreamStatusDone = "done"
    
    /// An RTMP link used to host a live stream.
    @objc dynamic public private(set) var link: String?
    
    /// A token for streaming.
    @objc dynamic public private(set) var key: String?
    
    /// The timestamp that the stream is active.
    @objc dynamic public private(set) var activeTime: NSDate?
    
    /// The timestamp that the stream is over.
    @objc dynamic public private(set) var endedTime: NSDate?
    
    /// The timestamp that the live video is
    /// archived.
    @objc dynamic public private(set) var archivedTime: NSDate?
    
    /// The timestamp that the live video is
    /// scheduled to be online.
    @objc dynamic public private(set) var scheduledStartTime: NSDate?
    
    /**
        The status of the live video in string.
     
        - Note:
        Technically, this property should not be used to
        check the status of a live video. Use
        `liveStreamingStatus` instead for easy checking.
     */
    @objc dynamic public private(set) var status: String?
    
    /// The status of the live video in `LiveStreamingStatus` enum.
    public var liveStreamingStatus: LiveStreamingStatus?
    {
        guard let status = self.status else
        {
            return nil
        }
        
        return LiveStreamingStatus(rawValue: status)
    }
    
    /// The live event's chat.
    public private(set) var chat: VIMLiveChat?
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass?
    {
        if key == Constants.ChatKey
        {
            return VIMLiveChat.self
        }
        
        return nil
    }
}
