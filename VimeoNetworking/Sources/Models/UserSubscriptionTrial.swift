//
//  UserSubscriptionTrial.swift
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

/// Enumeration indicating the user's current trial status
@objc public enum TrialStatus: Int {
    /// the user is not in a trial period
    case none
    
    /// the user is currently in a free trial
    case freeTrial
}

/// This class represents the free trial status for the logged in user, including the status of their trial (if they are in one) and whether or not
/// they have ever had a free trial.
public class UserSubscriptionTrial: VIMModelObject {
    /// The status of a user's free trial.
    ///
    /// This property will have a value of `free_trial` if the user is currently in a trial period, otherwise this field will be nil.
    @objc dynamic private var status: String?
    
    /// Indicates whether the user has ever been in a free trial.
    ///
    /// A value of 0 indicates the user has never had a free trial, a value of 1 indicates that the user has had a free trial at some point.
    @objc dynamic public private(set) var hasBeenInFreeTrial: NSNumber?
    
    /// A property indicating the user's current trial status.
    @objc public var trialStatus: TrialStatus {
        switch self.status {
        case "free_trial":
            return .freeTrial
        default:
            return .none
        }
    }
}
