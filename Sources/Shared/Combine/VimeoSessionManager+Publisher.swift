//
//  VimeoSessionManager+Publisher.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 11/17/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import Combine

extension VimeoSessionManager {

    /// Returns a publisher that wraps a data request for a given URLConvertible type.
    /// - Parameter request: the request convertible for which to create a data request.
    //
    /// The publisher publishes data when the request completes and immediately
    /// sends a completion event. If the request fails, it terminates with an error.
    @available(iOS 13, tvOS 13, macOS 10.15, *)
    func publisher(for request: URLRequestConvertible) -> AnyPublisher<Data, Error> {
        let passthroughSubject = PassthroughSubject<Data, Error>()
        let task = self.request(request) { (sessionManagingResult: SessionManagingResult<Data>) in
            switch sessionManagingResult.result {
            case .success(let data):
                passthroughSubject.send(data)
                passthroughSubject.send(completion: .finished)
            case .failure(let error):
                passthroughSubject.send(completion: .failure(error))
            }
        }

        return passthroughSubject
            .handleEvents(receiveCancel: { task?.cancel() })
            .eraseToAnyPublisher()
    }

    /// Returns a publisher that wraps a decodable request for a given URLConvertible type.
    /// - Parameter request: the request convertible for which to create a decodable request.
    ///
    /// The publisher publishes the specified decodable type when the request completes and immediately
    /// sends a completion event. If the request fails, it terminates with an error.
    @available(iOS 13, tvOS 13, macOS 10.15, *)
    func publisher<D: Decodable>(for request: URLRequestConvertible) -> AnyPublisher<D, Error> {
        let passthroughSubject = PassthroughSubject<D, Error>()
        let task = self.request(request) { (sessionManagingResult: SessionManagingResult<D>) in
            switch sessionManagingResult.result {
            case .success(let decodable):
                passthroughSubject.send(decodable)
                passthroughSubject.send(completion: .finished)
            case .failure(let error):
                passthroughSubject.send(completion: .failure(error))
            }
        }

        return passthroughSubject
            .handleEvents(receiveCancel: { task?.cancel() })
            .eraseToAnyPublisher()
    }
}
