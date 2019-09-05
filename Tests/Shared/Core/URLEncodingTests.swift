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

class URLParameterEncodingTestCase: XCTestCase {
    
    let urlRequest = URLRequest(url: URL(string: "https://example.com/")!)
    let encoding = URLEncoding.default
    
    func testThatMissingURLInRequestThrowsError() throws {
        // Given
        var mutableURLRequest = urlRequest
        mutableURLRequest.url = nil
        
        // When, then
        XCTAssertThrowsError(try encoding.encode(mutableURLRequest, with: ["foo": "bar"]))
    }
    
    func testThatInvalidHTTPMethodThrowsError() throws {
        // Given
        var mutableURLRequest = urlRequest
        mutableURLRequest.httpMethod = "INVALID"
        
        // When, then
        XCTAssertThrowsError(try encoding.encode(mutableURLRequest, with: ["foo": "bar"]))
    }
    
    func testThatQueryIsNilForNilParameters() throws {
        // Given, When
        let urlRequest = try encoding.encode(self.urlRequest, with: nil)
        
        // Then
        XCTAssertNil(urlRequest.url?.query)
    }
    
    func testThatQueryIsNilForEmptyDictionaryParameter() throws {
        // Given
        let parameters: [String: Any] = [:]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertNil(urlRequest.url?.query)
    }
    
    func testThatSinglePairParameterIsEncoded() throws {
        // Given
        let parameters = ["foo": "bar"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=bar")
    }
    
    func testThatEncodingParametersAreAppendedToExistingQuery() throws {
        // Given
        var mutableURLRequest = self.urlRequest
        var urlComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)!
        urlComponents.query = "baz=qux"
        mutableURLRequest.url = urlComponents.url
        
        let parameters = ["foo": "bar"]
        
        // When
        let urlRequest = try encoding.encode(mutableURLRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "baz=qux&foo=bar")
    }
    
    func testThatMultiParametersAreEncoded() throws {
        // Given
        let parameters = ["foo": "bar", "baz": "qux"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "baz=qux&foo=bar")
    }
    
    func testThatNSNumberIsEncode() throws {
        // Given
        let parameters = ["foo": NSNumber(value: 25)]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=25")
    }
    
    func testThatBooleanNSNumberIsEncoded() throws {
        // Given
        let parameters = ["foo": NSNumber(value: false)]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=0")
    }
    
    func testThatIntegerValueIsEncoded() throws {
        // Given
        let parameters = ["foo": 1]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=1")
    }
    
    func testThatDoubleValueIsEncoded() throws {
        // Given
        let parameters = ["foo": 1.1]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=1.1")
    }
    
    func testThatBoolValueIsEncoded() throws {
        // Given
        let parameters = ["foo": true]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo=1")
    }
    
    func testThatArrayValueIsEncoded() throws {
        // Given
        let parameters = ["foo": ["a", 1, true]]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo%5B%5D=a&foo%5B%5D=1&foo%5B%5D=1")
    }
    
    func testThatDictionaryValueIsEncoded() throws {
        // Given
        let parameters = ["foo": ["bar": 1]]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D=1")
    }
    
    func testThatNestedDictionaryIsEncoded() throws {
        // Given
        let parameters = ["foo": ["bar": ["baz": 1]]]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D%5Bbaz%5D=1")
    }
    
    func testThatNestedDictionaryArrayIsEncoded() throws {
        // Given
        let parameters = ["foo": ["bar": ["baz": ["a", 1, true]]]]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        let expectedQuery = "foo%5Bbar%5D%5Bbaz%5D%5B%5D=a&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1"
        XCTAssertEqual(urlRequest.url?.query, expectedQuery)
    }
    
