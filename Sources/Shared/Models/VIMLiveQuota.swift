//
//  VIMLiveQuota.swift
//  VimeoNetworking
//
//  Created by Van Nguyen on 09/11/2017.
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

public enum LiveQuotaStatus: String, CaseIterable {
    case available = "available"
    case privateMode = "private_mode"
    case streamLimit = "stream_limit"
    case timeLimit = "time_limit"
}

/// An object that represents the `live_quota`
/// field in a `user` response.
public class VIMLiveQuota: VIMModelObject {
    private struct Constants {
        static let StreamsKey = "streams"
        static let TimeKey = "time"
    }
    
    /// The `streams` field in a `live_quota` response.
    @objc dynamic public private(set) var streams: VIMLiveStreams?
    
    /// The `time` field in a `live_quota` response.
    @objc dynamic public private(set) var time: VIMLiveTime?

    /// The `status` field in a `live_quota` response.
    @objc dynamic public private(set) var status: String?

    /// The status of the live quota in `LiveQuotaStatus` enum.
    public var liveQuotaStatus: LiveQuotaStatus? {
        guard
            let stringValue = self.status,
            let quotaStatus = LiveQuotaStatus(rawValue: stringValue) else {
            return nil
        }

        return quotaStatus
    }

    override public func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == Constants.StreamsKey {
            return VIMLiveStreams.self
        }
        
        if key == Constants.TimeKey {
            return VIMLiveTime.self
        }
        
        return nil
    }
}
