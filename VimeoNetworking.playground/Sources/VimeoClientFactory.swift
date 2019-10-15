import Foundation
import VimeoNetworking

private let clientID = ""
private let clientSecret = ""
private let scopes: [Scope] = [.Public, .Private, .VideoFiles]

public let token = ""

private let configuration = AppConfiguration(
    clientIdentifier: clientID,
    clientSecret: clientSecret,
    scopes: scopes,
    keychainService: ""
)

public func makeVimeoClient() -> VimeoClient {
    return VimeoClient(appConfiguration: configuration)
}

public func makeAuthenticationController(using client: VimeoClient) -> AuthenticationController {
    return AuthenticationController(
        client: client,
        appConfiguration: configuration,
        configureSessionManagerBlock: nil
    )
}
