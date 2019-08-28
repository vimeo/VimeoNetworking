//
//  VimeoReachabilityMonitor.swift
//  Vimeo
//
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

/// The protocol indicating the capabilities of a `ReachabilityMonitoringType` type
public protocol ReachabilityMonitoringType {
    func beginMonitoringReachabilityChanges()
    func stopMonitoringReachabilityChanges()
    var isReachable: Bool { get }
    var isReachableOnCellular: Bool { get }
    var isReachableOnEthernetOrWiFi: Bool { get }
}

/// The `VimeoReachabilityMonitor` class listens for reachability changes
/// via its `NetworkReachabilityManager` and calls the provided `onReachabilityChange` closure
/// when a change is detected.
public class VimeoReachabilityMonitor: ReachabilityMonitoringType {
    
    /// The last known reachability status value
    private var lastKnownReachabilityStatus: Status = .unknown
    
    /// The reachability manager used to listen to reachability changes
    private let reachabilityManager: NetworkReachabilityManager?
    
    /// The closure to be called when a reachability change is detected
    private let onReachabilityChange: ((Status) -> Void)?
    
    /// A typealias to NetworkReachabilityManager.Status
    public typealias Status = NetworkReachabilityManager.Status
            
    public init(
        reachabilityManager: NetworkReachabilityManager? = nil,
        onReachabilityChange: ((Status) -> Void)? = nil
    ) {
        self.reachabilityManager = reachabilityManager
        self.onReachabilityChange = onReachabilityChange
    }
    
    /// Begins listening to reachability updates via the reachability manager,
    /// calling the `onReachabilityChange` closure whenever a change is detected.
    public func beginMonitoringReachabilityChanges() {
        
        stopMonitoringReachabilityChanges()
        
        self.reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard status != self?.lastKnownReachabilityStatus else { return }
            self?.lastKnownReachabilityStatus = status
            self?.onReachabilityChange?(status)
        })
    }
    
    /// Stops listening to reachability updates via the reachability manager
    public func stopMonitoringReachabilityChanges() {
        self.reachabilityManager?.stopListening()
    }
    
    /// Indicates whether the network is currently reachable via any interface.
    public var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    /// Indicates whether the network is currently reachable over the cellular interface.
    public var isReachableOnCellular: Bool {
        return reachabilityManager?.isReachableOnCellular ?? false
    }
    
    /// Indicates whether network is currently reachable over Ethernet or WiFi interface.
    public var isReachableOnEthernetOrWiFi: Bool {
        return reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    }
}

// MARK: Convenience - default VimeoReachabilityMonitor
extension VimeoReachabilityMonitor {
    
    /// The shared instance of `VimeoReachabilityMonitor` configured with default parameters
    /// Note the default behavior of the `onReachabilityChange` closure is to post a
    /// `NetworkingNotification.reachabilityDidChange` notification that interested parties
    /// can subscribe to.
    public static let `default` = VimeoReachabilityMonitor(
        reachabilityManager: .default,
        onReachabilityChange: { _ in NetworkingNotification.reachabilityDidChange.post(object: nil) }
    )
}
