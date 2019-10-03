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

public struct SessionManagingResult<T, E: Error> {
    let request: URLRequest?
    let response: URLRequest?
    let result: Result<T, E>
}

/// A type that can perform asynchronous requests from a
/// URLRequestConvertible parameter and a response callback.
public protocol SessionManaging {
    
    /// Used to invalidate the session manager, and optionally cancel any pending tasks
    func invalidate(cancelingPendingTasks: Bool)
    
    /// The various methods below create asynchronous operations described by the
    /// requestConvertible object, and return a corresponding task that can be used to identify and
    /// control the lifecycle of the request.
    /// The callback provided will be executed once the operation completes. It will include
    /// the result object along with the originating request and corresponding response objects.
    /// Note that these methods make no guarantees as to which thread the callback will be called on.

    func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any?,
        then callback: @escaping (SessionManagingResult<JSON, VNError>) -> Void
    ) -> Task?

    func download(
        _ requestConvertible: URLRequestConvertible,
        then callback: @escaping (SessionManagingResult<URL, VNError>) -> Void
    ) -> Task?

    func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile: URL,
        then callback: @escaping (SessionManagingResult<JSON, VNError>) -> Void
    ) -> Task?

}
