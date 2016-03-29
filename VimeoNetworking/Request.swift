//
//  Request.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

struct Request<ModelType where ModelType: Mappable>
{
    init(method: VimeoClient.Method = .GET, path: String, parameters: VimeoClient.RequestParameters? = nil, modelKeyPath: String? = nil)
    {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.modelKeyPath = modelKeyPath
    }
    
    let method: VimeoClient.Method
    
    let path: String
    
    let parameters: VimeoClient.RequestParameters?
    
    let modelKeyPath: String?
}