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
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400], "quota" : ["hd" : true, "sd" : false]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.sizeQuota?.free, 100)
        XCTAssertEqual(quota.sizeQuota?.max, 500)
        XCTAssertEqual(quota.sizeQuota?.used, 400)
        
        XCTAssertEqual(quota.quantityQuota?.canUploadHd, true)
        XCTAssertEqual(quota.quantityQuota?.canUploadSd, false)
    }
    
    func test_UploadQuota_BadQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400], "quota" : ["hd" : [:], "sd" : NSNull()]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.sizeQuota?.free, 100)
        XCTAssertEqual(quota.sizeQuota?.max, 500)
        XCTAssertEqual(quota.sizeQuota?.used, 400)
        
        XCTAssertEqual(quota.quantityQuota?.canUploadHd, false)
        XCTAssertEqual(quota.quantityQuota?.canUploadSd, false)
    }
    
    func test_UploadQuota_MissingSizeData_ParsesCorrectly()
    {
        let json = ["quota" : ["hd" : true, "sd" : true]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertNil(quota.sizeQuota)
        
        XCTAssertEqual(quota.quantityQuota?.canUploadHd, true)
        XCTAssertEqual(quota.quantityQuota?.canUploadSd, true)
    }

    func test_UploadQuota_MissingQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.sizeQuota?.free, 100)
        XCTAssertEqual(quota.sizeQuota?.max, 500)
        XCTAssertEqual(quota.sizeQuota?.used, 400)
        
        XCTAssertNil(quota.quantityQuota)
    }
    
    func test_UploadQuota_EmptyQuotaData_ParsesCorrectly()
    {
        let json = ["space" : ["free" : 100, "max" : 500, "used" : 400], "quota" : [:]]
        let quota = try! VIMObjectMapper.mapObject(responseDictionary: json) as VIMUploadQuota
        
        XCTAssertEqual(quota.sizeQuota?.free, 100)
        XCTAssertEqual(quota.sizeQuota?.max, 500)
        XCTAssertEqual(quota.sizeQuota?.used, 400)
        
        XCTAssertEqual(quota.quantityQuota?.canUploadHd, false)
        XCTAssertEqual(quota.quantityQuota?.canUploadSd, false)
    }
}
