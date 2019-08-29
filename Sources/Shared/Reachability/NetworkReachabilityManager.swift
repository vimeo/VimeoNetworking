//
//  NetworkReachabilityManager.swift
//  VimeoNetworking
//
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
import SystemConfiguration

/// The protocol indicating the capabilities of a `ReachabilityManagingType` type
public protocol ReachabilityManagingType {
    func startListening(onQueue queue: DispatchQueue, onUpdatePerforming listener: @escaping ReachabilityListener) -> Bool
    func stopListening()
    var isReachable: Bool { get }
    var isReachableOnCellular: Bool { get }
    var isReachableOnEthernetOrWiFi: Bool { get }
}

/// A closure executed when the network reachability status changes. The closure takes a single argument: the
/// network reachability status.
public typealias ReachabilityListener = (NetworkReachabilityStatus) -> Void

/// Original source from the link below, with modifications.
/// https://raw.githubusercontent.com/Alamofire/Alamofire/master/Source/NetworkReachabilityManager.swift
///
/// The `NetworkReachabilityManager` class listens for reachability changes of
/// hosts and addresses for both cellular and WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed,
/// or to retry network requests when a connection is established.
/// Reachability should *not* be used to prevent a user from initiating a network request,
/// as it's possible that an initial request may be required to establish reachability.
internal class NetworkReachabilityManager: ReachabilityManagingType {
            
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
    private let reachabilityQueue = DispatchQueue(label: "com.vimeo.reachabilityQueue")

    /// A closure executed when the network reachability status changes.
    private var listener: ReachabilityListener?
    
    /// `DispatchQueue` on which listeners will be called.
    private var listenerQueue: DispatchQueue?
    
    /// `SCNetworkReachability` instance providing notifications.
    private let reachability: SCNetworkReachability
    
    /// Protected storage for the previous status.
    private let previousStatus = Protector<NetworkReachabilityStatus?>(nil)
    
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
                        onUpdatePerforming listener: @escaping ReachabilityListener) -> Bool {
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
        previousStatus.write { $0 = nil }
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
        previousStatus.write { previousStatus in
            guard previousStatus != newStatus else { return }
            
            previousStatus = newStatus
            
            listenerQueue?.async { self.listener?(newStatus) }
        }
    }
}

// MARK: -

/// An `os_unfair_lock` wrapper.
final class UnfairLock {
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }

    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    /// Execute a closure while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        return closure()
    }
}

/// A thread-safe wrapper around a value.
final class Protector<T> {
    private let lock = UnfairLock()
    private var value: T

    init(_ value: T) {
        self.value = value
    }

    /// The contained value. Unsafe for anything more than direct read or write.
    var directValue: T {
        get { return lock.around { value } }
        set { lock.around { value = newValue } }
    }

    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func read<U>(_ closure: (T) -> U) -> U {
        return lock.around { closure(self.value) }
    }

    /// Synchronously modify the protected value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The modified value.
    @discardableResult
    func write<U>(_ closure: (inout T) -> U) -> U {
        return lock.around { closure(&self.value) }
    }
}
