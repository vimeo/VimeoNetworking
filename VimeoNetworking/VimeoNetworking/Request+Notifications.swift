//
//  Request+Notifications.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/18/17.
//
//

public extension Request
{
    private static var Path: String { return "/me/notifications/subscriptions" }
    
    /// Create a request that updates the push notification subscriptions
    ///
    /// - Parameter subscription: The subscription object contains the boolean values for each of those: comment, credit, like, reply, follow, video_available that defines what the user is subscripted to.
    /// - Returns: The result of the .PATCH is a SubscriptionCollection
    public static func updateNotificationSubscriptions(subscription: Subscription) -> Request
    {
        let parameters = [
                        "comment": subscription.comment,
                        "credit": subscription.credit,
                        "like": subscription.like,
                        "reply": subscription.reply,
                        "follow": subscription.follow,
                        "video_available": subscription.videoAvailable]
        
        return Request(method: .PATCH, path: Path, parameters: parameters)
    }
}
