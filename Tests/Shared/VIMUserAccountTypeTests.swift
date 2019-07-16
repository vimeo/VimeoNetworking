//
//  VIMUserAccountTypeTests.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 7/16/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import XCTest
@testable import VimeoNetworking

class VIMUserAccountTypeTests: XCTestCase {
    
    func testAccountFromString() {
        // For a given string key and account type value pair
        accountTypes.forEach { key, value in
            // When I create an account type from the string key
            let accountType = VIMUserAccountType(string: key)
            // Then the account type should equal the value pair value
            XCTAssertEqual(accountType, value)
        }
    }
    
    func testUnknownStringValue() {
        // Given an unknown string value
        let stringValue = "unknownABC123test"
        // When I create an account type from it
        let accountType = VIMUserAccountType(string: stringValue)
        // Then the account type should equal .basic
        XCTAssertEqual(accountType, .basic)
    }
    
    func testCustomStringConvertible() {
        // For a given string key and account type value pair
        accountTypes.forEach { key, value in
            // When I get the string representation of the account type value
            let stringValue = value.description
            // Then it should equal the key pair value
            XCTAssertEqual(stringValue, key)
        }
    }
    
    private let accountTypes: [String: VIMUserAccountType] = [
        "basic": .basic,
        "plus": .plus,
        "pro": .pro,
        "business": .business,
        "live_pro": .livePro,
        "live_business": .liveBusiness,
        "live_premium": .livePremium,
        "pro_unlimited": .proUnlimited,
        "producer": .producer,
        "enterprise": .enterprise,
    ]
}
