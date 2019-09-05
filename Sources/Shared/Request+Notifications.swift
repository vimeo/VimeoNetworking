//
//  Request+Notifications.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/18/17.
//
//

public extension Request {
    private static var Path: String { return "/me/notifications/subscriptions" }

    private typealias ParameterDictionary = [String: Any]

    private static var SubscriptionsPathComponent: String { return "/subscriptions" }

    // MARK: - Notifications API

    /// Handle Mutliple Devices: Create a request that set the device as active to receive Notifications. This request should be made only once: When the app first launch. The purpose of the request is to notify the server side, this device should receive push notifications.
    ///
    /// - Parameter deviceToken: The token that is stored in `SMKNotificationsCenter`
    static func setDeviceAsActiveToReceiveNotifications(forNotificationsURI notificationsURI: String, deviceToken: String) -> Request {
        let subscriptionsURI = Request.subscriptionsURI(forNotificationsURI: notificationsURI, deviceToken: deviceToken)

        return Request(method: .put, path: subscriptionsURI, parameters: nil)
    }

    /// Retrieve the notification subscriptions.
    ///
    /// - Returns: subscriptionCollection
    static func getNotificationSubscriptionRequest(forNotificationsURI notificationsURI: String, deviceToken: String) -> Request {
        let subscriptionsURI = Request.subscriptionsURI(forNotificationsURI: notificationsURI, deviceToken: deviceToken)

        return Request(method: .get, path: subscriptionsURI, parameters: nil)
    }

    /// Create a request that updates the push notification subscriptions
    ///
    /// - Parameter subscription: The subscription dictionary contains the boolean values for each of those: comment, credit, like, reply, follow, video_available that defines what the user is subscripted to.
    /// - Returns: The result of the .PATCH is a SubscriptionCollection
    static func updateNotificationSubscriptionsRequest(withSubscription subscription: VimeoClient.RequestParametersDictionary, notificationsURI: String, deviceToken: String) -> Request {
        let subscriptionsURI = Request.subscriptionsURI(forNotificationsURI: notificationsURI, deviceToken: deviceToken)

        return Request(method: .patch, path: subscriptionsURI, parameters: subscription)
    }

    // MARK: - Helper

    private static func subscriptionsURI(forNotificationsURI notificationsURI: String, deviceToken: String) -> String {
        return "\(notificationsURI)/\(deviceToken)\(SubscriptionsPathComponent)"
    }
    
    static func markNotificationAsNotNewRequest(forNotification notification: VIMNotification, notificationsURI: String) -> Request {
        guard let latestURI = notification.uri else {
            return Request(method: .patch, path: notificationsURI, parameters: nil)
        }

        let parameters = [
            "latest_notification_uri" : latestURI,
            "new" : "false"
        ]

        return Request(method: .patch, path: notificationsURI, parameters: parameters)
    }

    static func markNotificationsAsSeenRequest(forNotifications notifications: [VIMNotification], notificationsURI: String) -> Request {
        var parameters: [ParameterDictionary] = []
        let _ = notifications.map { (notification: VIMNotification) -> Void in
            if let uri = notification.uri {
                parameters.append([
                    "seen": "true",
                    "uri": uri]
                )
            }
        }

        return Request(method: .patch, path: notificationsURI, parameters: parameters)
    }
}
