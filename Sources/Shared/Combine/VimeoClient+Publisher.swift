//
//  VimeoClient+Publisher.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 11/17/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import Combine

extension VimeoClient {

    /// Returns a publisher that wraps a decodable request for a given URLConvertible type.
    /// - Parameter request: the request convertible for which to create a decodable request.
    ///
    /// The publisher publishes the specified decodable type when the request completes and immediately
    /// send a completion event. If the request fails, it terminates with an error.
    @available(iOS 13, tvOS 13, macOS 10.15, *)
    func publisher<D: Decodable>(for endpoint: EndpointType) -> AnyPublisher<D, Error> {
        let passthroughSubject = PassthroughSubject<D, Error>()
        var task: RequestToken?
        task = self.request(endpoint) { (result: Result<D, Error>) in
            switch result {
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
