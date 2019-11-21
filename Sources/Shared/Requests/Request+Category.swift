//
//  Request+Category.swift
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

/// `Request` that returns a single `VIMCategory`
public typealias CategoryRequest = Request<VIMCategory>

/// `Request` that returns an array of `VIMCategory`
public typealias CategoryListRequest = Request<[VIMCategory]>

public extension Request {
    private static var CategoriesPath: String { return "/categories" }
    
    /**
     Create a request that gets a specific category
     
     - parameter categoryURI: the category URI
     
     - returns: a new `Request`
     */
    static func getCategoryRequest(forCategoryURI categoryURI: String) -> Request {
        return Request(path: categoryURI)
    }
    
    /**
     Create a request that returns a list of all categories
     
     - returns: a new `Request`
     */
    static func getCategoriesRequest() -> Request {
        return Request(path: self.CategoriesPath)
    }
}
