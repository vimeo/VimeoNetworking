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
    private struct TestConstants {
        static let UserUri = "/users/" + Constants.CensoredId
        static let MeUri = "/me"
    }
    
    override func setUp()
    {
        super.setUp()
        
        VimeoClient.configureSharedClient(withAppConfiguration: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.10"), configureSessionManagerBlock: nil)
    }
    
    override func tearDown()
    {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    private func stubResponse(for uri: String = TestConstants.UserUri, withFile fileName: String)
    {
        stub(condition: isPath(uri)) { _ in
            let stubPath = OHPathForFile(fileName, type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    private func userRequest() -> Request<VIMUser> {
        return Request<VIMUser>(path: TestConstants.UserUri)
    }
    
    private func checkAccountTypeAnalyticsIdentifier(for user: VIMUser, withExpectedType expectedType: VIMUserAccountType)
    {
        XCTAssertEqual(user.accountType, expectedType)
        
        let analyticsIdentifier = user.accountTypeAnalyticsIdentifier()
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
    }
    
    private func send(request: Request<VIMUser>, withDescription: String, validationClosure: @escaping ((VIMUser?) -> Void)) {
        let expectation = self.expectation(description: withDescription)
        
        _ = VimeoClient.sharedClient.request(request, completion: { response in
            switch response {
            case .success(let result):
                validationClosure(result.model)
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
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Live Pro User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .livePro)
        }
    }
    
    func testUserObjectReturningLiveBusinessForAccountType()
    {
        self.stubResponse(withFile: "user_live_business.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Live Business User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .liveBusiness)
        }
    }
    
    func testUserObjectReturningLivePremiumForAccountType()
    {
        self.stubResponse(withFile: "user_live_premium.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Live Premium User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .livePremium)
        }
    }
    
    func testUserObjectReturningBasicForAccountType()
    {
        self.stubResponse(withFile: "user_basic.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Basic User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .basic)
        }
    }
    
    func testUserObjectReturningPlusForAccountType()
    {
        self.stubResponse(withFile: "user_plus.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Plus User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .plus)
        }
    }
    
    func testUserObjectReturningProForAccountType()
    {
        self.stubResponse(withFile: "user_pro.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Pro User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .pro)
        }
    }
    
    func testUserObjectReturningBusinessForAccountType()
    {
        self.stubResponse(withFile: "user_business.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Business User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .business)
        }
    }

    func testUserObjectReturningProUnlimitedForAccountType()
    {
        self.stubResponse(withFile: "user_pro_unlimited.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Pro Unlimited User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .proUnlimited)
        }
    }

    func testUserObjectReturningProducerForAccountType()
    {
        self.stubResponse(withFile: "user_producer.json")
        let request = self.userRequest()
        self.send(request: request, withDescription: "Expectation for Pro Unlimited User Object") { user in
            self.checkAccountTypeAnalyticsIdentifier(for: user!, withExpectedType: .producer)
        }
    }
    
    func testUserObjectHasMembershipInfo() {
        self.stubResponse(for: TestConstants.MeUri, withFile: "user_plus.json")
        
        let request = Request<VIMUser>.getMeRequest()
        self.send(request: request, withDescription: "Expectation for validating membership info") { user in
            XCTAssertNotNil(user?.membership)
            XCTAssertNotNil(user?.membership?.subscription)
            XCTAssertNotNil(user?.membership?.subscription?.renewal)
            XCTAssertNotNil(user?.membership?.subscription?.trial)
        }
    }
    
    func testSubscriptionDatesAreValid() {
        self.stubResponse(for: TestConstants.MeUri, withFile: "user_plus.json")
        let request = Request<VIMUser>.getMeRequest()
        self.send(request: request, withDescription: "expectation for validating subscription dates") { user in
            XCTAssertEqual(user?.membership?.subscription?.renewal?.displayDate, "2019-06-12")
            
            let testDate = VIMModelObject.dateFormatter()?.date(from: "2019-06-12T04:00:00+00:00")
            XCTAssertEqual(user?.membership?.subscription?.renewal?.formattedRenewalDate, testDate)
        }
    }
    
    func testUserHasBeenInTrialFlag_IsSet() {
        self.stubResponse(for: TestConstants.MeUri, withFile: "user_basic_had_free_trial.json")
        let request = Request<VIMUser>.getMeRequest()
        self.send(request: request, withDescription: "expectation for validating trial flag is set") { user in
            XCTAssertTrue(user!.hasBeenInFreeTrial())
        }
    }
    
    func testUserHasBeenInTrialFlag_NotSet() {
        self.stubResponse(for: TestConstants.MeUri, withFile: "user_basic.json")
        let request = Request<VIMUser>.getMeRequest()
        self.send(request: request, withDescription: "expectation for validating trial flag is not set") { user in
            XCTAssertFalse(user!.hasBeenInFreeTrial())
        }
    }
    
    func testMembershipDisplayValue() {
        self.stubResponse(for: TestConstants.MeUri, withFile: "user_pro.json")
        let request = Request<VIMUser>.getMeRequest()
        self.send(request: request, withDescription: "expectation for validating membership display") { user in
            XCTAssertEqual(user?.membership?.display, "Pro")
        }
    }
}
