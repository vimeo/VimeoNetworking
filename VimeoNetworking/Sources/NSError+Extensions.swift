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
public extension NSError
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
            if let header = urlResponse.allHeaderFields["WWW-Authenticate"] as? String, header == "Bearer error=\"invalid_token\""
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
    class func errorWithDomain(_ domain: String?, code: Int?, description: String?) -> NSError
    {
        var error = NSError(domain: VimeoErrorKey.VimeoErrorDomain.rawValue, code: 0, userInfo: nil)
        
        if let description = description
        {
            let userInfo = [NSLocalizedDescriptionKey: description]
            error = error.errorByAddingDomain(domain, code: code, userInfo: userInfo as [String : AnyObject]?)
        }
        else
        {
            error = error.errorByAddingDomain(domain, code: code, userInfo: nil)
        }
        
        return error
    }
    
    /**
     Generates a new error with an added domain
     
     - parameter domain: New domain for the error
     
     - returns: An error with additional information in the user info dictionary
     */
    func errorByAddingDomain(_ domain: String) -> NSError
    {
        return self.errorByAddingDomain(domain, code: nil, userInfo: nil)
    }
    
    /**
     Generates a new error with added user info
     
     - parameter userInfo: the user info dictionary to append to the existing user info
    
     - returns: An error with additional user info
     */
    func errorByAddingUserInfo(_ userInfo: [String: AnyObject]) -> NSError
    {
        return self.errorByAddingDomain(nil, code: nil, userInfo: userInfo)
    }
    
    /**
     Generates a new error with an added error code
     
     - parameter code: the new error code for the error
     
     - returns: An error with additional information in the user info dictionary
     */
    func errorByAddingCode(_ code: Int) -> NSError
    {
        return self.errorByAddingDomain(nil, code: code, userInfo: nil)
    }
    
    /**
     Generates a new error with added information
     
     - parameter domain:   New domain for the error
     - parameter code:     the new error code for the error
     - parameter userInfo: the user info dictionary to append to the existing user info
     
     - returns: An error with additional information in the user info dictionary
     */
    func errorByAddingDomain(_ domain: String?, code: Int?, userInfo: [String: AnyObject]?) -> NSError
    {
//        let augmentedInfo = NSMutableDictionary(dictionary: self.userInfo)
        var augmentedInfo = self.userInfo as [AnyHashable: Any]
        
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
            augmentedInfo.append(dictionary: userInfo)
        }
        
        return NSError(domain: self.domain, code: self.code, userInfo: augmentedInfo)
    }
    
    // MARK: -
    
    fileprivate static let VimeoErrorCodeHeaderKey = "Vimeo-Error-Code"
    fileprivate static let VimeoErrorCodeKeyLegacy = "VimeoErrorCode"
    fileprivate static let VimeoErrorCodeKey = "error_code"
    fileprivate static let VimeoInvalidParametersKey = "invalid_parameters"
    fileprivate static let VimeoUserMessageKey = "error"
    fileprivate static let VimeoDeveloperMessageKey = "developer_message"
    
        /// Returns the status code of the failing response, if available
    public var statusCode: Int?
    {
        if let response = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey]
        {
            return (response as AnyObject).statusCode
        }
        
        return nil
    }
    
        /// Returns the api error code of the failing response, if available
    public var vimeoServerErrorCode: Int?
    {
        if let errorCode = (self.userInfo[type(of: self).VimeoErrorCodeKeyLegacy] as? NSNumber)?.intValue
        {
            return errorCode
        }
        
        if let response = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey],
            let headers = (response as AnyObject).allHeaderFields,
            let vimeoErrorCode = headers[type(of: self).VimeoErrorCodeHeaderKey] as? String
        {
            return Int(vimeoErrorCode)
        }
        
        if let json = self.errorResponseBodyJSON,
            let errorCode = (json[type(of: self).VimeoErrorCodeKey] as? NSNumber)?.intValue
        {
            return errorCode
        }
        
        return nil
    }
    
        /// Returns the invalid parameters of the failing response, if available
    public var vimeoInvalidParametersErrorCodes: [Int]
    {
        var errorCodes: [Int] = []
        
        if let json = self.errorResponseBodyJSON, let invalidParameters = json[type(of: self).VimeoInvalidParametersKey] as? [[String: AnyObject]]
        {
            for invalidParameter in invalidParameters
            {
                if let code = invalidParameter[type(of: self).VimeoErrorCodeKey] as? Int
                {
                    errorCodes.append(code)
                }
            }
        }
        
        return errorCodes
    }
    
        /// Returns the api error JSON dictionary, if available
    public var errorResponseBodyJSON: [String: AnyObject]?
    {
        if let data = self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
        {
            do
            {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                
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
        guard let json = self.errorResponseBodyJSON, let invalidParameters = json[type(of: self).VimeoInvalidParametersKey] as? [AnyObject] else
        {
            return nil
        }
        
        return invalidParameters.first?[type(of: self).VimeoUserMessageKey] as? String
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
        
        return json[type(of: self).VimeoUserMessageKey] as? String
    }
    
        /// Returns the "developer_message" key from the api error JSON dictionary if it exists, otherwise returns nil
    public var vimeoDeveloperMessage: String?
    {
        guard let json = self.errorResponseBodyJSON else
        {
            return nil
        }
        
        return json[type(of: self).VimeoDeveloperMessageKey] as? String
    }
}
