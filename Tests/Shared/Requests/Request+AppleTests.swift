//
//  Request+AppleTests.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 11/22/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import XCTest
import VimeoNetworking

class Request_AppleTests: XCTestCase {

    let identifier = "USER_IDENTIFIER"
    let token = "APPLE_TOKEN"
    let scopes = [Scope.Create, .Delete]

    func testJoinRequest() throws {
        // Given, when
        let request = AuthenticationRequest.joinWithApple(
            usingIdentifier: identifier,
            token: token,
            marketingOptIn: true,
            scopes: scopes
        )

        // Then
        guard let parameters = request.parameters as? [String: Any] else {
            XCTFail("Unexpected parameters type encountered.")
            return
        }

        XCTAssertEqual(request.path, "/users")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(parameters["scope"] as? String, "create delete")
        XCTAssertEqual(parameters["marketing_opt_in"] as? Bool, true)
        XCTAssertEqual(parameters["apple_jwt"] as? String, token)
        XCTAssertEqual(parameters["apple_user_identifier"] as? String, identifier)
    }

    func testLoginRequest() throws {
        // Given, when
        let request = AuthenticationRequest.logInWithApple(
            usingIdentifier: identifier,
            token: token,
            scopes: scopes
        )

        // Then
        guard let parameters = request.parameters as? [String: Any] else {
            XCTFail("Unexpected parameters type encountered.")
            return
        }
        
        XCTAssertEqual(request.path, "/oauth/authorize/apple")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(parameters["scope"] as? String, "create delete")
        XCTAssertEqual(parameters["apple_jwt"] as? String, token)
        XCTAssertEqual(parameters["apple_user_identifier"] as? String, identifier)
        XCTAssertEqual(parameters["grant_type"] as? String, "apple")
    }
}
