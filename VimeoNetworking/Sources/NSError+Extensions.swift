//
//  NSError+Extensions.swift
//  VimemoUpload
//
//  Created by Alfred Hanssen on 2/5/16.
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
import AFNetworking

/// Stores string constants used to look up Vimeo-api-specific error information
public enum VimeoErrorKey: String
{
    case VimeoErrorCode = "VimeoLocalErrorCode" // Wish this could just be VimeoErrorCode but it conflicts with server-side key [AH] 2/5/2016
    case VimeoErrorDomain = "VimeoErrorDomain"
}

/// Convenience methods used to parse `NSError`s returned by Vimeo api responses
@objc public extension NSError
{
        /// Returns true if the error is a 503 Service Unavailable error
    public var isServiceUnavailableError: Bool
    {
        return self.statusCode == HTTPStatusCode.serviceUnavailable.rawValue
    }
    
        /// Returns true if the error is due to an invalid access token
    public var isInvalidTokenError: Bool
    {
        if let urlResponse = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse, urlResponse.statusCode == HTTPStatusCode.unauthorized.rawValue
        {
            if let header = urlResponse.allHeaderFields["Www-Authenticate"] as? String, header == "Bearer error=\"invalid_token\""
            {
                return true
            }
        }
        
        return false
    }
    
        /// Returns true if the error is due to the cancellation of a network task
    func isNetworkTaskCancellationError() -> Bool
    {
        return self.domain == NSURLErrorDomain && self.code == NSURLErrorCancelled
    }
    
        /// Returns true if the error is a url connection error
    func isConnectionError() -> Bool
    {
        return [NSURLErrorTimedOut,
            NSURLErrorCannotFindHost,
            NSURLErrorCannotConnectToHost,
            NSURLErrorDNSLookupFailed,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorNetworkConnectionLost].contains(self.code)
    }
    
    /**
     Generates a new `NSError`
     
     - parameter domain:      The domain in which the error was generated
     - parameter code:        A unique code identifying the error
     - parameter description: A developer-readable description of the error
     
     - returns: a new `NSError`
     */
    @nonobjc class func error(withDomain domain: String?, code: Int?, description: String?) -> NSError
    {
        var error = NSError(domain: VimeoErrorKey.VimeoErrorDomain.rawValue, code: 0, userInfo: nil)
        
        if let description = description
        {
            let userInfo = [NSLocalizedDescriptionKey: description]
            error = error.error(byAddingDomain: domain, code: code, userInfo: userInfo)
        }
        else
        {
            error = error.error(byAddingDomain: domain, code: code, userInfo: nil)
        }
        
        return error
    }
    
    /**
     Generates a new error with an added domain
     
     - parameter domain: New domain for the error
     
     - returns: An error with additional information in the user info dictionary
     */
    func error(byAddingDomain domain: String) -> NSError
    {
        return self.error(byAddingDomain: domain, code: nil, userInfo: nil)
    }
    
    /**
     Generates a new error with added user info
     
     - parameter userInfo: the user info dictionary to append to the existing user info
    
     - returns: An error with additional user info
     */
    func error(byAddingUserInfo userInfo: [String: Any]) -> NSError
    {
        return self.error(byAddingDomain: nil, code: nil, userInfo: userInfo)
    }
    
    /**
     Generates a new error with an added error code
     
     - parameter code: the new error code for the error
     
     - returns: An error with additional information in the user info dictionary
     */
    func error(byAddingCode code: Int) -> NSError
    {
        return self.error(byAddingDomain: nil, code: code, userInfo: nil)
    }
    
    /**
     Generates a new error with added information
     
     - parameter domain:   New domain for the error
     - parameter code:     the new error code for the error
     - parameter userInfo: the user info dictionary to append to the existing user info
     
     - returns: An error with additional information in the user info dictionary
     */
    @nonobjc func error(byAddingDomain domain: String?, code: Int?, userInfo: [String: Any]?) -> NSError
    {
        var augmentedInfo = self.userInfo
        
        if let domain = domain
        {
            augmentedInfo[VimeoErrorKey.VimeoErrorDomain.rawValue] = domain
        }
        
        if let code = code
        {
            augmentedInfo[VimeoErrorKey.VimeoErrorCode.rawValue] = code
        }
        
        if let userInfo = userInfo
        {
            augmentedInfo.append(userInfo)
        }
        
        return NSError(domain: self.domain, code: self.code, userInfo: augmentedInfo)
    }
    
