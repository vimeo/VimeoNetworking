//
//  VimeoReachability.swift
//  Vimeo
//
//  Created by King, Gavin on 9/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

public class VimeoReachability {
    private static var LastKnownReachabilityStatus = AFNetworkReachabilityStatus.unknown
    
    internal static func beginPostingReachabilityChangeNotifications() {
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in

            if LastKnownReachabilityStatus != status {
                LastKnownReachabilityStatus = status
                NetworkingNotification.reachabilityDidChange.post(object: nil)
            }
        }
        
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    public static func reachable() -> Bool {
        return AFNetworkReachabilityManager.shared().isReachable
    }
    
    public static func reachableViaCellular() -> Bool {
        return AFNetworkReachabilityManager.shared().isReachableViaWWAN
    }
    
    public static func reachableViaWiFi() -> Bool {
        return AFNetworkReachabilityManager.shared().isReachableViaWiFi
    }
}
