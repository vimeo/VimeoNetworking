//
//  VIMLiveHeartbeat.swift
//  VimeoNetworking
//
//  Created by Van Nguyen on 10/04/2017.
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

/// An object representing the `live` object in either an `hls` or a `dash` response.
public class VIMLiveHeartbeat: VIMModelObject
{
    private struct Constants
    {
        static let HeartbeatUrlKey = "heartbeat"
    }
    
    /// The heartbeat URL that the client should send requests to.
    @objc dynamic public private(set) var heartbeatUrl: String?
    
    override public func getObjectMapping() -> Any?
    {
        return [Constants.HeartbeatUrlKey: "heartbeatUrl"]
    }
}
