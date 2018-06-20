//
//  ResponseCacheTests.swift
//  VimeoNetworkingExample-iOSTests, VimeoNetworkingExample-tvOSTests
//
//  Created by Westendorf, Mike on 5/21/17.
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

class ResponseCacheTests: XCTestCase
{
    private static let cacheDirectory = "com.vimeo.test.cache"
    private static let testFileName = "testDictionary"
    private let responseCache = ResponseCache(cacheDirectory: ResponseCacheTests.cacheDirectory)
 
    func test_clear_removesAllEntries_fromDisk()
    {
        let testDictionary: [String: String] = ["Hello": "There"]
        let data = NSKeyedArchiver.archivedData(withRootObject: testDictionary)
        let fileManager = FileManager()
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: directory).appendingPathComponent(ResponseCacheTests.cacheDirectory, isDirectory: true)
        let directoryPath = url.path
        let fileURL = url.appendingPathComponent(ResponseCacheTests.testFileName)
        
        do
        {
            if fileManager.fileExists(atPath: directoryPath) == false
            {
                try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            }
            else
            {
                XCTFail("Aborting test, test dirctory already exists.")
            }
            
            if fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil) == false
            {
                XCTFail("Could not store test object.")
            }
        }
        catch let error
        {
            XCTFail("Failed to archive test data with error: \(error)")
        }
        
        XCTAssertTrue(fileManager.fileExists(atPath: directoryPath))
        self.responseCache.clear()
        
        let expectation = self.expectation(description: "Test cache was successfully removed.")
        DispatchQueue.main.async {
            XCTAssertFalse(fileManager.fileExists(atPath: directoryPath) == false)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
}
