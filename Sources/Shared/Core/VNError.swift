//
//  VNError.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

public enum VNError: Error {
    case encodingFailed(EncodingFailedReason)
    case decodingFailed(DecodingFailedReason)
    case unknownError
    
    public enum DecodingFailedReason {
        case responseDataNotFound
    }
    
    public enum EncodingFailedReason {
        case invalidParameters
        case missingURL
        case missingHTTPMethod
        case jsonEncoding(error: Error)
        case serializationFailed
    }
}
