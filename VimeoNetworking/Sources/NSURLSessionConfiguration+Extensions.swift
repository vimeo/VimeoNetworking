//
//  NSURLSessionConfiguration+Extensions.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 5/26/16.
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

import Foundation

extension NSURLSessionConfiguration
{
    /**
     Convenience method for creating a defaultSessionConfiguration() with the supplied request cache policy
     
     - parameter cachePolicy: an NSURLRequestCachePolicy constant defining the caching policy to the session will use
     
     - returns: an NSURLSessionConfiguration.defaultSessionConfiguration() with the desired cache policy set
     */
    class func defaultSessionConfigurationWithCachePolicy(cachePolicy: NSURLRequestCachePolicy) -> NSURLSessionConfiguration {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.requestCachePolicy = cachePolicy
        
        return sessionConfiguration
    }

    /**
     Convenience method for creating a defaultSessionConfiguration() that does not use the local cache when making requests
     
     - returns: an NSURLSessionConfiguration.defaultSessionConfiguration() with the request cache policy set to .ReloadIgnoringLocalCacheData
     */
    class func defaultSessionConfigurationNoCache() -> NSURLSessionConfiguration {
        return NSURLSessionConfiguration.defaultSessionConfigurationWithCachePolicy(.ReloadIgnoringLocalCacheData)
    }
}
