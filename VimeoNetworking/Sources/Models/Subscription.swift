//
//  self.swift
//  Pods
//
//  Created by Lim, Jennifer on 2/8/17.
//
//

/// Represents all the notifications that the user is Subscribed to.
public class Subscription: VIMModelObject
{
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
    public var toDictionary: [AnyHashable: Any]
    {
        let dictionary: [AnyHashable: Any] = ["comment": self.comment ?? false,
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
    
    override public func getObjectMapping() -> Any
    {
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
    public func areSubscriptionsDisabled() -> Bool
    {
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
