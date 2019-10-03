//
//  URLRequestConvertible.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// A protocol that represents a type that can be converted to a URLRequest
public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return self
    }
}

extension URL: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return URLRequest(url: self)
    }
}
