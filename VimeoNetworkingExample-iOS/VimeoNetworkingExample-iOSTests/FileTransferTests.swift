//
//  FileTransferTests.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 2/12/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import XCTest
import OHHTTPStubs

class FileTransferTests: XCTestCase {

    override func setUp() {
        
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.10"), configureSessionManagerBlock: nil)
        
        stub(condition: isPath("/videos/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("clip.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }

    override func tearDown() {
        
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }

    func testParsingFileTransferResponse() {
        let request = Request<VIMVideo>(path: "/videos/" + Constants.CensoredId)
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response
            {
            case .success(let result):
                let video = result.model
                
                XCTAssertNotNil(video.fileTransfer, "\"fileTransfer\" response should have been not nil.")
                XCTAssertEqual(video.fileTransfer!.url, URL(string: "www.google.com"), "\"url\" should have been \"www.google.com\".")
                
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
