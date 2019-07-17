//
//  Optional+Require.swift
//  VimeoTestsSupport
//
//  Created by Rogerio de Paula Assis on 7/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

extension Optional {
    
    /// Returns the unwrapped value or throws an exception if unable to unwrap it
    /// - Parameter message: a message that will be included as part of the exception raised
    /// - Parameter file: the filename where the exception occurred
    /// - Parameter line: the line of code where the exception occurred
    ///
    /// Use require in favor of force unwrapping "non-optional optionals".
    /// This will provide us with additional context and meaningful error messages
    /// to help with debugging.
    ///
    /// Example usage: `anOptionalValue?.require()`
    ///
    func require(
        message: @autoclosure () -> String? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Wrapped {
        guard let unwrapped = self else {
            let message = message() ?? String()
            let errorMessage = "Found nil while trying to unwrap a required value in \(file), at line \(line). \(message)"
            
            let exception = NSException(
                name: .invalidArgumentException,
                reason: errorMessage,
                userInfo: nil
            )
            
            exception.raise()
            preconditionFailure(errorMessage)
        }
        return unwrapped
    }
}
