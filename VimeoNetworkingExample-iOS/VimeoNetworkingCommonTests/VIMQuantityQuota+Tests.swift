//
//  VIMQuantityQuota+Tests.swift
//  VimeoNetworkingExample-iOSTests, VimeoNetworkingExample-tvOSTests
//
//  Created by Westendorf, Mike on 7/10/17.
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

class VIMQuantityQuota_Tests: XCTestCase
{
    func test_QuantityQuota_ValidDataReturnsCorrectValues()
    {
        let json = ["hd" : 1, "sd" : 0]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMQuantityQuota
        
        XCTAssertTrue(quota.canUploadHd)
        XCTAssertFalse(quota.canUploadSd)
    }
    
    func test_QuantityQuota_NilValues_ReturnFalse()
    {
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: ["hd" : NSNull(), "sd" : NSNull()]) as VIMQuantityQuota
        
        XCTAssertFalse(quota.canUploadHd)
        XCTAssertFalse(quota.canUploadSd)
    }
    
    func test_QuantityQuota_EmptyStrings_ReturnFalse()
    {
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: ["hd" : "", "sd" : ""]) as VIMQuantityQuota
        
        XCTAssertFalse(quota.canUploadHd)
        XCTAssertFalse(quota.canUploadSd)
    }
    
    func test_QuantityQuota_Dictionary_ReturnFalse()
    {
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: ["hd" : NSDictionary(), "sd" : NSDictionary()]) as VIMQuantityQuota
        
        XCTAssertFalse(quota.canUploadHd)
        XCTAssertFalse(quota.canUploadSd)
    }
}
