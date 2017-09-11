//
//  VIMLiveQuota.swift
//  Pods
//
//  Created by Nguyen, Van on 9/11/17.
//
//

import Foundation

/// An object that represents the `live_quota`
/// field in a `user` response.
public class VIMLiveQuota: VIMModelObject
{
    /// The `streams` field in a `live_quota` response.
    public private(set) var streams: VIMLiveStreams?
    
    /// The `time` field in a `live_quota` response.
    public private(set) var time: VIMLiveTime?
}
