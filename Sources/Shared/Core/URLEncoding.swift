//
//  URLEncoding.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// The dictionary of parameters for a given `URLRequest`.
public typealias Parameters = [String: Any]

/// The type used to create a URL encoded string of parameters to be appended to the request URL.
/// For URL requests with a non-nil HTTP body, the content type is set to
/// `application/x-www-form-urlencoded; charset=utf-8`
///
/// Collection types are encoded using the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`).
/// For dictionary values, the key surrounded by square brackets is used (`foo[bar]=baz`).
public struct URLEncoding: ParameterEncoding {

    public enum Destination {
        case methodDependent
        case URL
        case body
    }

    /// Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }

    /// MARK: - Private

    /// The destination to which parameters will be encoded to
    private let destination: Destination


    /// The URLEncoding type public initializer
    /// - Parameter destination: the destination to which parameters will be encoded to. Defaults to `methodDependent`
    public init(destination: Destination = .methodDependent) {
        self.destination = destination
    }

    /// Creates a URL request by encoding parameters and adding them to an existing request.
    ///
    /// - Parameters:
    ///   - requestConvertible: a type that can be converted to a URL request
    ///   - parameters: the parameters to encode
    ///
    /// - Returns: the encoded URLRequest instance
    /// - Throws: an error if the encoding process fails.
    public func encode(_ requestConvertible: URLRequestConvertible, with parameters: Any?) throws -> URLRequest {
        var urlRequest = try requestConvertible.asURLRequest()
        
        guard let unwrappedParameters = parameters as? Parameters else {
            if parameters == nil {
                // NO-OP - just return the original, unmodified request
                return urlRequest
            }
            // Couldn't cast to Parameters so we bail with an error
            throw VimeoNetworkingError.encodingFailed(.invalidParameters)
        }
        
        if unwrappedParameters.count == 0 {
            // NO-OP - just return the original, unmodified request
            return urlRequest
        }
        
        let rawMethod = urlRequest.httpMethod ?? ""
        guard let httpMethod = HTTPMethod(rawValue: rawMethod) else {
            throw VimeoNetworkingError.encodingFailed(.missingHTTPMethod)
        }
        
        switch (self.destination, httpMethod) {
        // .get, .head and .delete methods take their encoded parameters directly in the URL unless otherwise specified
        case (.methodDependent, .get), (.methodDependent, .head), (.methodDependent, .delete), (.URL, _):
            return try inURLEncode(unwrappedParameters, for: &urlRequest)
        case (.methodDependent, _), (.body, _):
            return try bodyEncode(unwrappedParameters, for: &urlRequest)
        }
    }
    
    private func inURLEncode(_ parameters: Parameters, for urlRequest: inout URLRequest) throws -> URLRequest {
        guard let url = urlRequest.url else {
            throw VimeoNetworkingError.encodingFailed(.missingURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            // Ensure we retain any existing query parameters, and append an `&` at the end, then the parameters to encode
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "")
                + query(forParameters: parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
    
    private func bodyEncode(_ parameters: Parameters, for urlRequest: inout URLRequest) throws -> URLRequest {
        // For body encoding we ensure the content-type header is set correctly
        if urlRequest.value(forHTTPHeaderField: .contentTypeHeaderField) == nil {
            urlRequest.setValue(.contentTypeFormUrlEncodedHeaderValue, forHTTPHeaderField: .contentTypeHeaderField)
        }
        
        urlRequest.httpBody = query(forParameters: parameters).data(using: .utf8, allowLossyConversion: false)
        return urlRequest
    }
}

// MARK: - Private convenience utilities
private extension URLEncoding {
    
    func query(forParameters parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let bool = value as? Bool {
            let boolString = bool ? "1" : "0"
            components.append((key.escaped, boolString.escaped))
        } else {
            components.append((key.escaped, "\(value)".escaped))
        }
        
        return components
    }
}

private extension String {
    var escaped: String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
}

/// Constants
private extension String {
    static let contentTypeHeaderField                   = "Content-Type"
    static let contentTypeFormUrlEncodedHeaderValue     = "application/x-www-form-urlencoded; charset=utf-8"
}
