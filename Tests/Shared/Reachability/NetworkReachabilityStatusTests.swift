//
//  NetworkReachabilityStatusTests.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 8/28/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import XCTest
import SystemConfiguration
@testable import VimeoNetworking

class NetworkReachabilityStatusTests: XCTestCase {

    func testInitializer_IsReachable() {
        // When initialized with a `reachable` flag
        let status = NetworkReachabilityStatus([.reachable])
        // Then status should be reachable with connection type ethernet or wifi
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }
    
    func testInitializer_IsReachable_Through_WWAN() {
        // When initialized with a `reachable` and `isWWAN` flags
        let status = NetworkReachabilityStatus([.reachable, .isWWAN])
        // Then status should be reachable with connection type cellular
        XCTAssertEqual(status, .reachable(.cellular))
    }
    
    func testInitializer_WhenNoFlagsPassed() {
        // When initialized with no flags
        let status = NetworkReachabilityStatus([])
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }
    
    func testInitializer_Reachable_WithConnectionRequired() {
        // When initialized with reachable flag but connection required
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired])
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }
    
    func testInitializer_Reachable_WithConnectionRequired_AbleToConnectOnDemand() {
        // When initialized with a reachable flag and connection required but able to connect on demand
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired, .connectionOnDemand])
        // Then status should be not reachable
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func testInitializer_Reachable_WithConnectionRequired_AbleToConnectOnDemand_WithIntervention() {
        // When initialized with a reachable flag, connection required, able to connect on traffic but
        // with intervention required
        let status = NetworkReachabilityStatus([
            .reachable,
            .connectionRequired,
            .connectionOnDemand,
            .interventionRequired
        ])
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }

    func testInitializer_Reachable_WithConnectionRequired_AbleToConnectOnTraffic() {
        // When initialized with a reachable flag and connection required but able to connect on traffic
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired, .connectionOnTraffic])
        // Then status should be not reachable
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func testInitializer_Reachable_WithConnectionRequired_AbleToConnectOnTraffic_WithIntervention() {
        // When initialized with a reachable flag, connection required, able to connect on traffic but
        // with intervention required
        let status = NetworkReachabilityStatus([
            .reachable,
            .connectionRequired,
            .connectionOnTraffic,
            .interventionRequired
        ])
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }

    
}
