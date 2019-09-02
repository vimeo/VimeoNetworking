//
//  ParameterEncoding.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

// TODO: Remove this protocol in favour of the original
// declaration that will be merged in a future PR. [RDPA 09/02/2019]
protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

/// The dictionary of parameters for a given `URLRequest`.
typealias Parameters = [String: Any]

/// The type that describes how parameters are used in a `URLRequest`.
protocol ParameterEncoding {
    func encode(_ requestConvertible: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}
