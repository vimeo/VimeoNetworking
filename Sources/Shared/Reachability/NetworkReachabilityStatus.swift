//
//  NetworkReachabilityStatus.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 8/28/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import SystemConfiguration

/// Defines the status of network reachability.
public enum NetworkReachabilityStatus {
    /// It is unknown whether the network is reachable.
    case unknown
    /// The network is not reachable.
    case notReachable
    /// The network is reachable on the associated `ConnectionType`.
    case reachable(ConnectionType)
    
    init(_ flags: SCNetworkReachabilityFlags) {
        guard flags.isActuallyReachable else { self = .notReachable; return }
        
        var networkStatus: NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)
        
        if flags.isCellular { networkStatus = .reachable(.cellular) }
        
        self = networkStatus
    }
    
    /// Defines the various connection types detected by reachability flags.
    public enum ConnectionType {
        /// The connection type is either over Ethernet or WiFi.
        case ethernetOrWiFi
        /// The connection type is a cellular connection.
        case cellular
    }
}

// MARK: - Convenience conformance and properties

extension NetworkReachabilityStatus: Equatable { }

private extension SCNetworkReachabilityFlags {
    var isReachable: Bool {
        return contains(.reachable)
    }
    
    var isConnectionRequired: Bool {
        return contains(.connectionRequired)
    }
    
    var canConnectAutomatically: Bool {
        return contains(.connectionOnDemand) || contains(.connectionOnTraffic)
    }
    
    var canConnectWithoutUserInteraction: Bool {
        return canConnectAutomatically && !contains(.interventionRequired)
    }
    
    var isActuallyReachable: Bool {
        return isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction)
    }
    
    var isCellular: Bool {
        #if os(iOS) || os(tvOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
}
