//
//  UserSubscriptionRenewal.swift
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

/// This class contains information about the renewal dates for the logged in user, including when their subscription will auto-renew (if auto-renewal is enabled)
public class UserSubscriptionRenewal: VIMModelObject {
    /// A string representation of the subscription renewal date to use for UI display purposes.
    /// - remark: The date is displayed in *YYYY-MM-DD* format
    @objc dynamic public private(set) var displayDate: String?
    
    /// A **Date** object representing the subscription renewal date.
    @objc dynamic public private(set) var formattedRenewalDate: Date?
    
    @objc dynamic private var renewalDate: String?
    
    override public func didFinishMapping() {
        self.formatRenewalDate()
    }
    
    private func formatRenewalDate() {
        guard let renewalDate = self.renewalDate else {
            return
        }
        let dateFormatter = VIMModelObject.dateFormatter()
        self.formattedRenewalDate = dateFormatter.date(from: renewalDate)
    }
}
