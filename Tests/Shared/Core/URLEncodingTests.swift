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

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return self
    }
}

// MARK: -

class URLParameterEncodingTestCase: XCTestCase {
    
    // MARK: Properties
    let urlRequest = URLRequest(url: URL(string: "https://example.com/")!)
    let encoding = URLEncoding.default
    
    // MARK: Tests - Parameter Types
    
    func testURLParameterEncodeNilParameters() {
        do {
            // Given, When
            let urlRequest = try encoding.encode(self.urlRequest, with: nil)
            
            // Then
            XCTAssertNil(urlRequest.url?.query)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeEmptyDictionaryParameter() {
        do {
            // Given
            let parameters: [String: Any] = [:]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertNil(urlRequest.url?.query)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeOneStringKeyStringValueParameter() {
        do {
            // Given
            let parameters = ["foo": "bar"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=bar")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeOneStringKeyStringValueParameterAppendedToQuery() {
        do {
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
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeTwoStringKeyStringValueParameters() {
        do {
            // Given
            let parameters = ["foo": "bar", "baz": "qux"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "baz=qux&foo=bar")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyNSNumberIntegerValueParameter() {
        do {
            // Given
            let parameters = ["foo": NSNumber(value: 25)]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=25")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyNSNumberBoolValueParameter() {
        do {
            // Given
            let parameters = ["foo": NSNumber(value: false)]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=0")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyIntegerValueParameter() {
        do {
            // Given
            let parameters = ["foo": 1]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyDoubleValueParameter() {
        do {
            // Given
            let parameters = ["foo": 1.1]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1.1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyBoolValueParameter() {
        do {
            // Given
            let parameters = ["foo": true]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyArrayValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["a", 1, true]]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5B%5D=a&foo%5B%5D=1&foo%5B%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyDictionaryValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": 1]]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyNestedDictionaryValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": ["baz": 1]]]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D%5Bbaz%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyNestedDictionaryArrayValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": ["baz": ["a", 1, true]]]]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            let expectedQuery = "foo%5Bbar%5D%5Bbaz%5D%5B%5D=a&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    // MARK: Tests - All Reserved / Unreserved / Illegal Characters According to RFC 3986
    
    func testThatReservedCharactersArePercentEscapedMinusQuestionMarkAndForwardSlash() {
        do {
            // Given
            let generalDelimiters = ":#[]@"
            let subDelimiters = "!$&'()*+,;="
            let parameters = ["reserved": "\(generalDelimiters)\(subDelimiters)"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            let expectedQuery = "reserved=%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatReservedCharactersQuestionMarkAndForwardSlashAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["reserved": "?/"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "reserved=?/")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatUnreservedNumericCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["numbers": "0123456789"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "numbers=0123456789")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatUnreservedLowercaseCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["lowercase": "abcdefghijklmnopqrstuvwxyz"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "lowercase=abcdefghijklmnopqrstuvwxyz")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatUnreservedUppercaseCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["uppercase": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatIllegalASCIICharactersArePercentEscaped() {
        do {
            // Given
            let parameters = ["illegal": " \"#%<>[]\\^`{}|"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            let expectedQuery = "illegal=%20%22%23%25%3C%3E%5B%5D%5C%5E%60%7B%7D%7C"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    // MARK: Tests - Special Character Queries
    
    func testURLParameterEncodeStringWithAmpersandKeyStringWithAmpersandValueParameter() {
        do {
            // Given
            let parameters = ["foo&bar": "baz&qux", "foobar": "bazqux"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%26bar=baz%26qux&foobar=bazqux")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithQuestionMarkKeyStringWithQuestionMarkValueParameter() {
        do {
            // Given
            let parameters = ["?foo?": "?bar?"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "?foo?=?bar?")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithSlashKeyStringWithQuestionMarkValueParameter() {
        do {
            // Given
            let parameters = ["foo": "/bar/baz/qux"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=/bar/baz/qux")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithSpaceKeyStringWithSpaceValueParameter() {
        do {
            // Given
            let parameters = [" foo ": " bar "]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "%20foo%20=%20bar%20")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithPlusKeyStringWithPlusValueParameter() {
        do {
            // Given
            let parameters = ["+foo+": "+bar+"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "%2Bfoo%2B=%2Bbar%2B")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyPercentEncodedStringValueParameter() {
        do {
            // Given
            let parameters = ["percent": "%25"]
            
            // When
            let urlRequest = try encoding.encode(self.urlRequest, with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "percent=%2525")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringKeyNonLatinStringValueParameter() {
        do {
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
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringForRequestWithPrecomposedQuery() {
        do {
            // Given
            let url = URL(string: "https://example.com/movies?hd=[1]")!
            let parameters = ["page": "0"]
            
            // When
            let urlRequest = try encoding.encode(URLRequest(url: url), with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&page=0")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithPlusKeyStringWithPlusValueParameterForRequestWithPrecomposedQuery() {
        do {
            // Given
            let url = URL(string: "https://example.com/movie?hd=[1]")!
            let parameters = ["+foo+": "+bar+"]
            
            // When
            let urlRequest = try encoding.encode(URLRequest(url: url), with: parameters)
            
            // Then
            XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&%2Bfoo%2B=%2Bbar%2B")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testURLParameterEncodeStringWithThousandsOfChineseCharacters() {
        do {
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
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    // MARK: Tests - Varying HTTP Methods
    
    func testThatURLParameterEncodingEncodesGETParametersInURL() {
        do {
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
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
    func testThatURLParameterEncodingEncodesPOSTParametersInHTTPBody() {
        do {
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
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
    
}

// TODO: AFNetworking tests to be ported [RDPA 02/09/2019]

//- (void)testThatAFHTTPRequestSerializationSerializesPOSTRequestsProperly {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//    request.HTTPMethod = @"POST";
//
//    NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:request withParameters:@{@"key":@"value"} error:nil];
//    NSString *contentType = serializedRequest.allHTTPHeaderFields[@"Content-Type"];
//
//    XCTAssertNotNil(contentType);
//    XCTAssertEqualObjects(contentType, @"application/x-www-form-urlencoded");
//
//    XCTAssertNotNil(serializedRequest.HTTPBody);
//    XCTAssertEqualObjects(serializedRequest.HTTPBody, [@"key=value" dataUsingEncoding:NSUTF8StringEncoding]);
//    }
//
//    - (void)testThatAFHTTPRequestSerializationSerializesPOSTRequestsProperlyWhenNoParameterIsProvided {
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//        request.HTTPMethod = @"POST";
//
//        NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:request withParameters:nil error:nil];
//        NSString *contentType = serializedRequest.allHTTPHeaderFields[@"Content-Type"];
//
//        XCTAssertNotNil(contentType);
//        XCTAssertEqualObjects(contentType, @"application/x-www-form-urlencoded");
//
//        XCTAssertNotNil(serializedRequest.HTTPBody);
//        XCTAssertEqualObjects(serializedRequest.HTTPBody, [NSData data]);
//        }
//
//        - (void)testThatAFHTTPRequestSerialiationSerializesQueryParametersCorrectly {
//            NSURLRequest *originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//            NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:originalRequest withParameters:@{@"key":@"value"} error:nil];
//
//            XCTAssertTrue([[[serializedRequest URL] query] isEqualToString:@"key=value"], @"Query parameters have not been serialized correctly (%@)", [[serializedRequest URL] query]);
//            }
//
//            - (void)testThatEmptyDictionaryParametersAreProperlyEncoded {
//                NSURLRequest *originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//                NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:originalRequest withParameters:@{} error:nil];
//                XCTAssertFalse([serializedRequest.URL.absoluteString hasSuffix:@"?"]);
//                }
//
//                - (void)testThatAFHTTPRequestSerialiationSerializesURLEncodableQueryParametersCorrectly {
//                    NSURLRequest *originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//                    NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:originalRequest withParameters:@{@"key":@" :#[]@!$&'()*+,;=/?"} error:nil];
//
//                    XCTAssertTrue([[[serializedRequest URL] query] isEqualToString:@"key=%20%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D/?"], @"Query parameters have not been serialized correctly (%@)", [[serializedRequest URL] query]);
//                    }
//
//                    - (void)testThatAFHTTPRequestSerialiationSerializesURLEncodedQueryParametersCorrectly {
//                        NSURLRequest *originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//                        NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:originalRequest withParameters:@{@"key":@"%20%21%22%23%24%25%26%27%28%29%2A%2B%2C%2F"} error:nil];
//
//                        XCTAssertTrue([[[serializedRequest URL] query] isEqualToString:@"key=%2520%2521%2522%2523%2524%2525%2526%2527%2528%2529%252A%252B%252C%252F"], @"Query parameters have not been serialized correctly (%@)", [[serializedRequest URL] query]);
//                        }
//
//                        - (void)testThatAFHTTPRequestSerialiationSerializesQueryParametersCorrectlyFromQuerySerializationBlock {
//                            [self.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//                                __block NSMutableString *query = [NSMutableString stringWithString:@""];
//                                [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                                [query appendFormat:@"%@**%@",key,obj];
//                                }];
//
//                                return query;
//                                }];
//
//                            NSURLRequest *originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//                            NSURLRequest *serializedRequest = [self.requestSerializer requestBySerializingRequest:originalRequest withParameters:@{@"key":@"value"} error:nil];
//
//                            XCTAssertTrue([[[serializedRequest URL] query] isEqualToString:@"key**value"], @"Custom Query parameters have not been serialized correctly (%@) by the query string block.", [[serializedRequest URL] query]);
//                            }
//
//                            - (void)testThatAFHTTPRequestSerialiationSerializesMIMETypeCorrectly {
//                                NSMutableURLRequest *originalRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
//                                Class streamClass = NSClassFromString(@"AFStreamingMultipartFormData");
//                                id <AFMultipartFormDataTest> formData = [[streamClass alloc] initWithURLRequest:originalRequest stringEncoding:NSUTF8StringEncoding];
//
//                                NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ADNNetServerTrustChain/adn_0" ofType:@"cer"]];
//
//                                [formData appendPartWithFileURL:fileURL name:@"test" error:NULL];
//
//                                AFHTTPBodyPart *part = [formData.bodyStream.HTTPBodyParts firstObject];
//
//                                XCTAssertTrue([part.headers[@"Content-Type"] isEqualToString:@"application/x-x509-ca-cert"], @"MIME Type has not been obtained correctly (%@)", part.headers[@"Content-Type"]);
//}
//
//#pragma mark -
//
//- (void)testThatValueForHTTPHeaderFieldReturnsSetValue {
//    [self.requestSerializer setValue:@"Actual Value" forHTTPHeaderField:@"Set-Header"];
//    NSString *value = [self.requestSerializer valueForHTTPHeaderField:@"Set-Header"];
//    XCTAssertTrue([value isEqualToString:@"Actual Value"]);
//    }
//
//    - (void)testThatValueForHTTPHeaderFieldReturnsNilForUnsetHeader {
//        NSString *value = [self.requestSerializer valueForHTTPHeaderField:@"Unset-Header"];
//        XCTAssertNil(value);
//        }
//
//        - (void)testQueryStringSerializationCanFailWithError {
//            AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//
//            NSError *serializerError = [NSError errorWithDomain:@"TestDomain" code:0 userInfo:nil];
//
//            [serializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//                *error = serializerError;
//                return nil;
//                }];
//
//            NSError *error;
//            NSURLRequest *request = [serializer requestWithMethod:@"GET" URLString:@"url" parameters:@{} error:&error];
//            XCTAssertNil(request);
//            XCTAssertEqual(error, serializerError);
//            }
//
//            - (void)testThatHTTPHeaderValueCanBeRemoved {
//                AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//                NSString *headerField = @"TestHeader";
//                NSString *headerValue = @"test";
//                [serializer setValue:headerValue forHTTPHeaderField:headerField];
//                XCTAssertTrue([serializer.HTTPRequestHeaders[headerField] isEqualToString:headerValue]);
//                [serializer setValue:nil forHTTPHeaderField:headerField];
//                XCTAssertFalse([serializer.HTTPRequestHeaders.allKeys containsObject:headerField]);
//}
//
//#pragma mark - Helper Methods
//
//- (void)testQueryStringFromParameters {
//    XCTAssertTrue([AFQueryStringFromParameters(@{@"key":@"value",@"key1":@"value&"}) isEqualToString:@"key=value&key1=value%26"]);
//    }
//
//    - (void)testPercentEscapingString {
//        XCTAssertTrue([AFPercentEscapedStringFromString(@":#[]@!$&'()*+,;=?/") isEqualToString:@"%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D?/"]);
//}
//
//#pragma mark - #3028 tests
////https://github.com/AFNetworking/AFNetworking/pull/3028
//
//- (void)testThatEmojiIsProperlyEncoded {
//    //Start with an odd number of characters so we can cross the 50 character boundry
//    NSMutableString *parameter = [NSMutableString stringWithString:@"!"];
//    while (parameter.length < 50) {
//        [parameter appendString:@"👴🏿👷🏻👮🏽"];
//    }
//
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSURLRequest *request = [serializer requestWithMethod:@"GET"
//        URLString:@"http://test.com"
//        parameters:@{@"test":parameter}
//        error:nil];
//    XCTAssertTrue([request.URL.query isEqualToString:@"test=%21%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD%F0%9F%91%B4%F0%9F%8F%BF%F0%9F%91%B7%F0%9F%8F%BB%F0%9F%91%AE%F0%9F%8F%BD"]);
//}
