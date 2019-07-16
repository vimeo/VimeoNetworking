//
//  VIMUserAccountType.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 7/16/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

@objc public enum VIMUserAccountType: Int {
    
    case basic = 0
    case pro
    case plus
    case business
    case livePro
    case liveBusiness
    case livePremium
    case proUnlimited
    case producer
    case enterprise
    
    init(string: String) {
        switch string {
        case .basic:
            self = .basic
        case .pro:
            self = .pro
        case .plus:
            self = .plus
        case .business:
            self = .business
        case .livePro:
            self = .livePro
        case .liveBusiness:
            self = .liveBusiness
        case .livePremium:
            self = .livePremium
        case .proUnlimited:
            self = .proUnlimited
        case .producer:
            self = .producer
        case .enterprise:
            self = .enterprise
        default:
            self = .basic
        }
    }
}

extension VIMUserAccountType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .basic:
            return .basic
        case .pro:
            return .pro
        case .plus:
            return .plus
        case .business:
            return .business
        case .livePro:
            return .livePro
        case .liveBusiness:
            return .liveBusiness
        case .livePremium:
            return .livePremium
        case .proUnlimited:
            return .proUnlimited
        case .producer:
            return .producer
        case .enterprise:
            return .enterprise
        }
    }
    
}

private extension String {
    static let basic = "basic"
    static let plus = "plus"
    static let pro = "pro"
    static let business = "business"
    static let livePro = "live_pro"
    static let liveBusiness = "live_business"
    static let livePremium = "live_premium"
    static let proUnlimited = "pro_unlimited"
    static let producer = "producer"
    static let enterprise = "enterprise"
}

// Objective-C convenience bridge
@objc public class VIMUserAccountTypeBridge: NSObject {
    
    override private init() {}
    
    @objc public static func account(fromString string: String) -> VIMUserAccountType {
        return VIMUserAccountType(string: string)
    }
    
    @objc public static func string(from accountType: VIMUserAccountType) -> String {
        return accountType.description
    }
}
