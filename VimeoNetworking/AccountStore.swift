//
//  AccountStore.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/24/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

final class AccountStore
{
    enum AccountType: String
    {
        case ClientCredentials
        case User
    }
    
    // MARK: - 
    
    private let dataStore: SecureDataStore = ArchiveStore() // TODO: Replace this with keychain store [RH] (3/24/16)
    
    // MARK: -
    
    func saveAccount(account: VIMAccountNew, type: AccountType) throws
    {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(account)
        archiver.finishEncoding()
        
        try self.dataStore.setData(data, forKey: type.rawValue)
    }
    
    func loadAccount(type: AccountType) throws -> VIMAccountNew?
    {
        guard let data = try self.dataStore.dataForKey(type.rawValue)
        else
        {
            return nil
        }
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        let account = unarchiver.decodeObject() as? VIMAccountNew
        
        return account
    }
}