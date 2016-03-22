//
//  Mappable.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

protocol Mappable
{
    static var mappingClass: AnyClass? { get }
    
    static var modelKeyPath: String? { get }
}

extension VIMModelObject: Mappable
{
    static var mappingClass: AnyClass?
    {
        return self
    }
    
    static var modelKeyPath: String?
    {
        return nil
    }
}

extension Array: Mappable
{
    // The default implementation for all arrays will return no mapping class or model key path
    // Only if Element itself is a VIMModelObject will the values be returned
    // This is because we can't restrict the generic type if we're
    // extending a type with generics to conform to a protocol [RH]
    
    static var mappingClass: AnyClass?
    {
        if Element.self is VIMModelObject.Type
        {
            return (Element.self as! AnyClass)
        }
        
        return nil
    }
    
    static var modelKeyPath: String?
    {
        if Element.self is VIMModelObject.Type
        {
            return "data"
        }
        
        return nil
    }
}
