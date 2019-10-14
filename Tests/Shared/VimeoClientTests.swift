//
//  VimeoClientTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Guhit, Fiel on 1/17/17.
//  Copyright © 2017 Vimeo. All rights reserved.
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

import XCTest
@testable import VimeoNetworking

class VimeoClientTests: XCTestCase {
    
    func testInitialCurrentAccountNotificationUserInfo() {
        let expectation = self.expectation(description: "Wait for initial account notification")
        let token: ObservationToken? = NetworkingNotification.authenticatedAccountDidChange.observe() { (notification: Notification) in
            XCTAssert(notification.object != nil)
            XCTAssert(notification.userInfo != nil)
            XCTAssert(notification.userInfo![UserInfoKey.previousAccount.rawValue] as? VIMAccount == nil)
            
            expectation.fulfill()
        }
        
        XCTAssert(token != nil)

        let client = makeVimeoClient()
        client.notifyObserversAccountChanged(forAccount: VIMAccount(), previousAccount: nil)
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
        NetworkingNotification.authenticatedAccountDidChange.removeObserver(target: self)
    }
    
    func testSubsequentAccountNotificationUserInfo() {
        let firstAccount = VIMAccount()
        let secondAccount = VIMAccount()
        
        let expectation = self.expectation(description: "Wait for subsequent account notification")
        let token: ObservationToken? = NetworkingNotification.authenticatedAccountDidChange.observe() { (notification: Notification) in
            XCTAssert(notification.userInfo != nil)
            
            if let previousAccount = notification.userInfo![UserInfoKey.previousAccount.rawValue] as? VIMAccount {
                XCTAssert(previousAccount == firstAccount)
                expectation.fulfill()
            }
        }
        
        XCTAssert(token != nil)

        let client = makeVimeoClient()
        client.notifyObserversAccountChanged(forAccount: secondAccount, previousAccount: firstAccount)
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
        NetworkingNotification.authenticatedAccountDidChange.removeObserver(target: self)
    }
}
