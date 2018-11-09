//
//  GCSTests.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 11/8/18.
//  Copyright © 2018 Vimeo. All rights reserved.
//

import XCTest
import OHHTTPStubs
import VimeoNetworking

class GCSTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.10"), configureSessionManagerBlock: nil)
    }
    
    func test_gcsResponse_getsParsedIntoGCSObject()
    {
        let request = Request<GCS>(path: "/videos/" + Constants.CensoredId)
        
        stub(condition: isPath("/videos/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("gcs.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response
            {
            case .success(let result):
                let gcs = result.model
                
                XCTAssertEqual(gcs.uploadLink, "https://www.google.com")
                XCTAssertEqual(gcs.startByte?.int64Value, 0)
                XCTAssertEqual(gcs.endByte?.int64Value, 377296827)
                
                let uploadAttemptConnection = gcs.connections[.uploadAttempt]
                
                XCTAssertEqual(uploadAttemptConnection?.uri, "/upload/attempt/asdf")
                XCTAssertEqual(uploadAttemptConnection?.options as? [String], ["GET"])
                
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
