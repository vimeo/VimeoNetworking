//
//  Request+EndpointType.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

extension Request: EndpointType {

    public var headers: HTTPHeaders? {
        return nil
    }

    // TODO: This method should be able to serialize its own parameters however with the current
    // way the SessionManager is designed we are unable to do that as it would require pretty
    // substantial refactoring. So for now the request serialization is the responsibility of the
    // SessionManaging type [RDPA 10/02/2019].
    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL)
        headers?.forEach { field, value in
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
