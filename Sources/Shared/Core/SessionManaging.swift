//
//  VimeoSessionManaging.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/5/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import AFNetworking

/// The protocols declared in this file have been created to abstract our dependency
/// on AFNetworking and the Vimeo subclasses that inherit from it,
/// Specifically `VimeoSessionManager`, `VimeoRequestSerializer` and `VimeoResponseSerializer`
/// The goal is to make it easier for these dependencies to be swapped out when needed.
public protocol AuthenticationListeningDelegate {
    func clientDidAuthenticate(with account: VIMAccount)
    func clientDidClearAccount()
}

/// Wrapper for the response returned by the session manager
public struct SessionManagingResponse<T> {
    let task: URLSessionDataTask?
    let value: T?
    let error: Error?
}

public typealias SSLPinningMode = AFSSLPinningMode
public typealias SecurityPolicy = AFSecurityPolicy

/// A protocol describing the requirements of a SessionManaging type
public protocol SessionManaging {
    
    /// Used to invalidate the session manager
    func invalidate()
    
    /// Entrypoint for requests to be run by the session manager
    func request(
        with endpoint: EndpointType,
        then callback: @escaping (SessionManagingResponse<Any>) -> Void
    ) -> Cancelable?
    
}

/// A protocol representing an endpoint to which requests can be sent to
public protocol EndpointType {
    var uri: String { get }
    var parameters: Any? { get }
    var method: HTTPMethod { get }
}

extension Request: EndpointType {
    public var uri: String { return path }
}

/// A protocol representing a type that can be canceled
public protocol Cancelable {
    func cancel()
}

extension URLSessionDataTask: Cancelable {}
