//
//  VIMLive.swift
//  Pods
//
//  Created by Nguyen, Van on 8/29/17.
//
//

import Foundation

public enum LiveStreamingStatus: String
{
    case unavailable = "unavailable"
    case pending = "pending"
    case ready = "ready"
    case streamingPreview = "streaming_preview"
    case streaming = "streaming"
    case streamingError = "streaming_error"
    case done = "done"
}

public class VIMLive: VIMModelObject
{
    public var link: String?
    public var key: String?
    public var activeTime: NSDate?
    public var endedTime: NSDate?
    public var archivedTime: NSDate?
    
    public var status: String?
    {
        didSet
        {
            guard let status = self.status else
            {
                return
            }
            
            self.liveStreamingStatus = LiveStreamingStatus(rawValue: status)
        }
    }
    
    public var liveStreamingStatus: LiveStreamingStatus?
}
