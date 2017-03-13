//
//  ErrorCode.swift
//  VimeoNetworking
//
//  Created by Huebner, Rob on 4/25/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

/// `VimeoErrorCode` contains all api error codes that are currently recognized by our client applications
public enum VimeoErrorCode: Int
{
    // Upload
    case uploadStorageQuotaExceeded = 4101
    case uploadDailyQuotaExceeded = 4102
    
    case invalidRequestInput = 2204 // root error code for all invalid parameters errors below
    
    // Password-protected video playback
    case videoPasswordIncorrect = 2222
    case noVideoPasswordProvided = 2223
    
    // Authentication
    case emailTooLong = 2216
    case passwordTooShort = 2210
    case passwordTooSimple = 2211
    case nameInPassword = 2212
    case emailNotRecognized = 2217
    case passwordEmailMismatch = 2218
    case noPasswordProvided = 2209
    case noEmailProvided = 2214
    case invalidEmail = 2215
    case noNameProvided = 2213
    case nameTooLong = 2208
    case facebookJoinInvalidToken = 2303
    case facebookJoinNoToken = 2306
    case facebookJoinMissingProperty = 2304
    case facebookJoinMalformedToken = 2305
    case facebookJoinDecryptFail = 2307
    case facebookJoinTokenTooLong = 2308
    case facebookLoginNoToken = 2312
    case facebookLoginMissingProperty = 2310
    case facebookLoginMalformedToken = 2311
    case facebookLoginDecryptFail = 2313
    case facebookLoginTokenTooLong = 2314
    case facebookInvalidInputGrantType = 2221
    case facebookJoinValidateTokenFail = 2315
    case facebookInvalidNoInput = 2207
    case facebookInvalidToken = 2300
    case facebookMissingProperty = 2301
    case facebookMalformedToken = 2302
    case emailAlreadyRegistered = 2400
    case emailBlocked = 2401
    case emailSpammer = 2402
    case emailPurgatory = 2403
    case urlUnavailable = 2404
    case timeout = 5000
    case tokenNotGenerated = 5001
    case drmStreamLimitHit = 3420
    case drmDeviceLimitHit = 3421
    case unverifiedUser = 3411

    // Batch follow
    case batchUserDoesNotExist = 2900
    case batchFollowUserRequestExceeded = 2901
    case batchSubscribeChannelRequestExceeded = 2902
    case batchChannelDoesNotExist = 2903
    case userNotAllowedToFollowUsers = 3417
    case userNotAllowedToFollowChannels = 3418
    case batchFollowUserRequestFailed = 4005
    case batchSubscribeChannelRequestFailed = 4006
}

/// `HTTPStatusCode` contains HTTP status code constants used to inspect response status
public enum HTTPStatusCode: Int
{
    case serviceUnavailable = 503
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
}

/// `LocalErrorCode` contains codes for all error conditions that can be generated from within the library
public enum LocalErrorCode: Int
{
    // MARK: VimeoClient
    
    /// A response failed but returned no error object
    case undefined = 9000
    
    /// A response returned successfully, but the response dictionary was not valid
    case invalidResponseDictionary = 9001
    
    /// A request was not able to be initiated with the specified values
    case requestMalformed = 9002
    
    /// A cache-only request found no cached response
    case cachedResponseNotFound = 9003
    
    // MARK: VIMObjectMapper
    
    /// No model object class was specified for deserialization
    case noMappingClass = 9010
    
    /// Model object mapping was not successful
    case mappingFailed = 9011
    
    // MARK: AuthenticationController
    
    /// No access token was returned with a successful authentication response
    case authToken = 9004
    
    /// Could not retrieve parameters from code grant response
    case codeGrant = 9005
    
    /// Code grant returned state did not match existing state
    case codeGrantState = 9006
    
    /// No response was returned for an authenticationo request
    case noResponse = 9007
    
    /// Pin code authentication did not return an activate link or pin code
    case pinCodeInfo = 9008
    
    /// The currently active pin code has expired
    case pinCodeExpired = 9009
    
    // MARK: AccountStore
    
    /// An account object could not be decoded from keychain data
    case accountCorrupted = 9012
}
