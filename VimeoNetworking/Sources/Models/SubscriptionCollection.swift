//
//  SubscriptionCollection.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/20/17.
//
//

/// Represents all the subscriptions with extra informations
open class SubscriptionCollection: VIMModelObject
{
    // MARK: - Properties

    /// Represents the uri
    open var uri: String?
    
    /// Represents the modified time
    open var modifiedTime: Date?
    
    /// Represents the subscription
    open var subscription: Subscription?
    
    // MARK: - VIMMappable
    
    open override func getObjectMapping() -> Any
    {
        return ["modified_time": "modifiedTime",
                "subscriptions": "subscription"]
    }
    
    open override func getClassForObjectKey(_ key: String!) -> AnyClass!
    {
        if key == "subscriptions"
        {
            return Subscription.self
        }
        
        return nil
    }
}
