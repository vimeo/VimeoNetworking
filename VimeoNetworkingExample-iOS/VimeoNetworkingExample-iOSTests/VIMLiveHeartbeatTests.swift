//
//  VIMLiveHeartbeatTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Nguyen, Van on 10/4/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import XCTest
import OHHTTPStubs
import VimeoNetworking

class VIMLiveHeartbeatTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.13"))
    }
    
    override func tearDown()
    {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func testParsingLiveHeartbeatObject()
    {
        let request = Request<VIMVideo>(path: "/videos/224357160")
        
        stub(condition: isPath("/videos/224357160")) { _ in
            let stubPath = OHPathForFile("clip_live.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response
            {
            case .success(let result):
                let video = result.model
                
                let liveHeartbeat = video.playRepresentation?.hlsFile?.live
                
                XCTAssertNotNil(liveHeartbeat)
                XCTAssertEqual(liveHeartbeat?.heartbeatUrl, "https://api.vimeo.com/videos/236661678/heartbeat/hls/1507067883/3082903e82078a78bd146ca542899a124e1c47fe")
                
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0) { error in
            if let unWrappedError = error
            {
                XCTFail("\(unWrappedError)")
            }
        }
    }
}
