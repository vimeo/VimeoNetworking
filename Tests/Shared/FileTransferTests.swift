//
//  FileTransferTests.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 2/12/19.
//  Copyright © 2019 Vimeo. All rights reserved.
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
@testable import VimeoNetworking

class FileTransferTests: XCTestCase {

    override func setUp() {
        
        super.setUp()

        stub(condition: isPath("/videos/" + Constants.CensoredId)) { _ in
            let stubPath = OHPathForFile("clip.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }

    override func tearDown() {
        
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }

    func testParsingFileTransferResponse() {
        let request = Request<VIMVideo>(path: "/videos/" + Constants.CensoredId)
        
        let expectation = self.expectation(description: "Network call expectation")

        let client = makeVimeoClient()
        _ = client.request(request) { response in
            switch response {
            case .success(let result):
                let video = result.model
                
                XCTAssertNotNil(video.fileTransfer, "\"fileTransfer\" response should have been not nil.")
                XCTAssertEqual(video.fileTransfer!.url, URL(string: "www.google.com"), "\"url\" should have been \"www.google.com\".")
                
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
