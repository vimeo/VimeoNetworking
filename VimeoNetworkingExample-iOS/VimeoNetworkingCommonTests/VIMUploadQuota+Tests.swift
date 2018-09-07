//
//  VIMUploadQuota+Tests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Westendorf, Michael on 7/11/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import XCTest
@testable import VimeoNetworking

class VIMUploadQuota_Tests: XCTestCase
{
    func test_UploadQuota_ValidData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.space?.free, 100)
        XCTAssertEqual(quota.space?.max, 500)
        XCTAssertEqual(quota.space?.used, 400)
    }
    
    func test_UploadQuota_BadQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.space?.free, 100)
        XCTAssertEqual(quota.space?.max, 500)
        XCTAssertEqual(quota.space?.used, 400)
    }
    
    func test_UploadQuota_MissingQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.space?.free, 100)
        XCTAssertEqual(quota.space?.max, 500)
        XCTAssertEqual(quota.space?.used, 400)
    }

    func test_UploadQuota_EmptyQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.space?.free, 100)
        XCTAssertEqual(quota.space?.max, 500)
        XCTAssertEqual(quota.space?.used, 400)
    }
}