    func testThatReservedCharactersArePercentEscapedMinusQuestionMarkAndForwardSlash() throws {
        // Given
        let generalDelimiters = ":#[]@"
        let subDelimiters = "!$&'()*+,;="
        let parameters = ["reserved": "\(generalDelimiters)\(subDelimiters)"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        let expectedQuery = "reserved=%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"
        XCTAssertEqual(urlRequest.url?.query, expectedQuery)
    }
    
    func testThatReservedCharactersQuestionMarkAndForwardSlashAreNotPercentEscaped() throws {
        // Given
        let parameters = ["reserved": "?/"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "reserved=?/")
    }
    
    func testThatUnreservedNumericCharactersAreNotPercentEscaped() throws {
        // Given
        let parameters = ["numbers": "0123456789"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "numbers=0123456789")
    }
    
    func testThatUnreservedLowercaseCharactersAreNotPercentEscaped() throws {
        // Given
        let parameters = ["lowercase": "abcdefghijklmnopqrstuvwxyz"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "lowercase=abcdefghijklmnopqrstuvwxyz")
    }
    
    func testThatUnreservedUppercaseCharactersAreNotPercentEscaped() throws {
        // Given
        let parameters = ["uppercase": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }
    
    func testThatIllegalASCIICharactersArePercentEscaped() throws {
        // Given
        let parameters = ["illegal": " \"#%<>[]\\^`{}|"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        let expectedQuery = "illegal=%20%22%23%25%3C%3E%5B%5D%5C%5E%60%7B%7D%7C"
        XCTAssertEqual(urlRequest.url?.query, expectedQuery)
    }
    
    // MARK: Tests - Special Character Queries
    
    func testThatStringWithAmpersandKeyStringWithAmpersandValueParameterArePercentEscaped() throws {
        // Given
        let parameters = ["foo&bar": "baz&qux", "foobar": "bazqux"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo%26bar=baz%26qux&foobar=bazqux")
    }
    
    func testThatStringWithQuestionMarkKeyStringWithQuestionMarkValueParameterAreEncoded() throws {
        // Given
        let parameters = ["?foo?": "?bar?"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "?foo?=?bar?")
    }
    
    func testThatStringWithSlashKeyStringWithSlashValueParameterAreEncoded() throws {
        // Given
        let parameters = ["foo/bar": "/bar/baz/qux"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "foo/bar=/bar/baz/qux")
    }
    
    func testThatStringWithSpaceKeyStringWithSpaceValueParameterArePercentEscaped() throws {
        // Given
        let parameters = [" foo ": " bar "]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "%20foo%20=%20bar%20")
    }
    
    func testThatStringWithPlusKeyStringWithPlusValueParameterArePercentEscaped() throws {
        // Given
        let parameters = ["+foo+": "+bar+"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "%2Bfoo%2B=%2Bbar%2B")
    }
    
    func testThatStringKeyPercentEncodedStringValueParameterArePercentEscaped() throws {
        // Given
        let parameters = ["percent": "%25"]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "percent=%2525")
    }
    
    func testThatStringKeyNonLatinStringValueParameterArePercentEscaped() throws {
        // Given
        let parameters = [
            "french": "français",
            "japanese": "日本語",
            "arabic": "العربية",
            "emoji": "😃"
        ]
        
        // When
        let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
        
        // Then
        let expectedParameterValues = [
            "arabic=%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9",
            "emoji=%F0%9F%98%83",
            "french=fran%C3%A7ais",
            "japanese=%E6%97%A5%E6%9C%AC%E8%AA%9E"
        ]
        
        let expectedQuery = expectedParameterValues.joined(separator: "&")
        XCTAssertEqual(urlRequest.url?.query, expectedQuery)
    }
    
    func testThatStringForRequestWithPrecomposedQueryIsPercentEscaped() throws {
        // Given
        let url = URL(string: "https://example.com/movies?hd=[1]")!
        let parameters = ["page": "0"]
        
        // When
        let urlRequest = try encoding.encode(URLRequest(url: url), with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&page=0")
    }
    
    func testThatStringWithPlusKeyStringWithPlusValueParameterForRequestWithPrecomposedQueryIsPercentEscaped() throws {
        // Given
        let url = URL(string: "https://example.com/movie?hd=[1]")!
        let parameters = ["+foo+": "+bar+"]
        
        // When
        let urlRequest = try encoding.encode(URLRequest(url: url), with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&%2Bfoo%2B=%2Bbar%2B")
    }
    
    func testThatStringWithThousandsOfChineseCharactersIsPercentEscaped() throws {
        // Given
        let repeatedCount = 2_000
        let url = URL(string: "https://example.com/movies")!
        
        let parameters = ["chinese": String(repeating: "一二三四五六七八九十", count: repeatedCount)]
        
        // When
        let urlRequest = try encoding.encode(URLRequest(url: url), with: parameters)
        
        // Then
        var expected = "chinese="
        
        for _ in 0..<repeatedCount {
            expected += "%E4%B8%80%E4%BA%8C%E4%B8%89%E5%9B%9B%E4%BA%94%E5%85%AD%E4%B8%83%E5%85%AB%E4%B9%9D%E5%8D%81"
        }
        
        XCTAssertEqual(urlRequest.url?.query, expected)
    }
    
    // MARK: Tests - Varying HTTP Methods
    
    func testThatItEncodesGETParametersInURL() throws {
        // Given
        var mutableURLRequest = self.urlRequest
        mutableURLRequest.httpMethod = HTTPMethod.get.rawValue
        let parameters = ["foo": 1, "bar": 2]
        
        // When
        let urlRequest = try encoding.encode(mutableURLRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.url?.query, "bar=2&foo=1")
        XCTAssertNil(urlRequest.value(forHTTPHeaderField: "Content-Type"), "Content-Type should be nil")
        XCTAssertNil(urlRequest.httpBody, "HTTPBody should be nil")
    }
    
    func testThatItEncodesPOSTParametersInHTTPBody() throws {
        // Given
        var mutableURLRequest = self.urlRequest
        mutableURLRequest.httpMethod = HTTPMethod.post.rawValue
        let parameters = ["foo": 1, "bar": 2]
        
        // When
        let urlRequest = try encoding.encode(mutableURLRequest, with: parameters)
        
        // Then
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded; charset=utf-8")
        XCTAssertNotNil(urlRequest.httpBody, "HTTPBody should not be nil")
        
        if let httpBody = urlRequest.httpBody, let decodedHTTPBody = String(data: httpBody, encoding: .utf8) {
            XCTAssertEqual(decodedHTTPBody, "bar=2&foo=1")
        } else {
            XCTFail("decoded http body should not be nil")
        }
    }
    
}

// MARK: - AFNetworking tests ported to ensure backwards compatibility

class AFNetworkingSerializerTests: XCTestCase {
    
    let urlRequest = URLRequest(url: URL(string: "https://example.com/")!)
    let encoding = URLEncoding.default
    
    func testThatEmojisAreProperlyEncoded() throws {
        // Start with an odd number of characters so we can cross the 50 character boundry
        var parameter = "!"
        while parameter.count < 50 {
            parameter.append("👴🏿👷🏻👮🏽")
        }
        
        // When
        let request = try encoding.encode(urlRequest, with: ["test": parameter])
        XCTAssertEqual(request.url?.query, "test=%21%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD"
        )
    }

}
