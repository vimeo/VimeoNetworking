//
//  PublishJobConnectionTests.swift
//  VimeoNetworking
//
//  Copyright © 2020 Vimeo. All rights reserved.
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

class PublishJobConnectionTests: XCTestCase {

    private var json: VimeoClient.ResponseDictionary {
        guard let json = ResponseUtilities.loadResponse(
            from: "publish-to-social-connection.json"
        ) else {
            XCTFail()
            return [:]
        }

        return json
    }

    func test_publishJobConnection_isParsedAsExpected_fromVideoObject() throws {
        guard let json = ResponseUtilities.loadResponse(
            from: "video-with-publish-to-social-connection.json"
        ) else {
            XCTFail()
            return
        }

        let video = try VIMObjectMapper.mapObject(responseDictionary: json) as VIMVideo
        let publishConnection = video.publishJobConnection

        XCTAssertNotNil(publishConnection)
        XCTAssertTrue(type(of: publishConnection) == PublishJobConnection?.self)
        XCTAssertEqual(publishConnection?.uri, "/videos/277485394/publish_to_social")
        XCTAssertEqual(publishConnection?.publishConstraints?.facebook?.duration, 14400)
        XCTAssertEqual(publishConnection?.publishConstraints?.facebook?.size, 10737418240)
    }

    func test_publishBlockers_areParsedAsExpected() throws {
        let connection = try VIMObjectMapper.mapObject(responseDictionary: json) as PublishJobConnection

        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.facebook?.size))
        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.facebook?.duration))
        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.facebook?.noPages))

        XCTAssertFalse(try XCTUnwrap(connection.publishBlockers?.twitter?.size))
        XCTAssertFalse(try XCTUnwrap(connection.publishBlockers?.twitter?.duration))

        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.linkedin?.size))
        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.linkedin?.duration))
        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.linkedin?.noOrganizations))

        XCTAssertFalse(try XCTUnwrap(connection.publishBlockers?.youtube?.size))
        XCTAssertFalse(try XCTUnwrap(connection.publishBlockers?.youtube?.duration))
        XCTAssertTrue(try XCTUnwrap(connection.publishBlockers?.youtube?.noChannels))
    }

    func test_publishConstraints_areParsedAsExpected() throws {
        let connection = try VIMObjectMapper.mapObject(responseDictionary: json) as PublishJobConnection

        XCTAssertEqual(connection.publishConstraints?.facebook?.duration, 14400)
        XCTAssertEqual(connection.publishConstraints?.facebook?.size, 10737418240)

        XCTAssertEqual(connection.publishConstraints?.linkedin?.duration, 600)
        XCTAssertEqual(connection.publishConstraints?.linkedin?.size, 5368709120)

        XCTAssertEqual(connection.publishConstraints?.twitter?.duration, 140)
        XCTAssertEqual(connection.publishConstraints?.twitter?.size, 536870912)

        XCTAssertEqual(connection.publishConstraints?.youtube?.duration, 43200)
        XCTAssertEqual(connection.publishConstraints?.youtube?.size, 137438953472)
    }

    func test_publishDestinations_areParsedAsExpected() throws {
        let connection = try VIMObjectMapper.mapObject(responseDictionary: json) as PublishJobConnection

        XCTAssertTrue(try XCTUnwrap(connection.publishDestinations?.facebook))
        XCTAssertFalse(try XCTUnwrap(connection.publishDestinations?.linkedin))
        XCTAssertTrue(try XCTUnwrap(connection.publishDestinations?.twitter))
        XCTAssertFalse(try XCTUnwrap(connection.publishDestinations?.youtube))
    }

    func test_publishedDestinations_handleBadOrMissingValues() throws {
        guard let json = ResponseUtilities.loadResponse(
            from: "publish-to-social-connection-malformed-response.json"
        ) else {
            XCTFail()
            return
        }

        let publishConnection = try VIMObjectMapper.mapObject(responseDictionary: json) as PublishJobConnection
        let destinations = try XCTUnwrap(publishConnection.publishDestinations)

        XCTAssert(destinations.isKind(of: PublishJobDestinations.self))
        XCTAssertFalse(destinations.facebook)
        XCTAssertFalse(destinations.linkedin)
        XCTAssertTrue(destinations.youtube)
        XCTAssertFalse(destinations.twitter)
    }

    @available(iOS 11.0, *)
    func test_publishBlockers_doesNotThrow_whenDecodedWithKeyedUnarchiver() throws {
        guard let json = ResponseUtilities.loadResponse(
            from: "publish-to-social-connection-malformed-response.json"
        ) else {
            XCTFail()
            return
        }

        let publishConnection = try VIMObjectMapper.mapObject(responseDictionary: json) as PublishJobConnection

        XCTAssertNotNil(publishConnection)
        XCTAssertNotNil(publishConnection.publishBlockers)
        XCTAssertNotNil(publishConnection.publishBlockers?.facebook)
        XCTAssertTrue(try XCTUnwrap(publishConnection.publishBlockers?.facebook).size)
        XCTAssertTrue(try XCTUnwrap(publishConnection.publishBlockers?.facebook).duration)
        XCTAssertTrue(try XCTUnwrap(publishConnection.publishBlockers?.facebook).noPages)

        // Missing blocker data is assumed to be false
        XCTAssertNotNil(publishConnection.publishBlockers?.twitter)
        XCTAssertFalse(try XCTUnwrap(publishConnection.publishBlockers?.twitter).size)
        XCTAssertFalse(try XCTUnwrap(publishConnection.publishBlockers?.twitter).duration)

        XCTAssertNotNil(publishConnection.isKind(of: PublishJobConnection.self))

        let data = try NSKeyedArchiver.archivedData(
            withRootObject: publishConnection,
            requiringSecureCoding: false
        )
        let decodedConnection = try XCTUnwrap(
            NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? PublishJobConnection
        )

        XCTAssertNotNil(decodedConnection)
        XCTAssertNotNil(decodedConnection.publishBlockers)
        XCTAssertNotNil(decodedConnection.publishBlockers?.facebook)
        XCTAssertTrue(try XCTUnwrap(decodedConnection.publishBlockers?.facebook).size)
        XCTAssertTrue(try XCTUnwrap(decodedConnection.publishBlockers?.facebook).duration)
        XCTAssertTrue(try XCTUnwrap(decodedConnection.publishBlockers?.facebook).noPages)
        XCTAssertFalse(try XCTUnwrap(decodedConnection.publishBlockers?.twitter).size)
        XCTAssertFalse(try XCTUnwrap(decodedConnection.publishBlockers?.twitter).duration)
    }
}
