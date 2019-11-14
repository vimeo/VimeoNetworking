//
//  ParameterEncoding.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// The type that describes how parameters are used in a `URLRequest`.
public protocol ParameterEncoding {
    func encode(_ requestConvertible: URLRequestConvertible, with parameters: Any?) throws -> URLRequest
}
