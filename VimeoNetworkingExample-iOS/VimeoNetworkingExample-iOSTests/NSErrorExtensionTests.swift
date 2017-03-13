//
//  NSErrorExtensionTests.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 7/5/16.
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

class NSErrorExtensionTests: XCTestCase {
    
    var testApiError: NSError!
    
    override func setUp() {
        super.setUp()
        
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
        
        let fakeErrorData = try! JSONSerialization.data(withJSONObject: fakeErrorJSON, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        let userInfo = [NSLocalizedDescriptionKey: "Request failed: bad request (400)", "com.alamofire.serialization.response.error.data": fakeErrorData] as [String : Any]
        self.testApiError = NSError(domain: "com.vimeo.networking-test", code: -1011, userInfo: userInfo)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVimeoInvalidParametersErrorCodes() {
        XCTAssertEqual(self.testApiError.vimeoInvalidParametersErrorCodes.count, 1)
        XCTAssertEqual(self.testApiError.vimeoInvalidParametersErrorCodes[0], 2218)
    }
    
    func testVimeoInvalidParametersFirstErrorCode() {
        XCTAssertEqual(self.testApiError.vimeoInvalidParametersFirstErrorCode, 2218)
    }
    
    func testVimeoInvalidParametersErrorCodesString() {
        XCTAssertEqual(self.testApiError.vimeoInvalidParametersErrorCodesString, "2218")
    }
    
    func testVimeoUserMessage() {
        XCTAssertEqual(self.testApiError.vimeoUserMessage, "You have provided an invalid parameter. Please contact developer of this application.")
    }
    
    func testVimeoDeveloperMessage() {
        XCTAssertEqual(self.testApiError.vimeoDeveloperMessage, "The parameters passed to this API endpoint did not pass Vimeo\'s validation. Please check the invalid_parameters list for more information")
    }
    
    func testVimeoServerErrorCodeInJSONErrorBody() {
        XCTAssertNotNil(self.testApiError.vimeoServerErrorCode)
        XCTAssertEqual(self.testApiError.vimeoServerErrorCode!, 2204)
    }
    
    func testLegacyVimeoServerErrorCode() {
        var userInfo = self.testApiError.userInfo
        userInfo["VimeoErrorCode"] = 4101
        let error = NSError(domain: self.testApiError.domain, code: self.testApiError.code, userInfo: userInfo)
        
        XCTAssertEqual(error.vimeoServerErrorCode, 4101)
    }
    
    func testVimeoResponseHeaderServerErrorCode() {
        let fakeResponse = HTTPURLResponse(url: URL(string: "vimeo-networking-tests")!, statusCode: 403, httpVersion: "1.0", headerFields: ["Vimeo-Error-Code": "4101"])
        var userInfo = self.testApiError.userInfo
        userInfo["com.alamofire.serialization.response.error.response"] = fakeResponse
        let error = NSError(domain: self.testApiError.domain, code: self.testApiError.code, userInfo: userInfo)
        
        XCTAssertEqual(error.vimeoServerErrorCode, 4101)
    }
    
    func testLocalizedDescription() {
        XCTAssertEqual(self.testApiError.localizedDescription, "Request failed: bad request (400)")
    }
    
    func testErrorResponseBodyJSON() {
        XCTAssertNotNil(self.testApiError.errorResponseBodyJSON)
        
        let invalidParameters = self.testApiError.errorResponseBodyJSON!["invalid_parameters"]
        XCTAssertNotNil(invalidParameters)
        
        XCTAssertNotNil(invalidParameters as? NSArray)
        
        let invalidParamsDict = invalidParameters!.firstObject!!
        XCTAssertEqual(invalidParamsDict["error"], "Unable to log in Please enter a valid email address and/or password")
        XCTAssertEqual(invalidParamsDict["developer_message"], "Password and/or email provided are invalid")
        XCTAssertEqual(invalidParamsDict["error_code"], 2218)
        XCTAssertEqual(invalidParamsDict["field"], "password")
    }
    
    func testVimeoInvalidParametersFirstVimeoUserMessage() {
        XCTAssertEqual(self.testApiError.vimeoInvalidParametersFirstVimeoUserMessage, "Unable to log in Please enter a valid email address and/or password")
    }
    
}
