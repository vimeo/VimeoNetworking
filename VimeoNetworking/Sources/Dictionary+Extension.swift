//
//  Dictionary+Extension.swift
//  Pods
//
//
//

import Foundation

extension Dictionary
{
    public mutating func append(dictionary: Dictionary<Key, Value>)
    {
        for (key, value) in dictionary
        {
            self[key] = value
        }
    }
}
