//
//  EndpointType.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation


public typealias HTTPHeaders = [String: String]

/// A type representing an endpoint to which requests can be sent.
/// EndpointTypes encapsulate all the information required to create a URLRequest
/// so they also conform to URLRequestConvertible
public protocol EndpointType: URLRequestConvertible {

    /// Any HTTP headers to be added to the endpoint request
    var headers: HTTPHeaders? { get }

    /// The endpoint path relative to the base URL
    var path: String { get }

    /// The parameters to be passed with the endpoint request
    var parameters: Any? { get }

    /// The HTTP method to be used by the endpoint request
    var method: HTTPMethod { get }
}

extension EndpointType {
    var baseURL: URL { return VimeoBaseURL }
}
