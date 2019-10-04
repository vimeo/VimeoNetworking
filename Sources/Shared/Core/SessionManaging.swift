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

    /// Called when authentication completes successfully
    /// - Parameter account: the new authenticated account
    func clientDidAuthenticate(with account: VIMAccount)

    /// Called when a client is logged out
    func clientDidClearAccount()
}

public typealias SSLPinningMode = AFSSLPinningMode
public typealias SecurityPolicy = AFSecurityPolicy

public struct SessionManagingResult<T> {
    public let request: URLRequest?
    public let response: URLResponse?
    public let result: Result<T, Error>

    init(request: URLRequest? = nil, response: URLResponse? = nil, result: Result<T, Error>) {
        self.request = request
        self.response = response
        self.result = result
    }
}

/// A type that can perform asynchronous requests from a
/// URLRequestConvertible parameter and a response callback.
public protocol SessionManaging {
    
    /// Used to invalidate the session manager, and optionally cancel any pending tasks
    func invalidate(cancelingPendingTasks cancelPendingTasks: Bool)
    
    /// The various methods below create asynchronous operations described by the
    /// requestConvertible object, and return a corresponding task that can be used to identify and
    /// control the lifecycle of the request.
    /// The callback provided will be executed once the operation completes. It will include
    /// the result object along with the originating request and corresponding response objects.
    /// Note that these methods make no guarantees as to which thread the callback will be called on.

    func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any?,
        then callback: @escaping (SessionManagingResult<Data>) -> Void
    ) -> Task?

    func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any?,
        then callback: @escaping (SessionManagingResult<JSON>) -> Void
    ) -> Task?

    func request<T: Decodable>(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any?,
        then callback: @escaping (SessionManagingResult<T>) -> Void
    ) -> Task?

    func download(
        _ requestConvertible: URLRequestConvertible,
        destinationURL: URL?,
        then callback: @escaping (SessionManagingResult<URL>) -> Void
    ) -> Task?

    func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile: URL,
        then callback: @escaping (SessionManagingResult<JSON>) -> Void
    ) -> Task?

}
