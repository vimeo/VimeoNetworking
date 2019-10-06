//
//  VIMLiveTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Van Nguyen on 08/29/2017.
//  Copyright (c) Vimeo (https://vimeo.com)
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
import OHHTTPStubs
import VimeoNetworking

class VIMLiveTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        VimeoClient.configure(with: AppConfiguration(clientIdentifier: "{CLIENT_ID}",
                                                                                 clientSecret: "{CLIENT_SECRET}",
                                                                                 scopes: [.Public, .Private, .Purchased, .Create, .Edit, .Delete, .Interact, .Upload],
                                                                                 keychainService: "com.vimeo.keychain_service",
                                                                                 apiVersion: "3.3.10"), configureSessionManagerBlock: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    private func assert(liveObject live: VIMLive?) {
        XCTAssertNotNil(live)
        XCTAssertEqual(live?.link, MockLive.Link)
        XCTAssertEqual(live?.key, MockLive.Key)
        XCTAssertEqual(live?.activeTime?.description, MockLive.ActiveTime)
        XCTAssertNil(live?.endedTime)
        XCTAssertNil(live?.archivedTime)
        XCTAssertEqual(live?.liveStreamingStatus, .streaming)
    }
    
    private func assert(liveChatObject chat: VIMLiveChat?) {
        XCTAssertNotNil(chat)
        XCTAssertEqual(chat?.roomId?.int64Value, MockLiveChat.RoomId)
        XCTAssertEqual(chat?.token, MockLiveChat.Token)
    }
    
    private func assert(liveChatUserObject user: VIMLiveChatUser?) {
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.account, VIMUserAccountType.liveBusiness.description)
        XCTAssertEqual(user?.id?.int64Value, MockLiveChatUser.Id)
        XCTAssertEqual(user?.name, MockLiveChatUser.Name)
        XCTAssertEqual(user?.isStaff?.boolValue, true)
        XCTAssertEqual(user?.isCreator?.boolValue, true)
        XCTAssertEqual(user?.uri, MockLiveChatUser.Uri)
        XCTAssertNotNil(user?.pictures)
        XCTAssertEqual(user?.link, MockLiveChatUser.Link)
    }
    
    func testParsingLiveObject() {
        let request = Request<VIMVideo>(path: "/videos/" + Constants.CensoredId)
        
        stub(condition: isPath("/videos/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("clip_live.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network call expectation")
        
        _ = VimeoClient.shared.request(request) { response in
            switch response {
            case .success(let result):
                let video = result.model
                
                self.assert(liveObject: video.live)
                self.assert(liveChatObject: video.live?.chat)
                self.assert(liveChatUserObject: video.live?.chat?.user)
                
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0) { error in
            if let unWrappedError = error {
                XCTFail("\(unWrappedError)")
            }
        }
    }
}
