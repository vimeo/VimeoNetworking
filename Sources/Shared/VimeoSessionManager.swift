//
//  VimeoSessionManager.swift
//  VimeoUpload
//
//  Created by Alfred Hanssen on 10/17/15.
//  Copyright © 2015 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import AFNetworking

private typealias SessionManagingDataTaskSuccess<T> = ((URLSessionDataTask, T?) -> Void)
private typealias SessionManagingDataTaskFailure = ((URLSessionDataTask?, Error) -> Void)
private typealias SessionManagingDataTaskProgress = (Progress) -> Void

/** `VimeoSessionManager` handles networking and serialization for raw HTTP requests.  It is a direct subclass of `AFHTTPSessionManager` and it's designed to be used internally by `VimeoClient`.  For the majority of purposes, it would be better to use `VimeoClient` and a `Request` object to better encapsulate this logic, since the latter provides richer functionality overall.
 */

final public class VimeoSessionManager: AFHTTPSessionManager, SessionManaging {

    // MARK: - Public

    /// Getter and setter override that restricts access to the setter property
    public override var responseSerializer: AFHTTPResponseSerializer & AFURLResponseSerialization {
        get { return super.responseSerializer }
        set { assert(false, "The setter for this property is unavailable and considered a NO-OP. DO NOT OVERRIDE") }
    }

    /// Getter and setter for acceptableContentTypes property on the Vimeo/JSON response serializer
    @objc public var acceptableContentTypes: Set<String>? {
        get { return vimeoResponseSerializer.acceptableContentTypes }
        set { vimeoResponseSerializer.acceptableContentTypes = newValue }
    }

    // MARK: - Private

    /// The custom Vimeo response serializer that is used for serializing Data responses into JSON
    public let vimeoResponseSerializer = VimeoResponseSerializer()

    /// The JSONDecoder instance used for decoding decodable type responses
    private let jsonDecoder = JSONDecoder()

    // MARK: - Initialization

    /**
     Creates a new session manager

     - parameter baseUrl: The base URL for the HTTP client
     - parameter sessionConfiguration: Object describing the URL session policies for this session manager
     - parameter requestSerializer:    Serializer to use for all requests handled by this session manager

     - returns: an initialized `VimeoSessionManager`
     */
    required public init(
        baseUrl: URL,
        sessionConfiguration: URLSessionConfiguration,
        requestSerializer: VimeoRequestSerializer
    ) {
        super.init(baseURL: baseUrl, sessionConfiguration: sessionConfiguration)
        self.requestSerializer = requestSerializer
        // Here we use the default HTTP response serializer so we can opt-out of automatic JSON serialization
        // carried out by AFNetworking. This allows us to decide if we want and how to serialize a response
        // based on the API used to make the request
        super.responseSerializer = AFHTTPResponseSerializer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func invalidate(cancelPendingTasks: Bool) {
        self.invalidateSessionCancelingTasks(cancelPendingTasks)
    }

    public func request(
        with endpoint: EndpointType,
        then callback: @escaping (Result<Data, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable? {
        let path = endpoint.uri
        let parameters = endpoint.parameters

        let success: SessionManagingDataTaskSuccess = { (dataTask, value: Any?) in
            guard let data = value as? Data else {
                callback(Result.failure(VimeoNetworkingError.decodingFailed(.responseDataNotFound)), dataTask)
                return
            }
            callback(Result.success(data), dataTask)
        }

        let failure: SessionManagingDataTaskFailure = { dataTask, error in
            callback(Result.failure(error), dataTask)
        }

        switch endpoint.method {
        case .get:
            return self.get(path, parameters: parameters, progress: nil, success: success, failure: failure)
        case .post:
            return self.post(path, parameters: parameters, progress: nil, success: success, failure: failure)
        case .put:
            return self.put(path, parameters: parameters, success: success, failure: failure)
        case .patch:
            return self.patch(path, parameters: parameters, success: success, failure: failure)
        case .delete:
            return self.delete(path, parameters: parameters, success: success, failure: failure)
        case .connect, .head, .options, .trace:
            return nil
        }

    }

    public func request(
        with endpoint: EndpointType,
        then callback: @escaping (Result<JSON, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable? {
        return self.request(with: endpoint) { [vimeoResponseSerializer] (dataResult: Result<Data, Error>, dataTask) in
            switch dataResult {
            case .failure(let error):
                callback(Result<JSON, Error>.failure(error), dataTask)
            case .success(let data):
                var maybeError: NSError?
                let maybeJSON = vimeoResponseSerializer.responseObject(
                    for: dataTask?.response,
                    data: data,
                    error: &maybeError
                )
                guard let json = maybeJSON else {
                    let error = (maybeError as Error?) ?? VimeoNetworkingError.unknownError
                    callback(Result.failure(error), dataTask)
                    return
                }
                callback(Result.success(json), dataTask)
            }
        }
    }

    public func request<T: Decodable>(
        with endpoint: EndpointType,
        then callback: @escaping (Result<T, Error>, URLSessionDataTask?) -> Void
    ) -> Cancelable? {
        return self.request(with: endpoint) { [jsonDecoder] (dataResult: Result<Data, Error>, dataTask) in
            switch dataResult {
            case .failure(let error):
                callback(Result<T, Error>.failure(error), dataTask)
            case .success(let data):
                do {
                    let decoded = try jsonDecoder.decode(T.self, from: data)
                    callback(Result.success(decoded), dataTask)
                } catch {
                    callback(Result.failure(error), dataTask)
                }
            }
        }
    }
}

extension VimeoSessionManager: AuthenticationListeningDelegate {
    // MARK: - Authentication

    /**
     Called when authentication completes successfully to update the session manager with the new access token

     - parameter account: the new account
     */
    public func clientDidAuthenticate(with account: VIMAccount) {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
        else {
            return
        }

        let accessToken = account.accessToken
        requestSerializer.accessTokenProvider = {
            return accessToken
        }
    }

    /**
     Called when a client is logged out and the current account should be cleared from the session manager
     */
    public func clientDidClearAccount() {
        guard let requestSerializer = self.requestSerializer as? VimeoRequestSerializer
            else {
            return
        }

        requestSerializer.accessTokenProvider = nil
    }
}
