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
    public private(set) var link: String?
    public private(set) var key: String?
    public private(set) var activeTime: NSDate?
    public private(set) var endedTime: NSDate?
    public private(set) var archivedTime: NSDate?
    
    public private(set) var status: String?
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
    
    public private(set) var liveStreamingStatus: LiveStreamingStatus?
}
