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

/** `VimeoSessionManager` handles networking and serialization for raw HTTP requests.
 Internally, it uses  an `AFHTTPSessionManager` instance to handle requests.
 This class was designed to be used internally by `VimeoClient`. For the majority of purposes,
 it would be better to use`VimeoClient` and a `Request` object to better encapsulate this logic,
 since the latter provides richer functionality overall.
 */
final public class VimeoSessionManager: NSObject, SessionManaging {

    // MARK: - Public

    public var responseSerializer: AFHTTPResponseSerializer {
        return httpSessionManager.responseSerializer
    }

    public var requestSerializer: AFHTTPRequestSerializer? {
        return httpSessionManager.requestSerializer
    }

    /// Getter and setter for the securityPolicy property on AFHTTPSessionManager
    @objc public var securityPolicy: SecurityPolicy {
        get { return httpSessionManager.securityPolicy }
        set { httpSessionManager.securityPolicy = newValue }
    }
    
    /// Getter and setter for acceptableContentTypes property on the Vimeo/JSON response serializer
    @objc public var acceptableContentTypes: Set<String>? {
        get { return jsonResponseSerializer.acceptableContentTypes }
        set { jsonResponseSerializer.acceptableContentTypes = newValue }
    }

    // MARK: - Private

    /// The custom Vimeo request serializer that is used for serializing Data requests into JSON
    public let jsonRequestSerializer: VimeoRequestSerializer

    /// The custom Vimeo response serializer that is used for serializing Data responses into JSON
    public lazy var jsonResponseSerializer = VimeoResponseSerializer()

    /// The JSONDecoder instance used for decoding decodable type responses
    private lazy var jsonDecoder = JSONDecoder()

    // The underlying HTTP Session Manager
    public let httpSessionManager: AFHTTPSessionManager

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
        self.httpSessionManager = AFHTTPSessionManager(baseURL: baseUrl, sessionConfiguration: sessionConfiguration)
        self.httpSessionManager.requestSerializer = AFHTTPRequestSerializer()
        self.httpSessionManager.responseSerializer = AFHTTPResponseSerializer()
        self.jsonRequestSerializer = requestSerializer
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func invalidate(cancelingPendingTasks cancelPendingTasks: Bool) {
        self.httpSessionManager.invalidateSessionCancelingTasks(cancelPendingTasks)
    }
}

// MARK: - Public request methods

extension VimeoSessionManager {

    public func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any? = nil,
        then callback: @escaping (SessionManagingResult<JSON, Error>) -> Void
    ) -> Task? {
        do {
            return try self.request(requestConvertible, parameters: parameters) { [jsonResponseSerializer] (dataResult: Result<Data, Error>, urlRequest, urlResponse) in
                let result = process(urlResponse, result: dataResult, with: jsonResponseSerializer)
                let sessionManagingResult = SessionManagingResult(
                    request: urlRequest,
                    response: urlResponse,
                    result: result
                )
                callback(sessionManagingResult)
            }
        } catch {
            let result = Result<JSON, Error>.failure(error)
            let sessionManagingResult = SessionManagingResult(result: result)
            callback(sessionManagingResult)
            return nil
        }
    }

    public func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile: URL,
        then callback: @escaping (SessionManagingResult<JSON, Error>) -> Void
    ) -> Task? {
        do {
            return try self.upload(
                requestConvertible,
                sourceFile: sourceFile
            ) { [jsonResponseSerializer] (dataResult: Result<Data, Error>, urlRequest, urlResponse) in
                let result = process(urlResponse, result: dataResult, with: jsonResponseSerializer)
                let sessionManagerResult = SessionManagingResult(
                    request: urlRequest,
                    response: urlResponse,
                    result: result
                )
                callback(sessionManagerResult)
            }
        } catch {
            let sessionManagingResult = SessionManagingResult(
                result: Result<JSON, Error>.failure(error)
            )
            callback(sessionManagingResult)
            return nil
        }
    }

    public func download(
        _ requestConvertible: URLRequestConvertible,
        then callback: @escaping (SessionManagingResult<URL, Error>) -> Void
    ) -> Task? {
        do {
            let request = try requestConvertible.asURLRequest()
            return self.httpSessionManager.downloadTask(
                with: request,
                progress: nil,
                destination: nil,
                completionHandler: { urlResponse, url, error in
                    let result: Result<URL, Error> = {
                        if let error = error {
                            return Result.failure(error)
                        } else if let url = url {
                            return Result.success(url)
                        } else {
                            return Result.failure(VNError.unknownError)
                        }
                    }()
                    let sessionManagingResult = SessionManagingResult<URL, Error>(
                        request: request,
                        response: urlResponse,
                        result: result
                    )
                    callback(sessionManagingResult)

                }
            )
        } catch {
            let result = Result<URL, Error>.failure(error)
            let sessionManagingResult = SessionManagingResult(result: result)
            callback(sessionManagingResult)
            return nil
        }
    }

}

// MARK: - Private request method helpers

private extension VimeoSessionManager {

    private func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any? = nil,
        then callback: @escaping (Result<Data, Error>, URLRequest, URLResponse?) -> Void
    ) throws -> Task? {
        let request = try requestConvertible.asURLRequest()
        var maybeError: NSError?
        guard let serializedRequest = jsonRequestSerializer.request(
            bySerializingRequest: request,
            withParameters: parameters,
            error: &maybeError
        ) else {
            let error = (maybeError as Error?) ?? VNError.serializatingError
            callback(Result.failure(error), request, nil)
            return nil
        }
        return self.httpSessionManager.dataTask(with: serializedRequest) { (urlResponse, value, error) in
            if let error = error {
                callback(Result.failure(error), request, urlResponse)
            } else if let data = value as? Data {
                callback(Result.success(data), request, urlResponse)
            } else {
                callback(Result.failure(VNError.unknownError), request, urlResponse)
            }
        }
    }

    private func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile sourceURL: URL,
        then callback: @escaping (Result<Data, Error>, URLRequest, URLResponse) -> Void
    ) throws -> Task? {
        let request = try requestConvertible.asURLRequest()
        return self.httpSessionManager.uploadTask(
            with: request,
            fromFile: sourceURL,
            progress: nil) { (urlResponse, value, error) in
                if let error = error {
                    callback(Result.failure(error), request, urlResponse)
                } else if let data = value as? Data {
                    callback(Result.success(data), request, urlResponse)
                } else {
                    callback(Result.failure(VNError.unknownError), request, urlResponse)
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
        let accessToken = account.accessToken
        jsonRequestSerializer.accessTokenProvider = {
            return accessToken
        }
    }

    /**
     Called when a client is logged out and the current account should be cleared from the session manager
     */
    public func clientDidClearAccount() {
        jsonRequestSerializer.accessTokenProvider = nil
    }
}

private func process(
    _ response: URLResponse?,
    result: Result<Data, Error>,
    with serializer: VimeoResponseSerializer
) -> Result<JSON, Error> {
    switch result {
    case .failure(let error):
        return Result<JSON, Error>.failure(error)
    case .success(let data):
        var maybeError: NSError?
        let maybeJSON = serializer.responseObject(
            for: response,
            data: data,
            error: &maybeError
        )
        if let error = maybeError {
            return Result.failure(error)
        } else if let json = maybeJSON {
            return Result.success(json)
        } else {
            return Result.failure(VNError.unknownError)
        }
    }
}
