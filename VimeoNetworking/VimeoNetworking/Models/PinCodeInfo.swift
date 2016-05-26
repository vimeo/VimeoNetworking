//
//  PinCodeInfo.swift
//  VimeoNetworking
//
//  Created by Huebner, Rob on 5/9/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

public class PinCodeInfo: VIMModelObject
{
    dynamic public var deviceCode: String?
    dynamic public var userCode: String?
    dynamic public var authorizeLink: String?
    dynamic public var activateLink: String?
    
    // TODO: These are non-optional Ints with -1 invalid sentinel values because
    // an optional Int can't be represented in Objective-C and can't be marked
    // dynamic, which leads to it not getting parsed by VIMObjectMapper [RH]
    dynamic public var expiresIn: Int = -1
    dynamic public var interval: Int = -1
}