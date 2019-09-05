//
//  HTTPMethod.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 8/31/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// A typesafe representation of all available HTTP methods
public enum HTTPMethod: String {
    /// The CONNECT method
    case connect        = "CONNECT"
    
    /// The DELETE method
    case delete         = "DELETE"
    
    /// The GET method
    case get            = "GET"
    
    /// The HEAD method
    case head           = "HEAD"
    
    /// The OPTIONS method
    case options        = "OPTIONS"
    
    /// The PATCH method
    case patch          = "PATCH"
    
    /// The POST method
    case post           = "POST"
    
    /// The PUT method
    case put            = "PUT"
    
    /// The TRACE method
    case trace          = "TRACE"
}

extension HTTPMethod: Equatable {}
