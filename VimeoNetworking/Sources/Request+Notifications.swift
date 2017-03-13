//
//  Request+Notifications.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/18/17.
//
//

public extension Request
{
    fileprivate static var Path: String { return "/me/notifications/subscriptions" }
    
    /// Retrieve the notification subscriptions.
    ///
    /// - Returns: subscriptionCollection
    public static func getNotificationSubscription() -> Request
    {
        return Request(method: .GET, path: Path, parameters: nil)
    }
    
    /// Create a request that updates the push notification subscriptions
    ///
    /// - Parameter subscription: The subscription dictionary contains the boolean values for each of those: comment, credit, like, reply, follow, video_available that defines what the user is subscripted to.
    /// - Returns: The result of the .PATCH is a SubscriptionCollection
    public static func updateNotificationSubscriptions(_ subscription: VimeoClient.RequestParametersDictionary) -> Request
    {
        return Request(method: .PATCH, path: Path, parameters: subscription as AnyObject?)
    }
}
