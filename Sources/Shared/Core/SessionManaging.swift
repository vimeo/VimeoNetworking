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
/// The goal is to make it easier for these dependencies to be swapped out when needed.
public protocol AuthenticationListeningDelegate {
    func clientDidAuthenticate(with account: VIMAccount)
    func clientDidClearAccount()
}

/// A protocol representing a type that can be canceled
public protocol Cancelable {
    func cancel()
}

/// Wrapper for the error returned by the session manager
/// It can optionally include the corresponding task that generated the error
public struct SessionManagingError: Error {
    let task: URLSessionDataTask?
    let error: Error
}

/// Wrapper for the response returned by the session manager
/// including the corresponding task that originated the response value (if any)
public struct SessionManagingResponse {
    let task: URLSessionDataTask
    let value: Any?
}

public typealias SessionManagingResult = (Result<SessionManagingResponse, SessionManagingError>) -> Void

/// A protocol describing the requirements of a SessionManaging type
public protocol SessionManaging {
    
    /// Used to invalidate the session manager
    func invalidate()
    
    /// Entrypoint for requests to be run by the session manager
    func request(
        with endpoint: EndpointType,
        then callback: @escaping SessionManagingResult
    ) -> Cancelable?

}

/// A protocol representing an endpoint to which requests can be sent to
public protocol EndpointType {
    var path: String { get }
    var parameters: Any? { get }
    var method: HTTPMethod { get }
}

extension Request: EndpointType {}

extension URLSessionDataTask: Cancelable {}
