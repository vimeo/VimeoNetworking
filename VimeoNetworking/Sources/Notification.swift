//
//  Notification.swift
//  VimeoNetworking
//
//  Created by Huebner, Rob on 4/25/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

import Foundation

/// `ObservationToken` manages the lifecycle of a block observer.  Note: on deinit, the token cancels its own observation, so it must be stored strongly if the associated block observation is to continue.
public class ObservationToken
{
    private let observer: NSObjectProtocol
    
    private init(observer: NSObjectProtocol)
    {
        self.observer = observer
    }
    
    /**
     Ends the block observation associated with this token
     */
    public func stopObserving()
    {
        Notification.removeObserver(self.observer)
    }
    
    deinit
    {
        self.stopObserving()
    }
}

/// `Notification` declares a number of global events that can be broadcast by the networking library and observed by clients.
public enum Notification: String
{
        /// Sent when any response returns a 503 Service Unavailable error
    case ClientDidReceiveServiceUnavailableError
    
        /// Sent when any response returns an invalid token error
    case ClientDidReceiveInvalidTokenError
    
        /// **(Not yet implemented)** Sent when the online/offline status of the current device changes
    case ReachabilityDidChange
    
        /// Sent when the stored authenticated account is changed
    case AuthenticatedAccountDidChange
    
        /// **(Not yet implemented)** Sent when the user stored with the authenticated account is refreshed
    case AuthenticatedAccountDidRefresh
    
        /// Sent when any object has been updated with new metadata and UI should be updated
    case ObjectDidUpdate
    
    // MARK: -
    
    private static let NotificationCenter = NSNotificationCenter.defaultCenter()
    
    // MARK: -
    
    /**
     Broadcast a global notification
     
     - parameter object: an optional object to pass to observers of this `Notification`
     */
    public func post(object object: AnyObject?)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.dynamicType.NotificationCenter.postNotificationName(self.rawValue, object: object)
        }
    }
    
    /**
     Observe a global notification using a provided method
     
     - parameter target:   the object on which to call the `selector` method
     - parameter selector: method to call when the notification is broadcast
     */
    public func observe(target: AnyObject, selector: Selector)
    {
        self.dynamicType.NotificationCenter.addObserver(target, selector: selector, name: self.rawValue, object: nil)
    }
    
    /**
     Observe a global notification anonymously by executing a provided handler on broadcast.
     
     - returns: an ObservationToken, which must be strongly stored in an appropriate context for as long as observation is relevant.
     */
    @warn_unused_result(message = "Token must be strongly stored, observation ceases on token deallocation")
    public func observe(observationHandler: (NSNotification) -> Void) -> ObservationToken
    {
        let observer = self.dynamicType.NotificationCenter.addObserverForName(self.rawValue, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: observationHandler)
        
        return ObservationToken(observer: observer)
    }
    
    /**
     Removes a target from this notification observation
     
     - parameter target: the target to remove
     */
    public func removeObserver(target: AnyObject)
    {
        self.dynamicType.NotificationCenter.removeObserver(target, name: self.rawValue, object: nil)
    }
    
    
    /**
     Removes a target from all notification observation
     
     - parameter target: the target to remove
     */
    public static func removeObserver(target: AnyObject)
    {
        self.NotificationCenter.removeObserver(target)
    }
}
