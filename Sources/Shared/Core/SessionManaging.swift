//
//  VimeoSessionManaging.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/5/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import AFNetworking

public typealias JSON = Any

/// The protocols declared in this file have been created to abstract our dependency
/// on AFNetworking and the Vimeo subclasses that inherit from it,
/// Specifically `VimeoSessionManager`, `VimeoRequestSerializer` and `VimeoResponseSerializer`
/// The goal is to make it easier for these dependencies to be swapped out when needed.
public protocol AuthenticationListeningDelegate {
    func clientDidAuthenticate(with account: VIMAccount)
    func clientDidClearAccount()
}

public typealias SSLPinningMode = AFSSLPinningMode
public typealias SecurityPolicy = AFSecurityPolicy

/// A type that can create different cancellable asynchronous requests based on
/// an `EndpointType` parameter and the appropriate callback.
/// The callbacks are generic in nature and can respond with `Data`, `JSON` or `Decodable` values.
public protocol SessionManaging {
    
    /// Used to invalidate the session manager, and optionally cancel any pending tasks
    func invalidate(cancelPendingTasks: Bool)
    
    /// Creates and returns a cancellable, asynchronous data request
    /// and runs the callback passed in once the work is performed.
    /// The callback includes a Result<Data> type and the corresponding URLSessionDataTask, if one exists
    func request(
        with endpoint: EndpointType,
        then callback: @escaping (Result<Data, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable?

    /// Creates and returns a cancellable, asynchronous JSON request
    /// and runs the callback passed in once the work is completed.
    /// The callback includes a Result<JSON> type and the corresponding URLSessionDataTask, if one exists
    func request(
        with endpoint: EndpointType,
        then callback: @escaping (Result<JSON, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable?

    /// Creates and returns a cancellable, asynchronous Decodable request
    /// and runs the callback passed in once the work is performed.
    /// The callback includes a Result<T: Decodable> type and the corresponding URLSessionDataTask, if one exists
    func request<T: Decodable>(
        with endpoint: EndpointType,
        then callback: @escaping (Result<T, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable?

}

/// A protocol representing an endpoint to which requests can be sent to
public protocol EndpointType {
    var path: String { get }
    var parameters: Any? { get }
    var method: HTTPMethod { get }
}

extension Request: EndpointType {}

/// A protocol representing a type that can be canceled
public protocol Cancelable {
    func cancel()
}

extension URLSessionDataTask: Cancelable {}
