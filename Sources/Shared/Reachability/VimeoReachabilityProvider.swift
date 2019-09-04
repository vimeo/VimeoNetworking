//
//  VimeoReachabilityProvider.swift
//  Vimeo
//
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

public enum VimeoReachabilityProvider {
    
    /// The shared reachability manager used to listen to reachability changes
    ///
    /// Upon initialization, this reachability manager immediately starts listening
    /// for reachability changes and broadcasts them via system notification to
    /// interested subscribers.
    public static let reachabilityManager: ReachabilityManaging? = {
        let manager = NetworkReachabilityManager.default
        manager?.startListening { _ in
            NetworkingNotification.reachabilityDidChange.post(object: nil)
        }
        return manager
    }()
}
