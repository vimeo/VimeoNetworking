//
//  VIMUserTests.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 12/11/17.
//  Copyright © 2017 Vimeo. All rights reserved.
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
}
