//
//  UploadGCSTests.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 11/9/18.
//  Copyright © 2018 Vimeo. All rights reserved.
//

import XCTest
import OHHTTPStubs
import VimeoNetworking

class UploadGCSTests: XCTestCase
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
    
    func test_uploadGCSResponse_getsParsedIntoUploadObject()
    {
        let request = Request<VIMUpload>(path: "/videos/" + Constants.CensoredId)
        
        stub(condition: isPath("/videos/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("upload_gcs.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response
            {
            case .success(let result):
                let upload = result.model
                
                XCTAssertEqual(upload.uploadApproach, VIMUpload.UploadApproach(rawValue: "gcs"))
                XCTAssertNotNil(upload.gcs?.first)
                XCTAssertEqual(upload.gcs?.first?.startByte?.int64Value, 0)
                XCTAssertEqual(upload.gcs?.first?.endByte?.int64Value, 377296827)
                XCTAssertEqual(upload.gcs?.first?.uploadLink, "https://www.google.com")
                XCTAssertNotNil(upload.gcs?.first?.connections[.uploadAttempt])
                
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
