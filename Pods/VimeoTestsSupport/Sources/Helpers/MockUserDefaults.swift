//
//  MockUserDefaults.swift
//  VimeoTestsSupport
//
//  Created by Rogerio de Paula Assis on 7/3/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// Mock user defaults to be used with unit tests.
///
/// Every time this class is instantiated, any existing
/// user defaults bundle with a matching name (`MockUserDefaults`) 
/// will get deleted.
class MockUserDefaults : UserDefaults {
    
    enum Constants {
        static let MockUserDefaults = "MockUserDefaults"
    }
    
    convenience init() {
        self.init(suiteName: Constants.MockUserDefaults)!
    }
    
    private override init?(suiteName suitename: String?) {
        guard let suitename = suitename else { return nil }
        UserDefaults().removePersistentDomain(forName: suitename)
        super.init(suiteName: suitename)
    }
    
}
