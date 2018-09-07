//
//  RequestTests.swift
//  VimeoNetworkingExample-iOSTests, VimeoNetworkingExample-tvOSTests
//
//  Created by Westendorf, Mike on 5/21/17.
//  Copyright © 2016 Vimeo. All rights reserved.
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
@testable import VimeoNetworking

class RequestTests: XCTestCase
{
    let retryPolicyTestClosure = { (policyToTest: RetryPolicy, comparePolicy: RetryPolicy) -> Bool in
        switch policyToTest
        {
        case .singleAttempt:
            switch comparePolicy
            {
            case .singleAttempt:
                return true
            default:
                return false
            }
        default:
            if case .multipleAttempts(let attemptCount, let initialDelay) = policyToTest,
                case .multipleAttempts(let testValueCount, let testDelay) = comparePolicy
            {
                return attemptCount == testValueCount && initialDelay == testDelay
            }
            
            return false
        }
    }
    
    func test_RetryPolicy_DefaultPolicyForMethodShouldReturnSingleAttempt()
    {
        var defaultPolicy = RetryPolicy.defaultPolicyForMethod(for: .GET)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(defaultPolicy, .singleAttempt), "RetryPolicy.defaultPolicyForMethod should return singleAttempt for all methods")
        
        defaultPolicy = RetryPolicy.defaultPolicyForMethod(for: .POST)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(defaultPolicy, .singleAttempt), "RetryPolicy.defaultPolicyForMethod should return singleAttempt for all methods")

        defaultPolicy = RetryPolicy.defaultPolicyForMethod(for: .PUT)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(defaultPolicy, .singleAttempt), "RetryPolicy.defaultPolicyForMethod should return singleAttempt for all methods")

        defaultPolicy = RetryPolicy.defaultPolicyForMethod(for: .PATCH)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(defaultPolicy, .singleAttempt), "RetryPolicy.defaultPolicyForMethod should return singleAttempt for all methods")
        
        defaultPolicy = RetryPolicy.defaultPolicyForMethod(for: .DELETE)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(defaultPolicy, .singleAttempt), "RetryPolicy.defaultPolicyForMethod should return singleAttempt for all methods")
    }
    
    func test_RetryPolicy_TryThreeTimesConstHasCorrectValues()
    {
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(RetryPolicy.TryThreeTimes, .multipleAttempts(attemptCount: 3, initialDelay: 2.0)), "TryThreeTimes const should be .multipleAttempts(3, 2.0), actually returned \(RetryPolicy.TryThreeTimes)")
    }
    
    func test_Request_DefaultValues()
    {
        let testPath = "/test/path"
        let request = Request<VIMNullResponse>(path: testPath)

        XCTAssertEqual(request.path, testPath)
        XCTAssertEqual(request.URI, testPath)

        XCTAssertTrue(RequestComparisons.ValidateDefaults(request: request))
    }
    
    func test_Request_setValuesThroughConstructor()
    {
        let testPath = "/test"
        let request = Request<VIMNullResponse>(method: .POST,
                                               path: testPath,
                                               parameters: ["param" : "test field"],
                                               modelKeyPath: "data",
                                               useCache: true,
                                               cacheResponse: true,
                                               retryPolicy: RetryPolicy.TryThreeTimes)
        
        XCTAssertEqual(request.path, testPath)
        XCTAssertEqual(request.URI, "/test?param=test%20field")
        XCTAssertTrue(request.cacheResponse)
        XCTAssertEqual(request.method, .POST)
        XCTAssertEqual(request.useCache, true)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(request.retryPolicy, .multipleAttempts(attemptCount: 3, initialDelay: 2.0)))
    }
    
    func test_Request_AssociatedPageRequest()
    {
        let request = Request<VIMNullResponse>(path: "/test")
        let associatedRequest = request.associatedPageRequest(withNewPath: "/test?next_page=2")
        
        XCTAssertEqual(request.path, associatedRequest.path)
        XCTAssertEqual(request.method, associatedRequest.method)
        XCTAssertEqual(request.modelKeyPath, associatedRequest.modelKeyPath)
        XCTAssertEqual(request.cacheResponse, associatedRequest.cacheResponse)
        XCTAssertEqual(request.useCache, associatedRequest.useCache)
        XCTAssertTrue(RequestComparisons.CompareRetryPolicies(request.retryPolicy, associatedRequest.retryPolicy), "")
        
        let params = associatedRequest.parameters as! VimeoClient.RequestParametersDictionary
        XCTAssertEqual(params["next_page"] as! String, "2")
    }
}
