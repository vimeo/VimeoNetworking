//
//  UserSubscription.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 11/30/18.
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

/// This class contains information about the logged in user's subscription status, including information about any free trials the user may be in and information
/// about the user's renewal date.
public class UserSubscription: VIMModelObject {
    /// Object containing information about the logged in user's renewal date
    @objc dynamic public private(set) var renewal: UserSubscriptionRenewal?
    
    /// Object containing information about the logged in user's free trial status
    @objc dynamic public private(set) var trial: UserSubscriptionTrial?
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == "renewal" {
            return UserSubscriptionRenewal.self
        }
        if key == "trial" {
            return UserSubscriptionTrial.self
        }
        
        return nil
    }
}
