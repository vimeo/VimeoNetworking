//
//  UserMembership.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 11/29/18.
//  Copyright (c) 2014-2018 Vimeo (https://vimeo.com)
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

/// Class containing details about a user's membership, including what badge should be displayed for them, their subscription status, and account information.
public class UserMembership: VIMModelObject {
    
    /// Object describing the visual badge to display to indicate the user's account type.
    @objc dynamic public var badge: VIMUserBadge?
    
    /// A non-localized string representation of the user's account type that can be used for display purposes.
    @objc dynamic public var display: String?

    /// An object containing information about the user's subscription status.  This information will only be available for the current logged in user.
    /// - remark: This information is only available for the current logged in user.
    @objc dynamic public var subscription: UserSubscription?
    
    /// A string representation of the user's account type.  This value should not be used for display purposes, use the **display** property instead.
    /// - remark: This property replaces the VIMUser.account property.
    @objc dynamic public var type: String?
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == "badge" {
            return VIMUserBadge.self
        }
        if key == "subscription" {
            return UserSubscription.self
        }
        
        return nil
    }
}
