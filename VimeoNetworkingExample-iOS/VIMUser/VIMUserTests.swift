//
//  VIMUserTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Van Nguyen on 12/12/2017.
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
import OHHTTPStubs
@testable import VimeoNetworking

class VIMUserTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.10"))
    }
    
    override func tearDown()
    {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    private func stubResponse(withFile fileName: String)
    {
        stub(condition: isPath("/users/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile(fileName, type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    private func checkReturnedAccountType(withExpectedType expectedType: VIMUserAccountType, andExpectation expectation: XCTestExpectation)
    {
        let request = Request<VIMUser>(path: "/users/" + Constants.CensoredId)
        
        _ = VimeoClient.sharedClient.request(request, completion: { (response) in
            switch response
            {
            case .success(let result):
                XCTAssertEqual(result.model.accountType, expectedType)
                
                let analyticsIdentifier = result.model.accountTypeAnalyticsIdentifier()
                switch expectedType
                {
                case .basic:
                    XCTAssertEqual(analyticsIdentifier, "basic")
                case .plus:
                    XCTAssertEqual(analyticsIdentifier, "plus")
                case .pro:
                    XCTAssertEqual(analyticsIdentifier, "pro")
                case .business:
                    XCTAssertEqual(analyticsIdentifier, "business")
                case .livePro:
                    XCTAssertEqual(analyticsIdentifier, "live_pro")
                case .liveBusiness:
                    XCTAssertEqual(analyticsIdentifier, "live_business")
                case .livePremium:
                    XCTAssertEqual(analyticsIdentifier, "live_premium")
                case .proUnlimited:
                    XCTAssertEqual(analyticsIdentifier, "pro_unlimited")
                case .producer:
                    XCTAssertEqual(analyticsIdentifier, "producer")
                }
                
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testUserObjectReturningLiveProForAccountType()
    {
        self.stubResponse(withFile: "user_live_pro.json")
        let expectation = self.expectation(description: "Expectation for Live Pro User Object")
        self.checkReturnedAccountType(withExpectedType: .livePro, andExpectation: expectation)
    }
    
    func testUserObjectReturningLiveBusinessForAccountType()
    {
        self.stubResponse(withFile: "user_live_business.json")
        let expectation = self.expectation(description: "Expectation for Live Business User Object")
        self.checkReturnedAccountType(withExpectedType: .liveBusiness, andExpectation: expectation)
    }
    
    func testUserObjectReturningLivePremiumForAccountType()
    {
        self.stubResponse(withFile: "user_live_premium.json")
        let expectation = self.expectation(description: "Expectation for Live Premium User Object")
        self.checkReturnedAccountType(withExpectedType: .livePremium, andExpectation: expectation)
    }
    
    func testUserObjectReturningBasicForAccountType()
    {
        self.stubResponse(withFile: "user_basic.json")
        let expectation = self.expectation(description: "Expectation for Basic User Object")
        self.checkReturnedAccountType(withExpectedType: .basic, andExpectation: expectation)
    }
    
    func testUserObjectReturningPlusForAccountType()
    {
        self.stubResponse(withFile: "user_plus.json")
        let expectation = self.expectation(description: "Expectation for Plus User Object")
        self.checkReturnedAccountType(withExpectedType: .plus, andExpectation: expectation)
    }
    
    func testUserObjectReturningProForAccountType()
    {
        self.stubResponse(withFile: "user_pro.json")
        let expectation = self.expectation(description: "Expectation for Pro User Object")
        self.checkReturnedAccountType(withExpectedType: .pro, andExpectation: expectation)
    }
    
    func testUserObjectReturningBusinessForAccountType()
    {
        self.stubResponse(withFile: "user_business.json")
        let expectation = self.expectation(description: "Expectation for Business User Object")
        self.checkReturnedAccountType(withExpectedType: .business, andExpectation: expectation)
    }

    func testUserObjectReturningProUnlimitedForAccountType()
    {
        self.stubResponse(withFile: "user_pro_unlimited.json")
        let expectation = self.expectation(description: "Expectation for Pro Unlimited User Object")
        self.checkReturnedAccountType(withExpectedType: .proUnlimited, andExpectation: expectation)
    }

    func testUserObjectReturningProducerForAccountType()
    {
        self.stubResponse(withFile: "user_producer.json")
        let expectation = self.expectation(description: "Expectation for Pro Unlimited User Object")
        self.checkReturnedAccountType(withExpectedType: .producer, andExpectation: expectation)
    }
}
