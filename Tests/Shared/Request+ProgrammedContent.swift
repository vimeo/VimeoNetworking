//
//  Request+ProgrammedContent.swift
//  VimeoNetworkingExample-iOSTests, VimeoNetworkingExample-tvOSTests
//
//  Created by Westendorf, Michael on 6/22/17.
//  Copyright © 2017 Vimeo. All rights reserved.
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
import OHHTTPStubs
import VimeoNetworking

class Request_ProgrammedContent: XCTestCase {
    override func setUp() {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                          clientSecret: "{CLIENT_SECRET}",
                                                                          scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                          keychainService: "com.vimeo.keychain_service",
                                                                          apiVersion: "3.3.1"), configureSessionManagerBlock: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func test_CinemaRequest_onSuccess_returnsCorrectData() {
        let request = CinemaContentRequest.getCinemaContentRequest()
        
        stub(condition: isPath("/programmed/cinema")) { _ in
            // Stub it with our "cinema-success-response.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("cinema-success-response.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response {
            case .success(let result):
                XCTAssertNotNil(result.model)
                
                let cinemaContent = result.model
                XCTAssertEqual(cinemaContent.count, 6)

                let cinemaNames = ["John Early's Picks", "Action Sports", "Eye Candy", "Documentary", "Comedy", "The Refugee Crisis"]
                for i in 0 ..< cinemaNames.count {
                    XCTAssertEqual(cinemaNames[i], cinemaContent[i].name)
                    XCTAssertEqual(cinemaContent[i].content?.count, 5)
                }
                
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0) { error in
            if let unWrappedError = error {
                XCTFail("\(unWrappedError)")
            }
        }
    }
    
    func test_CinemaRequest_onFailure_returnsError() {
        let request = CinemaContentRequest.getCinemaContentRequest()
        
        stub(condition: isPath("/programmed/cinema")) { _ in
            
            let fakeErrorJSON = ["link": NSNull(),
                                 "error": "You have provided an invalid parameter. Please contact developer of this application.",
                                 "developer_message": "The parameters passed to this API endpoint did not pass Vimeo\'s validation. Please check the invalid_parameters list for more information",
                                 "error_code": 2204,
                                 "invalid_parameters": [
                                    ["developer_message": "Password and/or email provided are invalid",
                                     "error": "Unable to log in Please enter a valid email address and/or password",
                                     "error_code": 2218,
                                     "field": "password"
                                    ]
                ]
            ] as [String : Any]
            
            return OHHTTPStubsResponse(jsonObject: fakeErrorJSON, statusCode: 400, headers: ["Content-Type" : "application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response {
            case .success(_):
                XCTFail("This test should not return a success")
                
            case .failure(let error as NSError):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.vimeoInvalidParametersErrorCodesString, "2218")
                XCTAssertEqual(error.vimeoServerErrorCode!, 2204)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0) { error in
            if let unWrappedError = error {
                XCTFail("\(unWrappedError)")
            }
        }
    }
}
