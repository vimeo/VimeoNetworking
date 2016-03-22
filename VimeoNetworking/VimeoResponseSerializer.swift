//
//  VimeoResponseSerializer.swift
//  VimeoUpload
//
//  Created by Hanssen, Alfie on 10/16/15.
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

class VimeoResponseSerializer: AFJSONResponseSerializer
{
    private static let ErrorDomain = "VimeoResponseSerializerErrorDomain"
    
    override init()
    {
        super.init()

        self.acceptableContentTypes = VimeoResponseSerializer.acceptableContentTypes()
        self.readingOptions = .AllowFragments
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Public API

    func responseObjectFromDownloadTaskResponse(response response: NSURLResponse?, url: NSURL?, error: NSError?) throws -> [String: AnyObject]?
    {
        var responseObject: [String: AnyObject]? = nil
        var serializationError: NSError? = nil
        do
        {
            responseObject = try self.dictionaryFromDownloadTaskResponse(url: url)
        }
        catch let error as NSError
        {
            serializationError = error
        }
        
        try checkDataResponseForError(response: response, responseObject: responseObject, error: error)
        
        if let serializationError = serializationError
        {
            throw serializationError
        }
        
        return responseObject
    }
    
    func checkDataResponseForError(response response: NSURLResponse?, responseObject: AnyObject?, error: NSError?) throws
    {
        // TODO: If error is nil and errorInfo is non-nil, we should throw an error [AH] 2/5/2016
        
        let errorInfo = self.errorInfoFromResponse(response, responseObject: responseObject) ?? [:]
        
        if let error = error
        {
            throw error.errorByAddingUserInfo(errorInfo)
        }

        try self.checkStatusCodeValidity(response: response)
    }

    func checkStatusCodeValidity(response response: NSURLResponse?) throws
    {
        if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode < 200 || httpResponse.statusCode > 299
        {
            let userInfo = [NSLocalizedDescriptionKey: "Invalid http status code for download task."]
            throw NSError(domain: self.dynamicType.ErrorDomain, code: 0, userInfo: userInfo)
        }
    }
    
    func dictionaryFromDownloadTaskResponse(url url: NSURL?) throws -> [String: AnyObject]
    {
        guard let url = url else
        {
            let userInfo = [NSLocalizedDescriptionKey: "Url for completed download task is nil."]
            throw NSError(domain: self.dynamicType.ErrorDomain, code: 0, userInfo: userInfo)
        }
        
        guard let data = NSData(contentsOfURL: url) else
        {
            let userInfo = [NSLocalizedDescriptionKey: "Data at url for completed download task is nil."]
            throw NSError(domain: self.dynamicType.ErrorDomain, code: 0, userInfo: userInfo)
        }
        
        var dictionary: [String: AnyObject]? = [:]
        if data.length > 0
        {
            dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
        }
        
        if dictionary == nil
        {
            let userInfo = [NSLocalizedDescriptionKey: "Download task response dictionary is nil."]
            throw NSError(domain: self.dynamicType.ErrorDomain, code: 0, userInfo: userInfo)
        }
        
        return dictionary!
    }
    
    // MARK: Private API

    private func errorInfoFromResponse(response: NSURLResponse?, responseObject: AnyObject?) -> [String: AnyObject]?
    {
        var errorInfo: [String: AnyObject] = [:]
        
        if let dictionary = responseObject as? [String: AnyObject]
        {
            let errorKeys = ["error", "VimeoErrorCode", "error_code", "developer_message", "invalid_parameters"]
            
            for (key, value) in dictionary
            {
                if errorKeys.contains(key)
                {
                    errorInfo[key] = value
                }
            }
        }
        
        if let headerErrorCode = (response as? NSHTTPURLResponse)?.allHeaderFields["Vimeo-Error-Code"]
        {
            errorInfo["error_code"] = headerErrorCode
        }
        
        return errorInfo.count == 0 ? nil : errorInfo
    }

    private static func acceptableContentTypes() -> Set<String>
    {
        return Set(
            ["application/json",
            "text/json",
            "text/html",
            "text/javascript",
            "application/vnd.vimeo.*+json",
            "application/vnd.vimeo.user+json",
            "application/vnd.vimeo.video+json",
            "application/vnd.vimeo.error+json",
            "application/vnd.vimeo.uploadticket+json"]
        )
    }
}