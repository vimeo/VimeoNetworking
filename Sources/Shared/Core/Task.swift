//
//  Task.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// A protocol representing an asynchronous task that can be resumed and cancelled
public protocol Task {
    var id: Int { get }
    func cancel()
    func resume()
}

extension URLSessionTask: Task {
    public var id: Int { return self.taskIdentifier }
}
