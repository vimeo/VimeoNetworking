//
//  Progress.swift
//  Pods
//
//  Created by Hawkins, Jason on 3/2/17.
//
//

import Foundation

/// An object representing the amount of progress for which a video has been played.
public class PlayProgress: VIMModelObject
{
    /// The time, in seconds, that the video has been viewed.
    @objc dynamic public var seconds: NSNumber?
}
