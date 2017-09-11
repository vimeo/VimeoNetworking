//
//  VIMLiveQuotaTests.swift
//  VimeoNetworkingExample-iOS
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

import XCTest
import VimeoNetworking

class VIMLiveQuotaTests: XCTestCase
{
    func testParsingLiveQuotaObject()
    {
        let user = TestingUtility<VIMUser>.objectFromFile(named: "user_live.json")
        XCTAssertNotNil(user.liveQuota)
        XCTAssertNotNil(user.liveQuota?.streams)
        XCTAssertNotNil(user.liveQuota?.time)
        XCTAssertEqual(user.liveQuota?.streams?.maxStreams, 1)
        XCTAssertEqual(user.liveQuota?.streams?.remainingStreams, 1)
        XCTAssertEqual(user.liveQuota?.time?.maxTimePerEvent, 300)
        XCTAssertEqual(user.liveQuota?.time?.maxTimePerMonth, 300)
        XCTAssertEqual(user.liveQuota?.time?.remainingTimeThisMonth, 17259)
    }
}
