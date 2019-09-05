//
//  VimeoSessionManaging.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/5/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// The protocols declared in this file have been created to abstract our dependency
/// on AFNetworking and the Vimeo subclasses that inherit from it,
/// Specifically `VimeoSessionManager`, `VimeoRequestSerializer` and `VimeoResponseSerializer`

public protocol AuthenticationListeningDelegate {
    func clientDidAuthenticate(with account: VIMAccount)
    func clientDidClearAccount()
}

public protocol Cancellable {
    func cancel()
}

public struct SessionManagingError: Error {
    let task: URLSessionDataTask?
    let error: Error
}

public struct SessionManagingResponse {
    let task: URLSessionDataTask
    let value: Any?
}

public typealias SessionManagingResult = (Result<SessionManagingResponse, SessionManagingError>) -> Void

public protocol SessionManaging {
    func invalidate()
    func request(
        _ endpoint: EndpointType,
        then callback: @escaping SessionManagingResult
    ) -> Cancellable?

}

public protocol EndpointType {
    var path: String { get }
    var parameters: Any? { get }
    var method: HTTPMethod { get }
}

extension Request: EndpointType {}
