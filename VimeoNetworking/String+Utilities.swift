//
//  String+Utilities.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/29/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

extension String
{
    func parametersFromQueryString() -> [String: String]?
    {
        var parameters: [String: String] = [:]
        
        let scanner = NSScanner(string: self)
        while !scanner.atEnd
        {
            var name: NSString?
            let equals = "="
            scanner.scanUpToString(equals, intoString: &name)
            scanner.scanString(equals, intoString: nil)
            
            var value: NSString?
            let ampersand = "&"
            scanner.scanUpToString(ampersand, intoString: &value)
            scanner.scanString(ampersand, intoString: nil)
            
            if let name = name?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
                let value = value?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            {
                parameters[name] = value
            }
        }
        
        return parameters.count > 0 ? parameters : nil
    }
}