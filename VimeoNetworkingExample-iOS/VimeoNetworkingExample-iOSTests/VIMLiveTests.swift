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
    }
}
