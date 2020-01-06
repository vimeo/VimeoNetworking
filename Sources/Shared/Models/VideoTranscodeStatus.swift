//
//  VideoTranscodeStatus.swift
//  VimeoNetworking
//
//  Created by Nicole Lehrer on 12/9/19.
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

/// Representation of a video's transcoding status
public struct VideoTranscodeStatus: Decodable {
    
    /// Current state of transcoding
    public var state: TranscodeState
    
    /// Percentage of transcoding completed
    public var progress: Int
    
    /// Time in seconds remaining until completion
    public var timeLeft: TimeInterval
    
    /// Current state of the transcoding process
    ///
    /// - `active` - Transcoding is active and ongoing
    /// - `blocked` - Transcoding can't proceed
    /// - `exceeds_quota` - Transcoding can't proceed because the file size of the transcoded video would exceed the user's weekly quota
    /// - `exceeds_total_cap` - Transcoding can't proceed because the file size of the transcoded video would exceed the user's storage cap
    /// - `failed` - Transcoding has failed
    /// - `finishing` - Transcoding is in the completion stage
    /// - `internal_error` - Transcoding can't proceed because of an internal error
    /// - `invalid_file` - Transcoding can't proceed, because the file is invalid
    /// - `pending` - Transcoding hasn't started yet
    /// - `ready` - Transcoding is ready to start
    /// - `retrieved` - Transcoding is finished
    /// - `standby` - Transcoding is standing by
    /// - `starting` - Transcoding is in the initialization stage
    /// - `unknown` - The transcoding status is unknown
    /// - `upload_complete` - The video has uploaded, but transcoding hasn't started yet
    /// - `upload_incomplete` - The video upload was incomplete
    public enum TranscodeState: String, Decodable {
        case active
        case blocked
        case exceedsQuota = "exceeds_quota"
        case exceedsTotalCap = "exceeds_total_cap"
        case failed
        case finishing
        case internalError = "internal_error"
        case invalidFile = "invalid_file"
        case pending
        case ready
        case retrieved
        case standby
        case starting
        case unknown
        case uploadComplete = "upload_complete"
        case uploadIncomplete = "upload_incomplete"
    }
    
    private enum CodingKeys: String, CodingKey {
        case state
        case progress
        case timeLeft = "time_left"
    }
}
