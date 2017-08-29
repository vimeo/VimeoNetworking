//
//  VIMLiveTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Nguyen, Van on 8/29/17.
//  Copyright © 2017 Vimeo. All rights reserved.
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
        XCTAssertEqual(video.live?.status, .streaming)
    }
}