    // MARK: -
    
    private struct Constants
    {
        static let VimeoErrorCodeHeaderKey = "Vimeo-Error-Code"
        static let VimeoErrorCodeKeyLegacy = "VimeoErrorCode"
        static let VimeoErrorCodeKey = "error_code"
        static let VimeoInvalidParametersKey = "invalid_parameters"
        static let VimeoUserMessageKey = "error"
        static let VimeoDeveloperMessageKey = "developer_message"
    }
    
        /// Returns the status code of the failing response, if available
    @nonobjc public var statusCode: Int?
    {
        if let response = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse
        {
            return response.statusCode
        }
        
        return nil
    }
    
        /// Returns the api error code of the failing response, if available
    @nonobjc public var vimeoServerErrorCode: Int?
    {
        if let errorCode = (self.userInfo[Constants.VimeoErrorCodeKeyLegacy] as? Int)
        {
            return errorCode
        }
        
        if let response = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse,
            let vimeoErrorCode = response.allHeaderFields[Constants.VimeoErrorCodeHeaderKey] as? String
        {
            return Int(vimeoErrorCode)
        }
        
        if let json = self.errorResponseBodyJSON,
            let errorCode = json[Constants.VimeoErrorCodeKey] as? Int
        {
            return errorCode
        }
        
        return nil
    }
    
        /// Returns the invalid parameters of the failing response, if available
    public var vimeoInvalidParametersErrorCodes: [Int]
    {
        var errorCodes: [Int] = []
        
        if let json = self.errorResponseBodyJSON, let invalidParameters = json[Constants.VimeoInvalidParametersKey] as? [[String: Any]]
        {
            for invalidParameter in invalidParameters
            {
                if let code = invalidParameter[Constants.VimeoErrorCodeKey] as? Int
                {
                    errorCodes.append(code)
                }
            }
        }
        
        return errorCodes
    }
    
        /// Returns the api error JSON dictionary, if available
    public var errorResponseBodyJSON: [String: Any]?
    {
        if let data = self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
        {
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                return json
            }
            catch
            {
                return nil
            }
        }
        
        return nil
    }
    
        /// Returns the first error code from the api error JSON dictionary if it exists, otherwise returns NSNotFound
    public var vimeoInvalidParametersFirstErrorCode: Int
    {
        return self.vimeoInvalidParametersErrorCodes.first ?? NSNotFound
    }
    
        /// Returns the user message from the api error JSON dictionary if it exists
    public var vimeoInvalidParametersFirstVimeoUserMessage: String?
    {
        guard let json = self.errorResponseBodyJSON, let invalidParameters = json[Constants.VimeoInvalidParametersKey] as? [AnyObject] else
        {
            return nil
        }
        
        return invalidParameters.first?[Constants.VimeoUserMessageKey] as? String
    }
    
        /// Returns an underscore separated string of all the error codes in the the api error JSON dictionary if any exist, otherwise returns nil
    public var vimeoInvalidParametersErrorCodesString: String?
    {
        let errorCodes = self.vimeoInvalidParametersErrorCodes
        
        guard errorCodes.count > 0 else
        {
            return nil
        }
        
        var result = ""
        
        for code in errorCodes
        {
            result += "\(code)_"
        }
        
        return result.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }
    
        /// Returns the "error" key from the api error JSON dictionary if it exists, otherwise returns nil
    public var vimeoUserMessage: String?
    {
        guard let json = self.errorResponseBodyJSON else
        {
            return nil
        }
        
        return json[Constants.VimeoUserMessageKey] as? String
    }
    
        /// Returns the "developer_message" key from the api error JSON dictionary if it exists, otherwise returns nil
    public var vimeoDeveloperMessage: String?
    {
        guard let json = self.errorResponseBodyJSON else
        {
            return nil
        }
        
        return json[Constants.VimeoDeveloperMessageKey] as? String
    }
}
