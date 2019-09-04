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

    func test_Initializer_StatusIsReachable_WhenInitiliazedWithReachableFlag() {
        // When initialized with a `reachable` flag
        let status = NetworkReachabilityStatus([.reachable])
        
        // Then status should be reachable with connection type ethernet or wifi
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }
        
    // Note: `isWWAN` is unavailable on macOS
    #if os(iOS) || os(tvOS) || os(watchOS)
    func test_Initializer_StatusIsReachableThroughCellular_WhenInitializedWithIsWWANFlag() {
        // When initialized with a `reachable` and `isWWAN` flags
        let status = NetworkReachabilityStatus([.reachable, .isWWAN])
        
        // Then status should be reachable with connection type cellular
        XCTAssertEqual(status, .reachable(.cellular))
    }
    #endif
    
    func test_Initializer_StatusIsNotReachable_WhenInitializedWithNoFlagsPassed() {
        // When initialized with no flags
        let status = NetworkReachabilityStatus([])
        
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }
    
    func test_Initializer_StatusIsNotReachable_WhenInitiliazedWithConnectionRequiredFlag() {
        // When initialized with reachable flag but connection required
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired])
        
        // Then status should be not reachable
        XCTAssertEqual(status, .notReachable)
    }
    
    func test_Initializer_StatusIsReachableViaEthernet_WhenInitializedWithConnectionRequired_AbleToConnectOnDemandFlags() {
        // When initialized with a reachable flag and connection required but able to connect on demand
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired, .connectionOnDemand])
        
        // Then status should be not reachable
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func test_Initialized_StatusIsNotReachable_WhenInitializedWithConnectionRequired_AbleToConnectOnDemand_WithInterventionRequiredFlags() {
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

    func test_Initializer_StatusIsReachableViaEthernet_WhenInitiliazedWithConnectionRequired_AbleToConnectOnTrafficFlags() {
        // When initialized with a reachable flag and connection required but able to connect on traffic
        let status = NetworkReachabilityStatus([.reachable, .connectionRequired, .connectionOnTraffic])
        
        // Then status should be not reachable
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func test_Initializer_StatusIsNotReachable_WhenInitializedWithConnectionRequired_AbleToConnectOnTraffic_WithInterventionFlags() {
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
