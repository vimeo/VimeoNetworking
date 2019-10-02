//
//  VimeoNetworkingError.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 9/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// A type representing all possible errors provided by the library
enum VimeoNetworkingError: Error {
    case encodingFailed(EncodingFailedReason)
    case decodingFailed(DecodingFailedReason)
    case unknownError
    
    enum DecodingFailedReason {
        case responseDataNotFound
    }
    
    enum EncodingFailedReason {
        case invalidParameters
        case missingURL
        case missingHTTPMethod
        case jsonEncoding(error: Error)
    }
}

extension VimeoNetworkingError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case let .encodingFailed(reason):
            return errorMessage(for: reason)
        case let .decodingFailed(reason):
            return errorMessage(for: reason)
        case .unknownError:
            return .unknownError
        }
    }

    private func errorMessage(for reason: EncodingFailedReason) -> String? {
        switch reason {
        case .invalidParameters:
            return .encodingFailedInvalidParameters
        case .missingURL:
            return .encodingFailedMissingURL
        case .missingHTTPMethod:
            return .encodingFailedMissingHTTPMethod
        case .jsonEncoding(let error):
            return String(format: .encodingFailedJSONEncoding, error.localizedDescription)
        }
    }

    private func errorMessage(for reason: DecodingFailedReason) -> String? {
        switch reason {
        case .responseDataNotFound:
            return .decodingFailedDataMissing
        }
    }
}

// MARK: - Private extension

private extension String {
    static let unknownError = NSLocalizedString(
        "An unknown error has occurred",
        comment: "Message indicating that an unknown network error has occurred"
    )

    static let encodingFailedInvalidParameters = NSLocalizedString(
        "There was an error encoding the request because it included invalid parameters",
        comment: "Message indicating that an encoding error due to invalid parameters has occurred"
    )

    static let encodingFailedMissingURL = NSLocalizedString(
        "There was an error encoding the request because it was missing a URL",
        comment: "Message indicating that an encoding error due to a missing URL has occurred"
    )

    static let encodingFailedMissingHTTPMethod = NSLocalizedString(
        "There was an error encoding the request because it was missing its HTTP method",
        comment: "Message indicating that an encoding error due to a missing HTTP method has occurred"
    )

    static let encodingFailedJSONEncoding = NSLocalizedString(
        "There was an error encoding the request into JSON: %@",
        comment: "Message indicating that a JSON encoding error has occurred"
    )

    static let decodingFailedDataMissing = NSLocalizedString(
        "There was an error decoding the request because no data was found",
        comment: "Message indicating that a decoding error due to missing data has occurred"
    )
}
