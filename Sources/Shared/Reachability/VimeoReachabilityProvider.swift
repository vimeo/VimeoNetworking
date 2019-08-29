//
//  VimeoReachabilityProvider.swift
//  Vimeo
//
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

public enum VimeoReachabilityProvider {
    /// The reachability manager used to listen to reachability changes
    public static let reachabilityManager: ReachabilityManagingType? = {
        let manager = NetworkReachabilityManager.default
        manager?.startListening(onUpdatePerforming: { _ in
            NetworkingNotification.reachabilityDidChange.post(object: nil)
        })
        return manager
    }()
}
