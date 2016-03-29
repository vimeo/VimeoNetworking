//
//  AuthenticationController.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/21/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import Foundation

final class AuthenticationController
{
    static let ErrorDomain = "AuthenticationControllerErrorDomain"
    
    static let ErrorAuthToken = 1004 // TODO: Make this an enum to ensure uniqueness [RH] (3/23/16)
    static let ErrorCodeGrant = 1005
    static let ErrorCodeGrantState = 1006
    
    private static let ResponseTypeKey = "response_type"
    private static let CodeKey = "code"
    private static let ClientIDKey = "client_id"
    private static let RedirectURIKey = "redirect_uri"
    private static let ScopeKey = "scope"
    private static let StateKey = "state"
    
    private static let CodeGrantAuthorizationPath = "oauth/authorize"
    
    typealias AuthenticationCompletion = ResultCompletion<VIMAccountNew>.T
    
    /// State is tracked for the code grant request/response cycle, to avoid interception
    static let state = NSProcessInfo.processInfo().globallyUniqueString
    
    let configuration: AppConfiguration
    let client: VimeoClient
    
    private let accountStore = AccountStore()
    
    init(configuration: AppConfiguration, client: VimeoClient)
    {
        self.configuration = configuration
        self.client = client
    }
    
    // MARK: - Saved Accounts
    
    func loadAccountAndAuthenticate(completion: AuthenticationCompletion)
    {
        do
        {
            if let account = try self.loadSavedAccount()
            {
                completion(result: .Success(result: account))
                
                return
            }
        }
        catch let error
        {
            assertionFailure("could not load account: \(error)")
        }
        
        self.clientCredentialsGrant(completion)
    }
    
    func loadSavedAccount() throws -> VIMAccountNew?
    {
        var loadedAccount = try self.accountStore.loadAccount(.User)
        
        if loadedAccount == nil
        {
            loadedAccount = try self.accountStore.loadAccount(.ClientCredentials)
        }
        
        if let loadedAccount = loadedAccount
        {
            try self.authenticateClient(account: loadedAccount)
        }
        
        return loadedAccount
    }
    
    // MARK: - Public Authentication
    
    func clientCredentialsGrant(completion: AuthenticationCompletion)
    {
        let request = AuthenticationRequest.postClientCredentialsGrant(scopes: self.configuration.scopes)
        
        self.authenticate(request: request, completion: completion)
    }
    
    var codeGrantRedirectURI: String
    {
        let scheme = "vimeo\(self.configuration.clientKey)"
        let path = "auth"
        let URI = "\(scheme)://\(path)"
        
        return URI
    }
    
    func codeGrantAuthorizationURL() -> NSURL
    {
        let parameters = [self.dynamicType.ResponseTypeKey: self.dynamicType.CodeKey,
                          self.dynamicType.ClientIDKey: self.configuration.clientKey,
                          self.dynamicType.RedirectURIKey: self.codeGrantRedirectURI,
                          self.dynamicType.ScopeKey: Scope.combine(self.configuration.scopes),
                          self.dynamicType.StateKey: self.dynamicType.state]
        
        var error: NSError?
        guard let urlString = VimeoBaseURLString?.URLByAppendingPathComponent(self.dynamicType.CodeGrantAuthorizationPath).absoluteString
        else
        {
            fatalError("Could not make code grant auth URL")
        }
        
        let urlRequest = VimeoRequestSerializer(appConfiguration: self.configuration).requestWithMethod("GET", URLString: urlString, parameters: parameters, error: &error)
        
        guard let url = urlRequest.URL where error == nil
        else
        {
            fatalError("Could not make code grant auth URL")
        }
        
        return url
        
    }
    
    func codeGrant(responseURL responseURL: NSURL, completion: AuthenticationCompletion)
    {
        guard let queryString = responseURL.query,
            let parameters = queryString.parametersFromQueryString(),
            let code = parameters[self.dynamicType.CodeKey],
            let state = parameters[self.dynamicType.StateKey]
        else
        {
            let errorDescription = "Could not retrieve parameters from code grant response"
            
            assertionFailure(errorDescription)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorCodeGrant, userInfo: [NSLocalizedDescriptionKey: errorDescription])
            
            completion(result: .Failure(error: error))
            
            return
        }
        
        if state != self.dynamicType.state
        {
            let errorDescription = "Code grant returned state did not match existing state"
            
            assertionFailure(errorDescription)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorCodeGrantState, userInfo: [NSLocalizedDescriptionKey: errorDescription])
            
            completion(result: .Failure(error: error))
            
            return
        }
        
        let request = AuthenticationRequest.postCodeGrant(code: code, redirectURI: self.codeGrantRedirectURI)
        
        self.authenticate(request: request, completion: completion)
    }
    
    // MARK: - Private Authentication
    
    func login(username username: String, password: String, completion: AuthenticationCompletion)
    {
        let request = AuthenticationRequest.postLogin(username: username, password: password, scopes: self.configuration.scopes)
        
        self.authenticate(request: request, completion: completion)
    }
    
    func join(name name: String, email: String, password: String, completion: AuthenticationCompletion)
    {
        let request = AuthenticationRequest.postJoin(name: name, email: email, password: password, scopes: self.configuration.scopes)
        
        self.authenticate(request: request, completion: completion)
    }
    
    func facebookLogin(facebookToken facebookToken: String, completion: AuthenticationCompletion)
    {
        let request = AuthenticationRequest.postLoginFacebook(facebookToken: facebookToken, scopes: self.configuration.scopes)
        
        self.authenticate(request: request, completion: completion)
    }
    
    func facebookJoin(facebookToken facebookToken: String, completion: AuthenticationCompletion)
    {
        let request = AuthenticationRequest.postJoinFacebook(facebookToken: facebookToken, scopes: self.configuration.scopes)
        
        self.authenticate(request: request, completion: completion)
    }
    
    // MARK: - Private
    
    private func authenticate(request request: AuthenticationRequest, completion: AuthenticationCompletion)
    {
        self.client.request(request) { result in
            
            let handledResult = self.handleAuthenticationResult(result)
            
            completion(result: handledResult)
        }
    }
    
    private func handleAuthenticationResult(result: Result<VIMAccountNew>) -> Result<VIMAccountNew>
    {
        guard case .Success(let account) = result
        else
        {
            // An error was returned from the API, there's nothing to handle [RH]
            return result
        }
        
        do
        {
            try self.authenticateClient(account: account)
            
            let accountType: AccountStore.AccountType = (account.user != nil) ? .User : .ClientCredentials
            
            try self.accountStore.saveAccount(account, type: accountType)
        }
        catch let error
        {
            return .Failure(error: error as NSError)
        }
        
        return result
    }
    
    private func authenticateClient(account account: VIMAccountNew) throws
    {
        guard account.accessToken != nil
            else
        {
            let errorDescription = "AuthenticationController did not recieve an access token with account response"
            
            assertionFailure(errorDescription)
            
            let error = NSError(domain: self.dynamicType.ErrorDomain, code: self.dynamicType.ErrorAuthToken, userInfo: [NSLocalizedDescriptionKey: errorDescription])
            
            throw error
        }
        
        self.client.authenticate(account: account)
    }
}