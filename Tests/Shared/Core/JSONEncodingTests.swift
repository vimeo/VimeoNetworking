//
//  ParameterEncodingTests.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import XCTest
@testable import VimeoNetworking

class JSONParameterEncodingTestCase: XCTestCase {
    
    let urlRequest = URLRequest(url: URL(string: "https://example.com/")!)
    let encoding = JSONEncoding.default
    
    func testThatQueryAndBodyAreNilForNilParameters() throws {
        // Given an encoding request with nil parameters, When
        let URLRequest = try encoding.encode(self.urlRequest, with: nil)
        
        // Then
        XCTAssertNil(URLRequest.url?.query, "query should be nil")
        XCTAssertNil(URLRequest.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(URLRequest.httpBody, "HTTPBody should be nil")
    }
    
    func testThatNestedParametersCanBeEncoded_And_ContentTypeIsSet() throws {
        // Given
        let parameters: [String: Any] = [
            "foo": "bar",
            "baz": ["a", 1, true],
            "qux": [
                "a": 1,
                "b": [2, 2],
                "c": [3, 3, 3]
            ]
        ]
        
        // When
        let URLRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertNil(URLRequest.url?.query)
        XCTAssertNotNil(URLRequest.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertEqual(URLRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertNotNil(URLRequest.httpBody)
        
        if let httpBody = URLRequest.httpBody {
            let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
            
            if let json = json as? NSObject {
                XCTAssertEqual(json, parameters as NSObject)
            } else {
                XCTFail("json should be an NSObject")
            }
        } else {
            XCTFail("json should not be nil")
        }
    }
    
    func testThatEncodingDoesntOverrideCustomContentType() throws {
        // Given
        var mutableURLRequest = URLRequest(url: URL(string: "https://example.com/")!)
        mutableURLRequest.setValue("application/custom-json-type+json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["foo": "bar"]
        
        // When
        let urlRequest = try encoding.encode(mutableURLRequest, with: parameters)
        
        // Then
        XCTAssertNil(urlRequest.url?.query)
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/custom-json-type+json")
    }
}
