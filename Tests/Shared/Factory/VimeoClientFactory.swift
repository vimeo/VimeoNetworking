//
//  VimeoClientFactory.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/14/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
@testable import VimeoNetworking


/// Factory method to create VimeoClient instances used in unit testing
/// - Parameters:
///   - reachabilityManager: The optional ReachabilityManaging instance to be used by the client
///   - sessionManager: The Network session manager associated with the client
///   - appConfiguration: the configuration to be used when setting up the client and session manager
func makeVimeoClient(
    reachabilityManager: ReachabilityManaging? = VimeoReachabilityProvider.reachabilityManager,
    sessionManager: SessionManaging = VimeoSessionManager.fake,
    appConfiguration: AppConfiguration = .fake
) -> VimeoClient {
    return VimeoClient(
        appConfiguration: appConfiguration,
        reachabilityManager: reachabilityManager,
        sessionManager: sessionManager
    )
}

private extension VimeoSessionManager {
    static let fake: VimeoSessionManager = .defaultSessionManager(
        appConfiguration: .fake,
        configureSessionManagerBlock: nil
    )
}

private extension AppConfiguration {
    static let fake: AppConfiguration = {
        return AppConfiguration(
            clientIdentifier: "FAKE_CLIENT_ID",
            clientSecret: "FAKE_CLIENT_SECRET",
            scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
            keychainService: "com.vimeo.keychain_service",
            apiVersion: "3.3.13"
        )
    }()
}
