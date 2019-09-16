//
//  BatchOperable.swift
//  VimeoNetworking
//
//  Copyright © 2019 Vimeo. All rights reserved.
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

/// Conforming objcets are capable of being added and to, or removed from, a containing object in a single request.
public protocol BatchOperable: Equatable {
    /// An identifier for the item.
    var uri: String? { get }

    /// The key required to indicate the item is being batch added to a containing object.
    static var addParameter: String { get }

    /// The key required to indicate the item is being batch removed from a containing object.
    static var removeParameter: String { get }

    /// The key required for some batch requests to indicate the type of the batch item being operated on. Note that not all batch requests use this parameter and will fail if
    ///  provided. Check Vimeo's API documentation for more information.
    static var batchTypeParameter: String? { get }
}

extension Album: BatchOperable {
    static public var addParameter: String { return "add" }
    static public var removeParameter: String { return "remove" }
    static public var batchTypeParameter: String? { return nil }
}

extension VIMVideo: BatchOperable {
    static public var addParameter: String { return "set" }
    static public var removeParameter: String { return "remove" }
    static public var batchTypeParameter: String? { return "video" }
}
