//
//  self.swift
//  Pods
//
//  Created by Lim, Jennifer on 2/8/17.
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

/// Represents all the notifications that the user is Subscribed to.
public class Subscription: VIMModelObject {
    // MARK: - Properties
    
    /// Represents wether the user is subscribed to the `comment` notification.
    @objc dynamic public private(set) var comment: NSNumber?
    
    /// Represents wether the user is subscribed to the `credit` notification.
    @objc dynamic public private(set) var credit: NSNumber?
    
    /// Represents wether the user is subscribed to the `like` notification.
    @objc dynamic public private(set) var like: NSNumber?
    
    /// Represents wether the user is subscribed to the `mention` notification.
    @objc dynamic public private(set) var mention: NSNumber?
    
    /// Represents wether the user is subscribed to the `reply` notification.
    @objc dynamic public private(set) var reply: NSNumber?
    
    /// Represents wether the user is subscribed to the `follow` notification.
    @objc dynamic public private(set) var follow: NSNumber?
    
    /// Represents wether the user is subscribed to the `video available` notification.
    @objc dynamic public private(set) var videoAvailable: NSNumber?
    
    /// Represents wether the user is subscribed to the `vod pre order available` notification.
    @objc dynamic public private(set) var vodPreorderAvailable: NSNumber?
    
    /// Represents wether the user is subscribed to the `vod rental expiration warning` notification.
    @objc dynamic public private(set) var vodRentalExpirationWarning: NSNumber?
    
    /// Represents wether the user is subscribed to the `account expiration warning` notification.
    @objc dynamic public private(set) var accountExpirationWarning: NSNumber?
    
    /// Represents wether the user is subscribed to the `share` notification.
    @objc dynamic public private(set) var share: NSNumber?
    
    /// Represents wether the is subscribed to the `New video available from followed user` notification.
    @objc dynamic public private(set) var followedUserVideoAvailable: NSNumber?
    
    /// Represents the Subscription object as a Dictionary
    @objc public var toDictionary: [String: Any] {
        let dictionary: [String: Any] = ["comment": self.comment ?? false,
                                              "credit": self.credit ?? false,
                                              "like": self.like ?? false,
                                              "mention": self.mention ?? false,
                                              "reply": self.reply ?? false,
                                              "follow": self.follow ?? false,
                                              "vod_preorder_available": self.vodPreorderAvailable ?? false,
                                              "video_available": self.videoAvailable ?? false,
                                              "share": self.share ?? false,
                                              "followed_user_video_available": self.followedUserVideoAvailable ?? false]
        
        return dictionary
    }
    
    // MARK: - VIMMappable
    
    override public func getObjectMapping() -> Any {
        return [
            "video_available": "videoAvailable",
            "vod_preorder_available": "vodPreorderAvailable",
            "vod_rental_expiration_warning": "vodRentalExpirationWarning",
            "account_expiration_warning": "accountExpirationWarning",
            "followed_user_video_available": "followedUserVideoAvailable"]
    }
    
    // MARK: - Helpers
    
    /// Helper method that determine whether a user has all the subscription settings turned off.
    ///
    /// - Returns: A boolean that indicates whether the user has all the settings for push notifications disabled.
    @objc public func areSubscriptionsDisabled() -> Bool {
        return (self.comment == false &&
                self.credit == false &&
                self.like == false &&
                self.mention == false &&
                self.reply == false &&
                self.follow == false &&
                self.vodPreorderAvailable == false &&
                self.videoAvailable == false &&
                self.share == false &&
                self.followedUserVideoAvailable == false)
    }
}
