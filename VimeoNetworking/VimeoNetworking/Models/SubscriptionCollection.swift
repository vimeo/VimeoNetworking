//
//  SubscriptionCollection.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/20/17.
//
//

import Foundation

public class SubscriptionCollection: VIMModelObject
{
    // MARK: - Properties
    
    dynamic public var uri: String?
    dynamic public var modifiedTime: NSDate?
    dynamic public var subscriptions: Subscription?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> AnyObject!
    {
        return ["modified_time": "modifiedTime"]
    }
    
    public override func getClassForObjectKey(key: String!) -> AnyClass!
    {
        if key == "subscriptions"
        {
            return Subscription.self
        }
        
        return nil
    }
}

public class Subscription: VIMModelObject
{
    // MARK: - Properties
    
    dynamic public var comment: Bool = false
    dynamic public var credit: Bool = false
    dynamic public var like: Bool = false
    dynamic public var mention: Bool = false
    dynamic public var reply: Bool = false
    dynamic public var follow: Bool = false
    dynamic public var videoAvailable: Bool = false
    dynamic public var vodPreorderAvailable: Bool = false
    dynamic public var vodRentalExpirationWarning: Bool = false
    dynamic public var accountExpirationWarning: Bool = false
    dynamic public var share: Bool = false
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> AnyObject!
    {
        return [
                "video_available": "videoAvailable",
                "vod_preorder_available": "vodPreorderAvailable",
                "vod_rental_expiration_warning": "vodRentalExpirationWarning",
                "account_expiration_warning": "accountExpirationWarning"]
    }
}
