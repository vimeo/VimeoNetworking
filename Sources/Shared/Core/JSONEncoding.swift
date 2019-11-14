//
//  JSONEncoding.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// Constants
private extension String {
    static let contentTypeHeaderField                   = "Content-Type"
    static let contentTypeApplicationJSONHeaderValue    = "application/json"
}

/// The type used to create a JSON encoded body of parameters to be added to the request URL.
/// Parameters are encoded using Foundation's `JSONSerialization` serializer.
/// and the request's `Content-Type` is set to `application/json`.
public struct JSONEncoding: ParameterEncoding {
    
    /// Returns a default `JSONEncoding` instance.
    public static let `default` = JSONEncoding()
    
    /// The writing options to be used by the JSON serializer
    private let options: JSONSerialization.WritingOptions
        
    /// Creates and returns a `JSONEncoding` instance using the specified options.
    ///
    /// - Parameter options: the options for JSON serializing the parameters
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    /// Creates a URL request by JSON encoding parameters and adding them to an existing request.
    ///
    /// - Parameters:
    ///   - requestConvertible: a type that can be converted to a URL request
    ///   - parameters: the parameters to JSON encode
    ///
    /// - Returns: the encoded URLRequest instance
    /// - Throws: an error if the encoding process fails.
    public func encode(_ requestConvertible: URLRequestConvertible, with parameters: Any?) throws -> URLRequest {
        var urlRequest = try requestConvertible.asURLRequest()
        
        guard let parameters = parameters else {
            // NO-OP - just return the original, unmodified request
            return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
            
            if urlRequest.value(forHTTPHeaderField: .contentTypeHeaderField) == nil {
                urlRequest.setValue(.contentTypeApplicationJSONHeaderValue, forHTTPHeaderField: .contentTypeHeaderField)
            }
            
            urlRequest.httpBody = data
        } catch {
            throw VimeoNetworkingError.encodingFailed(.jsonEncoding(error: error))
        }
        
        return urlRequest
    }
}
