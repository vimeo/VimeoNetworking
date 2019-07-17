//
//  XCTAssert+Extensions.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Rogerio de Paula Assis on 6/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import XCTest

public func XCTAssertEqualAndNotNil<T>(
    _ expression1: @autoclosure () throws -> T,
    _ expression2: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) where T: Equatable {
    try XCTAssertNotNil(expression1())
    try XCTAssertNotNil(expression2())
    try XCTAssertEqual(expression1(), expression2(), message(), file: file, line: line)
}
