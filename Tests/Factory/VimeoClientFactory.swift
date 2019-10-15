//
//  VimeoClientFactory.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/14/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
@testable import VimeoNetworking

func makeVimeoClient(
    reachabilityManager: ReachabilityManaging? = VimeoReachabilityProvider.reachabilityManager,
    sessionManager: SessionManaging & AuthenticationListeningDelegate = VimeoSessionManager.fake,
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
            clientIdentifier: "{CLIENT_ID}",
            clientSecret: "{CLIENT_SECRET}",
            scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
            keychainService: "com.vimeo.keychain_service",
            apiVersion: "3.3.13"
        )
    }()
}
