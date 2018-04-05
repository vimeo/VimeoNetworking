//
//  VIMVideoTests.swift
//  VimeoNetworkingExample-iOS
//
//  Copyright © 2017 Vimeo. All rights reserved.
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

class VIMVideoTests: XCTestCase
{
    private var liveDictionary: [String: Any] = ["link": "vimeo.com", "key": "abcdefg", "activeTime": Date(), "endedTime": Date(), "archivedTime": Date()]
    
    func test_isLive_returnsTrue_whenLiveObjectExists()
    {
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLive())
    }
    
    func test_isLive_returnsFalse_whenLiveObjectDoesNotExist()
    {
        let videoDictionary: [String: Any] = ["link": "vimeo.com"]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        XCTAssertNotNil(testVideoObject)
        XCTAssertFalse(testVideoObject.isLive())
    }
    
    func test_isLiveEventInProgress_returnsTrue_whenEventIsInUnavailablePreBroadcastState()
    {
        liveDictionary["status"] = "unavailable"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isLiveEventInProgress_returnsTrue_whenEventIsInPendingPreBroadcastState()
    {
        liveDictionary["status"] = "pending"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!

        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isLiveEventInProgress_returnsTrue_whenEventIsInReadyPreBroadcastState()
    {
        liveDictionary["status"] = "ready"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isLiveEventInProgress_returnsTrue_whenEventIsInMidBroadcastState()
    {
        liveDictionary["status"] = "streaming"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isLiveEventInProgress_returnsTrue_whenEventIsInArchivingState()
    {
        liveDictionary["status"] = "archiving"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isLiveEventInProgress_returnsFalse_whenEventIsInPostBroadcastState()
    {
        liveDictionary["status"] = "done"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertFalse(testVideoObject.isLiveEventInProgress())
    }
    
    func test_isPostBroadcast_returnsTrue_whenEventIsInDoneState()
    {
        liveDictionary["status"] = "done"
        let testLiveObject = VIMLive(keyValueDictionary: liveDictionary)!
        let videoDictionary: [String: Any] = ["live": testLiveObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertNotNil(testLiveObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.isPostBroadcast())
    }
    
    // MARK: - Review Page
    
    func test_video_has_review_page()
    {
        let reviewPageDictionary: [String: Any] = ["active": true, "link": "test/linkNotEmpty"]
        let reviewObject = (VIMReviewPage(keyValueDictionary: reviewPageDictionary))!
        let videoDictionary: [String: Any] = ["reviewPage": reviewObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!

        XCTAssertNotNil(reviewObject)
        XCTAssertNotNil(testVideoObject)
        XCTAssertTrue(testVideoObject.hasReviewPage())
    }
    
    func test_video_hasnt_review_page()
    {
        let reviewPageDictionary: [String: Any] = ["active": true, "link": ""]
        let reviewObject = (VIMReviewPage(keyValueDictionary: reviewPageDictionary))!
        let videoDictionary: [String: Any] = ["reviewPage": reviewObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertFalse(testVideoObject.hasReviewPage())
    }
    
    func test_video_hasnt_review_page_because_is_inactive()
    {
        let reviewPageDictionary: [String: Any] = ["active": false, "link": "test/LinkExistButIsNotActive"]
        let reviewObject = (VIMReviewPage(keyValueDictionary: reviewPageDictionary))!
        let videoDictionary: [String: Any] = ["reviewPage": reviewObject]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        
        XCTAssertEqual(testVideoObject.hasReviewPage(), false)
    }
    
    // MARK: - Privacy
    
    func test_canDownloadOnDesktop_returnsTrue_whenCanDownloadIsOne()
    {
        let privacyDictionary: [String: Any] = ["canDownload": 1]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let videoDictionary: [String: Any] = ["privacy": privacy as Any]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        let canDownload = try? testVideoObject.canDownloadOnDesktop()
        XCTAssertTrue(canDownload!, "canDownloadFromDesktop unexpectedly returns false")
    }
    
    func test_canDownloadOnDesktop_returnsFalse_whenCanDownloadIsZero()
    {
        let privacyDictionary: [String: Any] = ["canDownload": 0]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let videoDictionary: [String: Any] = ["privacy": privacy as Any]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        let canDownload = try? testVideoObject.canDownloadOnDesktop()
        XCTAssertFalse(canDownload!, "canDownloadFromDesktop unexpectedly returns true")
    }
    
    func test_canDownloadOnDesktop_returnsError_whenCanDownloadIsInvalid()
    {
        let privacyDictionary: [String: Any] = ["canDownload": []]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let videoDictionary: [String: Any] = ["privacy": privacy as Any]
        let testVideoObject = VIMVideo(keyValueDictionary: videoDictionary)!
        let canDownload = try? testVideoObject.canDownloadOnDesktop()
        XCTAssertNil(canDownload, "canDownloadFromDesktop unexpectedly returns true")
    }
}
