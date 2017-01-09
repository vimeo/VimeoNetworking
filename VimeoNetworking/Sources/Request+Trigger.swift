//
//  Request+Trigger.swift
//  Pods
//
//  Created by King, Gavin on 10/24/16.
//
//

extension Request
{
    private static var TriggersURI: String { return "/triggers" }

    /// `Request` that returns a single `VIMTrigger`
    public typealias TriggerRequest = Request<VIMTrigger>
    
    /**
     **(PRIVATE: Vimeo Use Only, will not work for third-party applications)**
     Create a `Request` to register a device for push notifications
     
     - parameter userURI:    the URI of the user
     - parameter parameters: the registration parameters
     
     - returns: a new `Request`
     */
    public static func registerDeviceForPushNotifications(withDeviceToken deviceToken: String, parameters: VimeoClient.RequestParametersDictionary) -> Request
    {
        let uri = self.uri(withDeviceToken: deviceToken)
        
        return Request(method: .PUT, path: uri, parameters: parameters)
    }
    
    /**
     **(PRIVATE: Vimeo Use Only, will not work for third-party applications)**
     Create a `Request` to register a device for push notifications
     
     - parameter userURI:    the URI of the user
     - parameter parameters: the registration parameters
     
     - returns: a new `Request`
     */
    public static func unregisterDeviceForPushNotifications(withDeviceToken deviceToken: String, parameters: VimeoClient.RequestParametersDictionary) -> Request
    {
        let uri = self.uri(withDeviceToken: deviceToken)

        return Request(method: .DELETE, path: uri, parameters: parameters)
    }
    
    /**
     **(PRIVATE: Vimeo Use Only, will not work for third-party applications)**
     Create a `Request` to add a push notification trigger
     
     - parameter parameters: the trigger parameters
     
     - returns: a new `Request`
     */
    public static func addPushNotificationTrigger(withParameters parameters: VimeoClient.RequestParametersDictionary) -> Request
    {
        return Request(method: .POST, path: self.TriggersURI, parameters: parameters)
    }
    
    /**
     **(PRIVATE: Vimeo Use Only, will not work for third-party applications)**
     Create a `Request` to remove a push notification trigger
     
     - parameter parameters: the trigger parameters
     
     - returns: a new `Request`
     */
    public static func removePushNotificationTrigger(withTriggerURI triggerURI: String) -> Request
    {
        return Request(method: .DELETE, path: triggerURI)
    }
    
    /**
     **(PRIVATE: Vimeo Use Only, will not work for third-party applications)**
     Create a `Request` to retrieve the push notification triggers for the device
     
     - parameter parameters: the trigger parameters
     
     - returns: a new `Request`
     */
    public static func pushNotificationTriggers(withDeviceToken deviceToken: String, parameters: VimeoClient.RequestParametersArray) -> Request
    {
        let uri = self.uri(withDeviceToken: deviceToken) + self.TriggersURI

        return Request(method: .PUT, path: uri, parameters: parameters, modelKeyPath: "data")
    }
    
    // MARK: Helpers
    
    private static func uri(withDeviceToken deviceToken: String) -> String
    {
        let deviceTypeIdentifier = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? "iphone" : "ipad"
        
        return "me/devices/" + deviceTypeIdentifier + "/" + deviceToken
    }
}
