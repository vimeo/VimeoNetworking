//
//  PayloadFactory.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Rogerio de Paula Assis on 6/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// Payload factory helper to load JSON payloads off disk
/// To add a factory create a new enum case and add the corresponding
/// JSON file to the test target. Note that the factory expects the
/// filename of the JSON file to match the raw representable string
/// value of the enum case
public enum PayloadFactory: String {
    case category
}

extension PayloadFactory {
    public var json: Any {
        guard
            let jsonFile = Bundle.testBundle.url(forResource: self.rawValue, withExtension: "json"),
            let data = try? Data(contentsOf: jsonFile),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return []
        }
        return json
    }
}
