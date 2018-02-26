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
import OHHTTPStubs

class VIMLiveQuotaTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.12"))
    }
    
    override func tearDown()
    {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func testParsingLiveQuotaObject()
    {
        let request = Request<VIMUser>(path: "/users/" + Constants.CensoredId)
        
        stub(condition: isPath("/users/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("user_live.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.sharedClient.request(request) { response in
            switch response
            {
            case .success(let result):
                let user = result.model
                
                XCTAssertNotNil(user.liveQuota)
                XCTAssertNotNil(user.liveQuota?.streams)
                XCTAssertNotNil(user.liveQuota?.time)
                XCTAssertEqual(user.liveQuota?.streams?.maxStreams, 1)
                XCTAssertEqual(user.liveQuota?.streams?.remainingStreams, 1)
                XCTAssertEqual(user.liveQuota?.time?.maxTimePerEvent, 300)
                XCTAssertEqual(user.liveQuota?.time?.maxTimePerMonth, 300)
                XCTAssertEqual(user.liveQuota?.time?.remainingTimeThisMonth, 17259)
                
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
