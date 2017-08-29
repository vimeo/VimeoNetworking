//
//  VIMLive.swift
//  Pods
//
//  Created by Nguyen, Van on 8/29/17.
//
//

import Foundation

enum LiveStreamingStatus: String
{
    case unavailable = "unavailable"
    case pending = "pending"
    case ready = "ready"
    case streamingPreview = "streaming_preview"
    case streaming = "streaming"
    case streamingError = "streaming_error"
    case done = "done"
}

class VIMLive: VIMModelObject
{
    var link: String?
    var key: String?
    var activeTime: Date?
    var endedTime: Date?
    var archivedTime: Date?
    var status: LiveStreamingStatus?
}
