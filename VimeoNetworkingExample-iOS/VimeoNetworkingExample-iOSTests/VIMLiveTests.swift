//
//  VIMLiveTests.swift
//  VimeoNetworkingExample-iOS
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

import XCTest
import VimeoNetworking

struct TestingUtility
{
    static func videoObjectFromFile(named fileName: String) -> VIMVideo
    {
        do
        {
            guard let fileURL = Bundle(for: VIMLiveTests.self).url(forResource: fileName, withExtension: nil) else
            {
                assertionFailure("Error: Cannot locate test file!")
                return VIMVideo()
            }
            
            let data = try Data(contentsOf: fileURL)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            let mapper = VIMObjectMapper()
            mapper.addMappingClass(VIMVideo.self, forKeypath: "")
            
            guard let video = mapper.applyMapping(toJSON: json) as? VIMVideo else
            {
                assertionFailure("Error: Cannot map JSON data to VIMVideo!")
                return VIMVideo()
            }
            
            return video
        }
        catch let error
        {
            assertionFailure("Error: \(error.localizedDescription)")
            return VIMVideo()
        }
    }
}

class VIMLiveTests: XCTestCase
{
    func testParsingLiveObject()
    {
        let video = TestingUtility.videoObjectFromFile(named: "clip_live.json")
        XCTAssertNotNil(video.live)
        XCTAssertEqual(video.live?.link, "rtmp://rtmp.cloud.vimeo.com/live?token=b23a326b-eb96-432d-97d5-122afa3a4e47")
        XCTAssertEqual(video.live?.key, "42f9947e-6bb6-4119-bc37-8ee9d49c8567")
        XCTAssertEqual(video.live?.activeTime?.description, "2017-08-01T18:18:44+00:00")
        XCTAssertNil(video.live?.endedTime)
        XCTAssertNil(video.live?.archivedTime)
        XCTAssertEqual(video.live?.liveStreamingStatus, .streaming)
    }
}
