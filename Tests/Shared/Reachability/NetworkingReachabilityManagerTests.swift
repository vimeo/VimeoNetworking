//
//  NetworkingReachabilityManagerTests.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 8/29/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import XCTest
@testable import VimeoNetworking

class NetworkingReachabilityManagerTests: XCTestCase {

    func test_Initializer_InstanceIsNotNull_WhenInitializedFromHost() {
        // Given, When
        let manager = NetworkReachabilityManager(host: "localhost")
        
        // Then
        XCTAssertNotNil(manager)
    }

    func test_Initializer_InstanceIsNotNull_WhenInitializedFromAddress() {
        // Given, When
        let manager = NetworkReachabilityManager()

        // Then
        XCTAssertNotNil(manager)
    }

    func test_InitializedFromHost_StartsWithReachableOnWiFi() {
        // Given, When
        let manager = NetworkReachabilityManager(host: "localhost")

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
        XCTAssertEqual(manager?.isReachable, true)
        XCTAssertEqual(manager?.isReachableOnCellular, false)
        XCTAssertEqual(manager?.isReachableOnEthernetOrWiFi, true)
    }

    func test_DefaultInitializer_StartsWithReachableOnWifi() {
        // Given, When
        let manager = NetworkReachabilityManager()

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
        XCTAssertEqual(manager?.isReachable, true)
        XCTAssertEqual(manager?.isReachableOnCellular, false)
        XCTAssertEqual(manager?.isReachableOnEthernetOrWiFi, true)
    }

    func test_DefaultInitializedInstance_CanBeProperlyRestarted() {
        // Given
        let manager = NetworkReachabilityManager()
        let first = expectation(description: "first listener notified")
        let second = expectation(description: "second listener notified")

        // When
        manager?.startListening { (status) in
            first.fulfill()
        }
        wait(for: [first], timeout: 1)

        manager?.stopListening()

        manager?.startListening { (status) in
            second.fulfill()
        }
        wait(for: [second], timeout: 1)

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
    }

    func test_HostInitializedInstance_CanBeProperlyRestarted() {
        // Given
        let manager = NetworkReachabilityManager(host: "localhost")
        let first = expectation(description: "first listener notified")
        let second = expectation(description: "second listener notified")

        // When
        manager?.startListening { (status) in
            first.fulfill()
        }
        wait(for: [first], timeout: 1)

        manager?.stopListening()

        manager?.startListening { (status) in
            second.fulfill()
        }
        wait(for: [second], timeout: 1)

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
    }

    func testThatHostManagerCanBeDeinitialized() {
        // Given
        var manager = NetworkReachabilityManager(host: "localhost")

        // When
        manager = nil

        // Then
        XCTAssertNil(manager)
    }

    func testThatAddressManagerCanBeDeinitialized() {
        // Given
        var manager: NetworkReachabilityManager? = NetworkReachabilityManager()

        // When
        manager = nil

        // Then
        XCTAssertNil(manager)
    }

    // MARK: - Listener

    func test_HostInitializer_StartListening_ClosureIsCalled_WhenStartListeningIsCalled() {
        // Given
        guard let manager = NetworkReachabilityManager(host: "localhost") else {
            XCTFail("manager should NOT be nil")
            return
        }

        let expectation = self.expectation(description: "listener closure should be executed")
        var networkReachabilityStatus: NetworkReachabilityStatus?

        // When
        manager.startListening { status in
            guard networkReachabilityStatus == nil else { return }
            networkReachabilityStatus = status
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertEqual(networkReachabilityStatus, .reachable(.ethernetOrWiFi))
    }

    func test_DefaultInitializer_StartListening_ClosureIsCalled_WhenStartListeningIsCalled() {
        // Given
        let manager = NetworkReachabilityManager()
        let expectation = self.expectation(description: "listener closure should be executed")

        var networkReachabilityStatus: NetworkReachabilityStatus?

        // When
        manager?.startListening { status in
            networkReachabilityStatus = status
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertEqual(networkReachabilityStatus, .reachable(.ethernetOrWiFi))
    }
}
