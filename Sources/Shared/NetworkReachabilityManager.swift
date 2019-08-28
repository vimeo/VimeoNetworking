//
//  NetworkReachabilityManager.swift
//  VimeoNetworking
//
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import SystemConfiguration

/// Original source from the link below, with modifications.
/// https://raw.githubusercontent.com/Alamofire/Alamofire/master/Source/NetworkReachabilityManager.swift
///

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

/// The `NetworkReachabilityManager` class listens for reachability changes of
/// hosts and addresses for both cellular and WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed,
/// or to retry network requests when a connection is established.
/// Reachability should *not* be used to prevent a user from initiating a network request,
/// as it's possible that an initial request may be required to establish reachability.
internal class NetworkReachabilityManager {
            
    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    typealias Listener = (NetworkReachabilityStatus) -> Void
    
    /// Default `NetworkReachabilityManager` for the zero address and a `listenerQueue` of `.main`.
    static let `default` = NetworkReachabilityManager()
    
    // MARK: - Properties
    
    /// Whether the network is currently reachable.
    var isReachable: Bool { return isReachableOnCellular || isReachableOnEthernetOrWiFi }
    
    /// Whether the network is currently reachable over the cellular interface.
    ///
    /// - Note: Using this property to decide whether to make a high or low bandwidth request is not recommended.
    ///         Instead, set the `allowsCellularAccess` on any `URLRequest`s being issued.
    ///
    var isReachableOnCellular: Bool { return status == .reachable(.cellular) }
    
    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    var isReachableOnEthernetOrWiFi: Bool { return status == .reachable(.ethernetOrWiFi) }
        
    /// Flags of the current reachability type, if any.
    var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        
        return (SCNetworkReachabilityGetFlags(reachability, &flags)) ? flags : nil
    }
    
    /// The current network reachability status.
    var status: NetworkReachabilityStatus {
        return flags.map(NetworkReachabilityStatus.init) ?? .unknown
    }
    
    /// `DispatchQueue` on which reachability will update.
    private let reachabilityQueue = DispatchQueue(label: "org.alamofire.reachabilityQueue")

    /// A closure executed when the network reachability status changes.
    private var listener: Listener?
    
    /// `DispatchQueue` on which listeners will be called.
    private var listenerQueue: DispatchQueue?
    
    /// `SCNetworkReachability` instance providing notifications.
    private let reachability: SCNetworkReachability
    
    // MARK: - Initialization
    
    /// Creates an instance with the specified host.
    ///
    /// - Note: The `host` value must *not* contain a scheme, just the hostname.
    ///
    /// - Parameters:
    ///   - host:          Host used to evaluate network reachability. Must *not* include the scheme (e.g. `https`).
    convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        
        self.init(reachability: reachability)
    }
    
    /// Creates an instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    convenience init?() {
        var zero = sockaddr()
        zero.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zero.sa_family = sa_family_t(AF_INET)
        
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zero) else { return nil }
        
        self.init(reachability: reachability)
    }
    
    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }
    
    deinit {
        stopListening()
    }
    
    // MARK: - Listening
    
    /// Starts listening for changes in network reachability status.
    ///
    /// - Note: Stops and removes any existing listener.
    ///
    /// - Parameters:
    ///   - queue:    `DispatchQueue` on which to call the `listener` closure. `.main` by default.
    ///   - listener: `Listener` closure called when reachability changes.
    ///
    /// - Returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    func startListening(onQueue queue: DispatchQueue = .main,
                        onUpdatePerforming listener: @escaping Listener) -> Bool {
        stopListening()
        
        listenerQueue = queue
        self.listener = listener
        
        var context = SCNetworkReachabilityContext(version: 0,
                                                   info: Unmanaged.passRetained(self).toOpaque(),
                                                   retain: nil,
                                                   release: nil,
                                                   copyDescription: nil)
        let callback: SCNetworkReachabilityCallBack = { (target, flags, info) in
            guard let info = info else { return }
            
            let instance = Unmanaged<NetworkReachabilityManager>.fromOpaque(info).takeUnretainedValue()
            instance.notifyListener(flags)
        }
        
        let queueAdded = SCNetworkReachabilitySetDispatchQueue(reachability, reachabilityQueue)
        let callbackAdded = SCNetworkReachabilitySetCallback(reachability, callback, &context)
        
        // Manually call listener to give initial state, since the framework may not.
        if let currentFlags = flags {
            reachabilityQueue.async {
                self.notifyListener(currentFlags)
            }
        }
        
        return callbackAdded && queueAdded
    }
    
    /// Stops listening for changes in network reachability status.
    func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        listenerQueue = nil
        listener = nil
    }
    
    // MARK: - Internal - Listener Notification
    
    /// Calls the `listener` closure of the `listenerQueue` if the computed status hasn't changed.
    ///
    /// - Note: Should only be called from the `reachabilityQueue`.
    ///
    /// - Parameter flags: `SCNetworkReachabilityFlags` to use to calculate the status.
    private func notifyListener(_ flags: SCNetworkReachabilityFlags) {
        let newStatus = NetworkReachabilityStatus(flags)
        listenerQueue?.async { self.listener?(newStatus) }
    }
}

// MARK: - Convenience conformance

extension NetworkReachabilityStatus: Equatable { }

// MARK: - Convenience properties

private extension SCNetworkReachabilityFlags {
    var isReachable: Bool { return contains(.reachable) }
    var isConnectionRequired: Bool { return contains(.connectionRequired) }
    var canConnectAutomatically: Bool { return contains(.connectionOnDemand) || contains(.connectionOnTraffic) }
    var canConnectWithoutUserInteraction: Bool { return canConnectAutomatically && !contains(.interventionRequired) }
    var isActuallyReachable: Bool { return isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction) }
    var isCellular: Bool {
        #if os(iOS) || os(tvOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
}
