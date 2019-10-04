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

    /// Getter and setter for the securityPolicy property on AFHTTPSessionManager
    @objc public var securityPolicy: SecurityPolicy {
        get { return self.httpSessionManager.securityPolicy }
        set { self.httpSessionManager.securityPolicy = newValue }
    }
    
    /// Getter and setter for acceptableContentTypes property on the Vimeo/JSON response serializer
    @objc public var acceptableContentTypes: Set<String>? {
        get { return self.jsonResponseSerializer.acceptableContentTypes }
        set { self.jsonResponseSerializer.acceptableContentTypes = newValue }
    }

    /// The custom Vimeo request serializer that is used for serializing Data requests into JSON
    public let jsonRequestSerializer: VimeoRequestSerializer

    /// The custom Vimeo response serializer that is used for serializing Data responses into JSON
    public lazy var jsonResponseSerializer = VimeoResponseSerializer()

    // MARK: - Private

    /// The JSONDecoder instance used for decoding decodable type responses
    private lazy var jsonDecoder = JSONDecoder()

    // The underlying HTTP Session Manager
    private let httpSessionManager: AFHTTPSessionManager

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

    // MARK: - Data Request

    /// Creates a data request from a `URLRequestConvertible` and a set of parameters, if any
    ///
    /// - Parameters:
    ///   - requestConvertible: `URLRequestConvertible` the value used to create the `URLRequest`.
    ///   - parameters: `Any?` parameters to be serialized and sent with to the `URLRequest`
    ///   - callback: The closure to be executed once the request completes. The closure takes a single
    ///   SessionManagingResult<Data> argument that wraps the `URLRequest`, `URLResponse` and `Result`
    ///   of the request operation.
    ///   Note that this API makes no guarantees as to which queue the callback will be executed on.
    ///
    /// - Returns: the `Task` object related to the request.
    public func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any? = nil,
        then callback: @escaping (SessionManagingResult<Data>) -> Void
    ) -> Task? {
        do {
            let request = try requestConvertible.asURLRequest()
            var maybeError: NSError?
            guard let serializedRequest = jsonRequestSerializer.request(
                bySerializingRequest: request,
                withParameters: parameters,
                error: &maybeError
            ) else {
                let error = (maybeError as Error?) ?? VNError.serializatingError
                let sessionManagingResult = SessionManagingResult<Data>(
                    request: request,
                    result: Result.failure(error)
                )
                callback(sessionManagingResult)
                return nil
            }
            return self.httpSessionManager.dataTask(with: serializedRequest) { (urlResponse, value, error) in
                let result: Result<Data, Error> = {
                    if let error = error {
                        return Result.failure(error)
                    } else if let data = value as? Data {
                        return Result.success(data)
                    } else {
                        return Result.failure(VNError.unknownError)
                    }
                }()
                let sessionManagingResult = SessionManagingResult(request: request, response: urlResponse, result: result)
                callback(sessionManagingResult)
            }
        } catch {
            let sessionManagingResult = SessionManagingResult(result: Result<Data, Error>.failure(error))
            callback(sessionManagingResult)
            return nil
        }
    }

    // MARK: - JSON Request

    /// Creates a data request from a `URLRequestConvertible` and a set of parameters, if any
    ///
    /// - Parameters:
    ///   - requestConvertible: the value used to create the `URLRequest`.
    ///   - parameters: `Any?` parameters to be serialized and sent with to the `URLRequest`
    ///   - callback: The closure to be executed once the request completes. The closure takes a single
    ///   SessionManagingResult<JSON> argument that wraps the `URLRequest`, `URLResponse` and `Result`
    ///   of the request operation.
    ///   Note that this API makes no guarantees as to which queue the callback will be executed on.
    ///
    /// - Returns: the `Task` object related to the request.
    public func request(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any? = nil,
        then callback: @escaping (SessionManagingResult<JSON>) -> Void
    ) -> Task? {
        return self.request(requestConvertible, parameters: parameters) { [jsonResponseSerializer] (sessionManagingResult: SessionManagingResult<Data>) in
            let result = process(sessionManagingResult.response, result: sessionManagingResult.result, with: jsonResponseSerializer)
            let sessionManagingResult = SessionManagingResult(
                request: sessionManagingResult.request,
                response: sessionManagingResult.response,
                result: result
            )
            callback(sessionManagingResult)
        }
    }

    // MARK: - Decodable Request

    /// Creates a data request from a `URLRequestConvertible` and a set of parameters, if any
    ///
    /// - Parameters:
    ///   - requestConvertible: the value used to create the `URLRequest`.
    ///   - parameters: `Any?` parameters to be serialized and sent with to the `URLRequest`
    ///   - callback: The closure to be executed once the request completes. The closure takes a single
    ///   SessionManagingResult<T: Decodable> argument that wraps the `URLRequest`, `URLResponse` and `Result`
    ///   of the request operation.
    ///   Note that this API makes no guarantees as to which queue the callback will be executed on.
    ///
    /// - Returns: the `Task` object related to the request.
    public func request<T: Decodable>(
        _ requestConvertible: URLRequestConvertible,
        parameters: Any? = nil,
        then callback: @escaping (SessionManagingResult<T>) -> Void
    ) -> Task? {
        return self.request(requestConvertible, parameters: parameters) { [jsonDecoder] (sessionManagingResult: SessionManagingResult<Data>) in
            let decodedResult = sessionManagingResult.result
                .flatMap { data -> Result<T, Error> in
                    do {
                        let decoded = try jsonDecoder.decode(T.self, from: data)
                        return Result.success(decoded)
                    } catch {
                        return Result<T, Error>.failure(error)
                    }
                }
            let sessionManagingResult = SessionManagingResult(
                request: sessionManagingResult.request,
                response: sessionManagingResult.response,
                result: decodedResult
            )
            callback(sessionManagingResult)
        }
    }

    /// Creates an upload request for the file at the given `sourceFile` URL,
    /// using the `URLRequestConvertible` value to create the `URLRequest`.
    ///
    /// - Parameters:
    ///   - requestConvertible: the value used to create the `URLRequest`.
    ///   - sourceFile: The `URL` of the file to be uploaded.
    ///   - callback: The closure to be executed once the request completes. The closure takes a single
    ///   SessionManagingResult<JSON> argument that wraps the `URLRequest`, `URLResponse` and `Result`
    ///   of the request operation.
    ///   Note that this API makes no guarantees as to which queue the callback will be executed on.
    ///
    /// - Returns: the `Task` object related to the request.
    public func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile: URL,
        then callback: @escaping (SessionManagingResult<JSON>) -> Void
    ) -> Task? {
        do {
            return try self.upload(
                requestConvertible,
                sourceFile: sourceFile
            ) { [jsonResponseSerializer] (sessionManagingResult: SessionManagingResult<Data>) in
                let result = process(
                    sessionManagingResult.response,
                    result: sessionManagingResult.result,
                    with: jsonResponseSerializer
                )
                let sessionManagerResult = SessionManagingResult(
                    request: sessionManagingResult.request,
                    response: sessionManagingResult.response,
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

    /// Creates a download request for the file and saves it at the give `destinationURL`,
    /// using the `URLRequestConvertible` value to create the `URLRequest`.
    ///
    /// - Parameters:
    ///   - requestConvertible: the value used to create the `URLRequest`.
    ///   - destinationURL: The `URL` where the file should be downloaded to. If a URL is not specified the
    ///   file will be downloaded to a temporary location.
    ///   - callback: The closure to be executed once the request completes. The closure takes a single
    ///   SessionManagingResult<URL> argument that wraps the `URLRequest`, `URLResponse` and `Result`
    ///   of the request operation.
    ///   Note that this API makes no guarantees as to which queue the callback will be executed on.
    ///
    /// - Returns: the `Task` object related to the request.
    public func download(
        _ requestConvertible: URLRequestConvertible,
        destinationURL: URL? = nil,
        then callback: @escaping (SessionManagingResult<URL>) -> Void
    ) -> Task? {
        do {
            let request = try requestConvertible.asURLRequest()
            return self.httpSessionManager.downloadTask(
                with: request,
                progress: nil,
                destination: { temporaryURL, _ in return destinationURL ?? temporaryURL },
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
                    let sessionManagingResult = SessionManagingResult<URL>(
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

    private func upload(
        _ requestConvertible: URLRequestConvertible,
        sourceFile sourceURL: URL,
        then callback: @escaping (SessionManagingResult<Data>) -> Void
    ) throws -> Task? {
        let request = try requestConvertible.asURLRequest()
        return self.httpSessionManager.uploadTask(
            with: request,
            fromFile: sourceURL,
            progress: nil) { (urlResponse, value, error) in
                let result: Result<Data, Error> = {
                    if let error = error {
                        return Result.failure(error)
                    } else if let data = value as? Data {
                        return Result.success(data)
                    } else {
                        return Result.failure(VNError.unknownError)
                    }
                }()
                let sessionManagingResult = SessionManagingResult(
                    request: request,
                    response: urlResponse,
                    result: result
                )
                callback(sessionManagingResult)
        }
    }
}

// Wrapper extensions to hide internals of `httpSessionManager`
extension VimeoSessionManager {
    public func task(forIdentifier identifier: Int) -> URLSessionTask? {
        return self.httpSessionManager.tasks
            .filter { $0.taskIdentifier == identifier }.first
    }

    public func downloadTask(forIdentifier identifier: Int) -> URLSessionDownloadTask? {
        return self.httpSessionManager.downloadTasks
            .filter { $0.taskIdentifier == identifier }.first
    }

    public func downloadProgress(for task: URLSessionTask) -> Progress? {
        return self.httpSessionManager.downloadProgress(for: task)
    }

    public func uploadTask(forIdentifier identifier: Int) -> URLSessionUploadTask? {
        return self.httpSessionManager.uploadTasks
            .filter { $0.taskIdentifier == identifier }.first
    }

    public func uploadProgress(for task: URLSessionTask) -> Progress? {
        return self.httpSessionManager.uploadProgress(for: task)
    }

    public func configureDidBecomeInvalidClosure(_ closure: @escaping (URLSession, Error) -> Void) {
        self.httpSessionManager.setSessionDidBecomeInvalidBlock(closure)
    }

    public func configureDownloadTaskDidFinishDownloadingClosure(
        _ closure: @escaping (URLSession, URLSessionDownloadTask, URL) -> URL?
    ) {
        self.httpSessionManager.setDownloadTaskDidFinishDownloadingBlock(closure)
    }

    public func configureTaskDidCompleteClosure(
        _ closure: @escaping (URLSession, URLSessionTask, Error?) -> Void
    ) {
        self.httpSessionManager.setTaskDidComplete(closure)
    }

    public func configureDidFinishEventsForBackgroundURLSessionClosure(
        _ closure: @escaping (URLSession) -> Void
    ) {
        self.httpSessionManager.setDidFinishEventsForBackgroundURLSessionBlock(closure)
    }

    public var sessionIdentifier: String? {
        return self.httpSessionManager.session.configuration.identifier
    }
}

// MARK: - Authentication

extension VimeoSessionManager: AuthenticationListeningDelegate {

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
    return result.flatMap { data -> Result<JSON, Error> in
        guard data.isEmpty == false else {
            return Result.success([:])
        }
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
