//
//  SubscriptionCollection.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/20/17.
//
//

/// Represents all the subscriptions with extra informations
public class SubscriptionCollection: VIMModelObject
{
    // MARK: - Properties

    /// Represents the uri
    @objc dynamic public private(set) var uri: String?
    
    /// Represents the subscription
    @objc dynamic public private(set) var subscription: Subscription?
    
    /// Represents the migration that indicates whether the user has migrated from the old system `VIMTrigger` to new new system `Localytics`.
    @objc dynamic public private(set) var migrated: NSNumber?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> Any
    {
        return ["subscriptions": "subscription"]
    }
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass!
    {
        if key == "subscriptions"
        {
            return Subscription.self
        }
        
        return nil
    }
}
