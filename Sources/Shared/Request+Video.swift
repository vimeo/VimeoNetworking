//
//  Request+Video.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 4/5/16.
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

/// `Request` returning a single `VIMVideo`
public typealias VideoRequest = Request<VIMVideo>

/// `Request` returning an array of `VIMVideo`
public typealias VideoListRequest = Request<[VIMVideo]>

public extension Request {
    // MARK: -
    
    /**
     Create a `Request` to get a specific video
     
     - parameter videoURI: the video's URI
     
     - returns: a new `Request`
     */
    static func videoRequest(forVideoURI videoURI: String) -> Request {
        return Request(path: videoURI)
    }
    
    /**
     Create a `Request` to get a specific VOD video
     
     - parameter vodVideoURI: the VOD video's URI
     
     - returns: a new `Request`
     */
    static func vodVideoRequest(forVODVideoURI vodVideoURI: String) -> Request {
        let parameters = ["_video_override": "true"]
        
        return Request(path: vodVideoURI, parameters: parameters)
    }
    
    /**
     Create a `Request` to get the selected users for the vieo
     
     - parameter videoURI: the URI of the video
     
     - returns: a new `Request`
     */
    static func selectedUsersRequest(forVideoURI videoURI: String) -> Request {
        let parameters = [String.perPageKey: 100]
        
        let path = videoURI + .selectedUsersPrivacyPath
        
        return Request(path: path, parameters: parameters)
    }
    
    // MARK: - Search
    
    /**
     Create a `Request` to search for videos
     
     - parameter query:       the string query to use for the search
     - parameter refinements: optionally, refinement parameters to add to the search
     
     - returns: a new `Request`
     */
    static func queryVideos(withQuery query: String, refinements: VimeoClient.RequestParametersDictionary? = nil) -> Request {
        var parameters = refinements ?? [:]
        
        parameters[.queryKey] = query
        
        return Request(path: .videosPath, parameters: parameters)
    }
    
    // MARK: - Edit Video
    
    /**
     Create a `Request` to update a video's metadata
     
     - parameter videoURI:   the URI of the video to update
     - parameter parameters: the updated parameters
     
     - returns: a new `Request`
     */
    static func patchVideoRequest(withVideoURI videoURI: String, parameters: VimeoClient.RequestParametersDictionary) -> Request {
        return Request(method: .patch, path: videoURI, parameters: parameters)
    }
    
    /**
     Create a `Request` to delete a video
     
     - parameter videoURI: the URI of the video to update
     
     - returns: a new `Request`
     */
    static func deleteVideoRequest(forVideoURI videoURI: String) -> Request {
        return Request(method: .delete, path: videoURI)
    }
}

private extension String {
    // Request & response keys
    static let perPageKey = "per_page"
    static let queryKey = "query"

    // Paths
    static let selectedUsersPrivacyPath = "/privacy/users"
    static let videosPath = "/videos"
}
