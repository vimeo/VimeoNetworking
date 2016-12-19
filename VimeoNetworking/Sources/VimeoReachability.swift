//
//  VimeoReachability.swift
//  Vimeo
//
//  Created by King, Gavin on 9/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import UIKit
import AFNetworking

public class VimeoReachability
{
    internal static func beginPostingReachabilityChangeNotifications()
    {
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status) in
            
            Notification.ReachabilityDidChange.post(object: nil)
        }
        
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    public static func reachable() -> Bool
    {
        return AFNetworkReachabilityManager.sharedManager().reachable
    }
    
    public static func reachableViaCellular() -> Bool
    {
        return AFNetworkReachabilityManager.sharedManager().reachableViaWWAN
    }
    
    public static func reachableViaWiFi() -> Bool
    {
        return AFNetworkReachabilityManager.sharedManager().reachableViaWiFi
    }
}
