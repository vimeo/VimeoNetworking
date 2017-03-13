//
//  KeychainStore.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/24/16.
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
import Security

/// `KeychainStore` saves data securely in the Keychain
final class KeychainStore
{
    fileprivate let service: String
    fileprivate let accessGroup: String?
    
    /**
     Create a new `KeychainStore`
     
     - parameter service:     the keychain service which identifies your application
     - parameter accessGroup: the access group the keychain should use for your application
     
     - returns: an initialized `KeychainStore`
     */
    init(service: String, accessGroup: String?)
    {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    /**
     Save data for a given key
     
     - parameter data: data to save
     - parameter key:  identifier for the saved data
     
     - throws: an error if saving failed
     */
    func setData(_ data: NSData, forKey key: String) throws
    {
        try self.deleteDataForKey(key)
        
        var query = self.queryForKey(key)
        
        query[kSecValueData as String] = data as AnyObject?
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock as String as String as AnyObject?
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess
        {
            throw self.errorForStatus(status)
        }
    }
    
    /**
     Load data for a given key
     
     - parameter key: identifier for the saved data
     
     - throws: an error if loading failed
     
     - returns: data, if found
     */
    func dataForKey(_ key: String) throws -> Data?
    {
        var query = self.queryForKey(key)
        
        query[kSecMatchLimit as String] = kSecMatchLimitOne as String as String as AnyObject?
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var attributes: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &attributes)
        let data = attributes as? Data
        
        if status != errSecSuccess && status != errSecItemNotFound
        {
            throw self.errorForStatus(status)
        }
        
        return data
    }
    
    /**
     Delete data for a given key
     
     - parameter key: identifier for the saved data
     
     - throws: an error if the data exists but deleting failed
     */
    func deleteDataForKey(_ key: String) throws
    {
        let query = self.queryForKey(key)
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound
        {
            throw self.errorForStatus(status)
        }
    }
    
    // MARK: - 
    
    fileprivate func queryForKey(_ key: String) -> [String: AnyObject]
    {
        var query: [String: AnyObject] = [:]
        
        query[kSecClass as String] = kSecClassGenericPassword as String as String as AnyObject?
        query[kSecAttrService as String] = self.service as AnyObject?
        query[kSecAttrAccount as String] = key as AnyObject?
        
        if let accessGroup = self.accessGroup
        {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    fileprivate func errorForStatus(_ status: OSStatus) -> NSError
    {
        let errorMessage: String
        
        switch status
        {
        case errSecSuccess:
            errorMessage = "success"
        case errSecUnimplemented:
            errorMessage = "Function or operation not implemented."
        case errSecParam:
            errorMessage = "One or more parameters passed to the function were not valid."
        case errSecAllocate:
            errorMessage = "Failed to allocate memory."
        case errSecNotAvailable:
            errorMessage = "No trust results are available."
        case errSecAuthFailed:
            errorMessage = "Authorization/Authentication failed."
        case errSecDuplicateItem:
            errorMessage = "The item already exists."
        case errSecItemNotFound:
            errorMessage = "The item cannot be found."
        case errSecInteractionNotAllowed:
            errorMessage = "Interaction with the Security Server is not allowed."
        case errSecDecode:
            errorMessage = "Unable to decode the provided data."
        default:
            errorMessage = "undefined error"
        }
        
        let error = NSError(domain: "KeychainErrorDomain", code: Int(status), userInfo: [NSLocalizedDescriptionKey: errorMessage])
        
        return error
    }
}
