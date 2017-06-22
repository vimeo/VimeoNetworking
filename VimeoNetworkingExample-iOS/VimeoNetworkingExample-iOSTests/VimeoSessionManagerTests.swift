//
//  VimeoSessionManagerTests.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 7/5/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import VimeoNetworking

class VimeoSessionManagerTests: XCTestCase
{
    func test_VimeoSessionManager_defaultBaseUrl()
    {
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3")
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        XCTAssertEqual(sessionManager.baseURL, VimeoBaseURL)
    }
    
    func test_VimeoSessionManager_canSetBaseUrl()
    {
        let testApiServer = URL(string: "https://test.api.vimeo.com")!
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3",
                                             baseUrl: testApiServer)
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        XCTAssertEqual(sessionManager.baseURL, testApiServer)
    }
    
    func test_VimeoSessionManager_canCreateTasksWithOverridenBaseUrl()
    {
        let testApiServer = URL(string: "https://test.api.vimeo.com")!
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3",
                                             baseUrl: testApiServer)
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        
        let testPath = "/test/api/endpoint"
        let testUrl = testApiServer.appendingPathComponent(testPath)
        
        var task = sessionManager.get(testPath, parameters: nil, progress: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.post(testPath, parameters: nil, progress: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.put(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)

        task = sessionManager.patch(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)

        task = sessionManager.delete(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
    }
    
    func test_VimeoSessionManager_canCreateTasksWithDefaultBaseUrl()
    {
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3")
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        
        let testPath = "/test/api/endpoint"
        let testUrl = VimeoBaseURL.appendingPathComponent(testPath)
        
        var task = sessionManager.get(testPath, parameters: nil, progress: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.post(testPath, parameters: nil, progress: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.put(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.patch(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
        
        task = sessionManager.delete(testPath, parameters: nil, success: nil, failure: nil)
        XCTAssertEqual(task?.currentRequest?.url, testUrl)
    }
    
    func test_VimeoSessionManager_handleClientDidAuthenticate_setsCorrectTokenOnRequestSerializer()
    {
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3")
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        
        let testAccount = VIMAccount()
        testAccount.accessToken = "TestAccessToken"
        
        sessionManager.clientDidAuthenticate(with: testAccount)
        
        guard let requestSerializer = sessionManager.requestSerializer as? VimeoRequestSerializer else
        {
            XCTFail("Incorrect request serializer")
            return
        }
        
        XCTAssertEqual(requestSerializer.accessTokenProvider?(), testAccount.accessToken)
    }
    
    func test_VimeoSessionManager_handleClientDidClearAccount_clearsTokenOnRequestSerializer()
    {
        let configuration = AppConfiguration(clientIdentifier: "{TEST CLIENT ID}",
                                             clientSecret: "{TEST CLIENT SECRET}",
                                             scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                             keychainService: "com.vimeo.keychain_service",
                                             apiVersion: "3.3")
        
        let sessionManager = VimeoSessionManager.defaultSessionManager(appConfiguration: configuration)
        
        let testAccount = VIMAccount()
        testAccount.accessToken = "TestAccessToken"
        
        guard let requestSerializer = sessionManager.requestSerializer as? VimeoRequestSerializer else
        {
            XCTFail("Incorrect request serializer")
            return
        }
        
        sessionManager.clientDidAuthenticate(with: testAccount)
        XCTAssertNotNil(requestSerializer.accessTokenProvider)
        
        sessionManager.clientDidClearAccount()
        XCTAssertNil(requestSerializer.accessTokenProvider)
    }
}
