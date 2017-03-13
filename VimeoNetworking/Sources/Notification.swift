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
open class ObservationToken
{
    fileprivate let observer: NSObjectProtocol
    
    fileprivate init(observer: NSObjectProtocol)
    {
        self.observer = observer
    }
    
    /**
     Ends the block observation associated with this token
     */
    open func stopObserving()
    {
        Notification.removeObserver(self.observer)
    }
    
    deinit
    {
        self.stopObserving()
    }
}

public enum UserInfoKey: NSString
{
    case previousAccount
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
    
    fileprivate static let NotificationCenter = Foundation.NotificationCenter.default
    
    // MARK: -
    
    /**
     Broadcast a global notification
     
     - parameter object: an optional object to pass to observers of this `Notification`
     */
    public func post(object: AnyObject?, userInfo: [AnyHashable: Any]? = nil)
    {
        DispatchQueue.main.async
        {
            type(of: self).NotificationCenter.post(name: Foundation.Notification.Name(rawValue: self.rawValue), object: object, userInfo: userInfo)
        }
    }
    
    /**
     Observe a global notification using a provided method
     
     - parameter target:   the object on which to call the `selector` method
     - parameter selector: method to call when the notification is broadcast
     */
    public func observe(_ target: AnyObject, selector: Selector)
    {
        type(of: self).NotificationCenter.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    /**
     Observe a global notification anonymously by executing a provided handler on broadcast.
     
     - returns: an ObservationToken, which must be strongly stored in an appropriate context for as long as observation is relevant.
     */
    
    public func observe(_ observationHandler: @escaping (Foundation.Notification) -> Void) -> ObservationToken
    {
        let observer = type(of: self).NotificationCenter.addObserver(forName: NSNotification.Name(rawValue: self.rawValue), object: nil, queue: OperationQueue.main, using: observationHandler)
        
        return ObservationToken(observer: observer)
    }
    
    /**
     Removes a target from this notification observation
     
     - parameter target: the target to remove
     */
    public func removeObserver(_ target: AnyObject)
    {
        type(of: self).NotificationCenter.removeObserver(target, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    
    /**
     Removes a target from all notification observation
     
     - parameter target: the target to remove
     */
    public static func removeObserver(_ target: AnyObject)
    {
        self.NotificationCenter.removeObserver(target)
    }
}
