//
//  VIMObjectMapper+Generic.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 4/12/16.
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

extension VIMObjectMapper
{
    static var ErrorDomain: String { return "ObjectMapperErrorDomain" }
    
    /**
     Deserializes a response dictionary into a model object
     
     - parameter ModelType:          The type of the model object to map `responseDictionary` onto
     - parameter responseDictionary: The JSON dictionary response to deserialize
     - parameter modelKeyPath:       optionally, a nested JSON key path at which to originate parsing
     
     - throws: An NSError if parsing fails or the mapping class is invalid
     
     - returns: A deserialized object of type `ModelType`
     */
    static func mapObject<ModelType: MappableResponse>(responseDictionary: VimeoClient.ResponseDictionary, modelKeyPath: String? = nil) throws -> ModelType
    {
        guard let mappingClass = ModelType.mappingClass
        else
        {
            let description = "no mapping class found"
            
            assertionFailure(description)
            
            let error = NSError(domain: self.ErrorDomain, code: LocalErrorCode.NoMappingClass.rawValue, userInfo: [NSLocalizedDescriptionKey: description])
            
            throw error
        }
        
        let objectMapper = VIMObjectMapper()
        let modelKeyPath = modelKeyPath ?? ModelType.modelKeyPath
        objectMapper.addMappingClass(mappingClass, forKeypath: modelKeyPath ?? "")
        var mappedObject = objectMapper.applyMappingToJSON(responseDictionary)
        
        if let modelKeyPath = modelKeyPath
        {
            mappedObject = (mappedObject as? VimeoClient.ResponseDictionary)?[modelKeyPath]
        }
        
        guard let modelObject = mappedObject as? ModelType
        else
        {
            let description = "couldn't map to ModelType"
            
            assertionFailure(description)
            
            let error = NSError(domain: self.ErrorDomain, code: LocalErrorCode.MappingFailed.rawValue, userInfo: [NSLocalizedDescriptionKey: description])
            
            throw error
        }
        
        try modelObject.validateModel()
        
        return modelObject
    }
}
