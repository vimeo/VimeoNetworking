//
//  MappableResponse.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
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

private let DefaultModelKeyPath = "data"

/**
 *  `MappableResponse` represents an object that can be automatically deserialized from a JSON response dictionary to a model object.  Conformance to this protocol allows a type to participate as the `ModelType` in a `Request`.  You should not adopt this protocol directly, but should subclass `VIMModelObject` for new models.  `VIMModelObject` as well as arrays with an element type of `VIMModelObject` conform to `MappableResponse`.  `VIMNullResponse` also conforms to this protocol, which allows for the representation of successful requests that intentionally return no response dictionary.
 */
public protocol MappableResponse {
    
    /// Returns the class type used by `VIMObjectMapper` to deserialize the response
    static var mappingClass: AnyClass { get }
    
    /// Optionally returns a nested JSON key to reference for mapping
    static var modelKeyPath: String? { get }
    
    /**
     Implemented by model objects to ensure that their own values are valid for use, called as a step in model object parsing, parsing will fail if this throws an error
     
     - throws: An error if a model object's values are somehow invalid.
     */
    func validateModel() throws
}

/**
 *  `VIMModelObject` conformance to `MappableResponse` enables all model objects derived from `VIMModelObject` to participate as the `ModelType` in a `Request`.
 */
extension VIMModelObject: MappableResponse {
    
    public static var mappingClass: AnyClass {
        return self
    }
    
    public static var modelKeyPath: String? {
        return nil
    }
        
}

/**
 *  `Array` conformance to `MappableResponse` enables arrays of any model object
 *  type to participate as the `ModelType` in a `Request`.
 */
extension Array: MappableResponse where Element: VIMModelObject {

    public static var mappingClass: AnyClass {
        return Element.self
    }
    
    public static var modelKeyPath: String? {
        return DefaultModelKeyPath
    }
    
    public func validateModel() throws {
        for model in self {
            try model.validateModel()
        }
    }
}

/**
 *  `VIMNullResponse` is a model object containing no information. This allows for the representation of successful requests that intentionally return no response dictionary.
 */
public class VIMNullResponse: MappableResponse {
    
    public static var mappingClass: AnyClass {
        return self
    }
    
    public static var modelKeyPath: String? {
        return nil
    }
    
    public func validateModel() throws {
        // NO-OP: a null response object is always valid
    }
}
