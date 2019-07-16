//
//  VIMLiveChatUser.swift
//  VimeoNetworking
//
//  Created by Van Nguyen on 10/10/2017.
//  Copyright (c) Vimeo (https://vimeo.com)
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

/// An object representing the `user` field in a `chat` response.
public class VIMLiveChatUser: VIMModelObject {
    private struct Constants {
        static let PictureResponseKey = "pictures"
    }
    
    /// Returns a string representation of the account type, if available.
    ///
    /// - Note: This property provides an Objective-C interface for the Swift-only property, `accountType`.
    @objc public private(set) var account: String?
    
    /// The user's account type in `AccountType`.
    public var accountType: VIMUserAccountType? {
        guard let accountValue = self.account else {
            return nil
        }
        return VIMUserAccountType(string: accountValue)
    }
    
    /// The user's ID.
    @objc public private(set) var id: NSNumber?
    
    /// Is this user the creator of the live event?
    @objc public private(set) var isCreator: NSNumber?
    
    /// Is this user a Vimeo staff member?
    @objc public private(set) var isStaff: NSNumber?
    
    /// The users' display name.
    @objc public private(set) var name: String?
    
    /// The active picture for this user.
    @objc public private(set) var pictures: VIMPictureCollection?
    
    /// URI of the current user.
    @objc public private(set) var uri: String?
    
    /// Absolute URL of the current user.
    @objc public private(set) var link: String?
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == Constants.PictureResponseKey {
            return VIMPictureCollection.self
        }
        
        return nil
    }
}
