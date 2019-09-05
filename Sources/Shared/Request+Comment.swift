//
//  Request+Comment.swift
//  Pods
//
//  Created by King, Gavin on 10/20/16.
//
//

import Foundation

public extension Request {
    /**
     Create a request that posts a comment on a video or a reply on a comment
     
     - parameter uri: the comments or replies URI
     
     - returns: a new `Request`
     */
    static func postCommentRequest(forURI uri: String, text: String) -> Request {
        let parameters = ["text": text]
        
        return Request(method: .post, path: uri, parameters: parameters)
    }
}
