//
//  VimeoClientFactory.swift
//  VimeoNetworking
//
//  Created by Rogerio de Paula Assis on 10/14/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation
@testable import VimeoNetworking

extension AppConfiguration {
    static let mock: AppConfiguration = {
        return AppConfiguration(
            clientIdentifier: "{CLIENT_ID}",
            clientSecret: "{CLIENT_SECRET}",
            scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
            keychainService: "com.vimeo.keychain_service",
            apiVersion: "3.3.13"
        )
    }()
}

public func makeVimeoClient() -> VimeoClient {
    let reachabilityManager = VimeoReachabilityProvider.reachabilityManager
    let defaultSessionManager = VimeoSessionManager.defaultSessionManager(
        appConfiguration: .mock,
        configureSessionManagerBlock: nil
    )
    return VimeoClient(
        appConfiguration: .mock,
        reachabilityManager: reachabilityManager,
        sessionManager: defaultSessionManager
    )
}
