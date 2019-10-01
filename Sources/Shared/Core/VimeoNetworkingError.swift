//
//  VimeoNetworkingError.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

enum VimeoNetworkingError: Error {
    case encodingFailed(EncodingFailedReason)
    case decodingFailed(DecodingFailedReason)
    case unknownError
    
    enum DecodingFailedReason {
        case responseDataNotFound
    }
    
    enum EncodingFailedReason {
        case invalidParameters
        case missingURL
        case missingHTTPMethod
        case jsonEncoding(error: Error)
    }

}
