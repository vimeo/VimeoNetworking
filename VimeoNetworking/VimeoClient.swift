//
//  VimeoClient.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/21/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

enum Result<ModelType where ModelType: Mappable>
{
    case Success(result: ModelType)
    case Failure(error: NSError)
}

/// This dummy enum acts as a generic typealias
enum RequestCompletion<ModelType where ModelType: Mappable>
{
    typealias T = (result: Result<ModelType>) -> Void
}

class VimeoClient
{
    // MARK: - 
    
    enum Method
    {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }
    
    typealias RequestParameters = [String: String]
    
    static let ErrorDomain = "VimeoClientErrorDomain"
    static let ErrorInvalidDictionary = 1001
    static let ErrorNoMappingClass = 1002
    static let ErrorMappingFailed = 1003
    
    // MARK: -
    
    let sessionManager: VimeoSessionManager
    
    init(sessionManager: VimeoSessionManager)
    {
        self.sessionManager = sessionManager
    }
    
    // MARK: -
    
    func request<ModelType where ModelType: Mappable>(request: Request<ModelType>, completion: RequestCompletion<ModelType>.T)
    {
        let urlString = request.path
        let parameters = request.parameters
        
        let success: (NSURLSessionDataTask, AnyObject?) -> Void = { (task, responseObject) in
            self.requestSuccess(request: request, task: task, responseObject: responseObject, completion: completion)
        }
        
        let failure: (NSURLSessionDataTask?, NSError) -> Void = { (task, error) in
            self.requestFailure(request: request, task: task, error: error, completion: completion)
        }
        
        switch request.method
        {
        case .GET:
            self.sessionManager.GET(urlString, parameters: parameters, success: success, failure: failure)
        case .POST:
            self.sessionManager.POST(urlString, parameters: parameters, success: success, failure: failure)
        case .PUT:
            self.sessionManager.PUT(urlString, parameters: parameters, success: success, failure: failure)
        case .PATCH:
            self.sessionManager.PATCH(urlString, parameters: parameters, success: success, failure: failure)
        case .DELETE:
            self.sessionManager.DELETE(urlString, parameters: parameters, success: success, failure: failure)
        }
    }
    
    private func requestSuccess<ModelType where ModelType: Mappable>(request request: Request<ModelType>, task: NSURLSessionDataTask, responseObject: AnyObject?, completion: RequestCompletion<ModelType>.T)
    {
        guard let responseDictionary = responseObject as? [String: AnyObject]
        else
        {
            let description = "VimeoClient requestSuccess returned invalid/absent dictionary"
            
            assertionFailure(description)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorInvalidDictionary, userInfo: [NSLocalizedDescriptionKey: description])
            
            self.requestFailure(request: request, task: task, error: error, completion: completion)
            
            return
        }
        
        // Serialize the dictionary into a model object
        
        guard let mappingClass = ModelType.mappingClass
        else
        {
            let description = "VimeoClient no mapping class found"
            
            assertionFailure(description)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorNoMappingClass, userInfo: [NSLocalizedDescriptionKey: description])
            
            self.requestFailure(request: request, task: task, error: error, completion: completion)
            
            return
        }
        
        let objectMapper = VIMObjectMapper()
        let modelKeyPath = request.modelKeyPath ?? ModelType.modelKeyPath
        objectMapper.addMappingClass(mappingClass, forKeypath: modelKeyPath ?? "")
        var mappedObject = objectMapper.applyMappingToJSON(responseDictionary)
        
        if let modelKeyPath = modelKeyPath
        {
            mappedObject = (mappedObject as? [String: AnyObject])?[modelKeyPath]
        }
        
        guard let modelObject = mappedObject as? ModelType
        else
        {
            let description = "VimeoClient couldn't map to ModelType"
            
            assertionFailure(description)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorMappingFailed, userInfo: [NSLocalizedDescriptionKey: description])
            
            self.requestFailure(request: request, task: task, error: error, completion: completion)
            
            return
        }
        
        completion(result: .Success(result: modelObject))
    }
    
    private func requestFailure<ModelType where ModelType: Mappable>(request request: Request<ModelType>, task: NSURLSessionDataTask?, error: NSError, completion: RequestCompletion<ModelType>.T)
    {
        completion(result: .Failure(error: error))
    }
}