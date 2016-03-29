//
//  KeychainStore.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/24/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

protocol SecureDataStore
{
    func setData(data: NSData, forKey key: String) throws
    
    func dataForKey(key: String) throws -> NSData?
    
    func deleteDataForKey(key: String) throws
}

final class KeychainStore: SecureDataStore
{
    // TODO:  [RH] (3/24/16)
    
    init(service: String, accessGroup: String)
    {
        // TODO:  [RH] (3/24/16)
    }
    
    func setData(data: NSData, forKey key: String) throws
    {
        // TODO:  [RH] (3/24/16)
    }
    
    func dataForKey(key: String) throws -> NSData?
    {
        // TODO:  [RH] (3/24/16)
        
        return nil
    }
    
    func deleteDataForKey(key: String) throws
    {
        // TODO:  [RH] (3/24/16)
    }
}

/// Using this rly dumb dummy store until we finish keychain support [RH]

final class ArchiveStore: SecureDataStore
{
    private let fileManager = NSFileManager.defaultManager()
    
    func setData(data: NSData, forKey key: String) throws
    {
        let fileURL = self.fileURLForKey(key: key)
        
        guard let filePath = fileURL.path
        else
        {
            let error = NSError(domain: "ArchiveStoreDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "no path"])
            throw error
        }
        
        if let documentsDirectoryURL = self.documentsDirectoryURL()
        {
            try self.fileManager.createDirectoryAtURL(documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        if self.fileManager.fileExistsAtPath(filePath)
        {
            try self.fileManager.removeItemAtPath(filePath)
        }
        
        let success = self.fileManager.createFileAtPath(filePath, contents: data, attributes: nil)
        
        if !success
        {
            let error = NSError(domain: "ArchiveStoreDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "create file failed"])
            throw error
        }
    }
    
    func dataForKey(key: String) throws -> NSData?
    {
        let data = NSData(contentsOfURL: self.fileURLForKey(key: key))
        
        return data
    }
    
    func deleteDataForKey(key: String) throws
    {
        try self.fileManager.removeItemAtURL(self.fileURLForKey(key: key))
    }
    
    private func documentsDirectoryURL() -> NSURL?
    {
        if let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        {
            return NSURL(fileURLWithPath: directory)
        }
        
        return nil
    }
    
    private func fileURLForKey(key key: String) -> NSURL
    {
        guard let directoryURL = self.documentsDirectoryURL()
        else
        {
            fatalError("no documents directories found")
        }
        
        let fileURL = directoryURL.URLByAppendingPathComponent("dontlookatthis-\(key).plist")
        
        return fileURL
    }
}