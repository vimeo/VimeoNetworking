//
//  AlbumTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Hawkins, Jason on 10/26/18.
//  Copyright © 2018 Vimeo. All rights reserved.
//

import XCTest
@testable import VimeoNetworking

class AlbumTests: XCTestCase {
    private var testAlbum: Album?
    private var albumJSONDictionary: VimeoClient.ResponseDictionary?

    override func setUp() {
        guard let albumJSONDictionary = ResponseUtilities.loadResponse(from: "album-response.json") else {
            return
        }
        
        self.albumJSONDictionary = albumJSONDictionary
        self.testAlbum = try! VIMObjectMapper.mapObject(responseDictionary: albumJSONDictionary) as Album
    }

    override func tearDown() {
        self.testAlbum = nil
        self.albumJSONDictionary = nil
    }

    func test_AlbumObject_ParsesCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        XCTAssertEqual(album.albumName, "2018")
        XCTAssertEqual(album.albumDescription, "Favorites from 2018.")
        XCTAssertEqual(album.albumLogo?.uri, "/users/267176/albums/5451829/logos/18363")
        XCTAssertEqual(album.privacy?.view, "anybody")
        XCTAssertEqual(album.duration, 1003)
        XCTAssertEqual(album.uri, "/users/267176/albums/5451829")
        XCTAssertEqual(album.link, "https://vimeo.com/album/5451829")
        XCTAssertNotNil(album.embed?.html)
        XCTAssertNotNil(album.videoThumbnails)
        XCTAssertNotNil(album.user)
        XCTAssertEqual(album.theme, "dark")
    }
    
    func test_AlbumPictures_ParsesCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        XCTAssertNotNil(album.videoThumbnails)
        XCTAssertTrue(album.videoThumbnails?.count == 2)
        
        let videoThumbnails0 = album.videoThumbnails![0] as! VIMPictureCollection
        let videoThumbnails1 = album.videoThumbnails![1] as! VIMPictureCollection
        XCTAssertEqual(videoThumbnails0.uri, "/videos/248249215/pictures/673727920")
        XCTAssertEqual(videoThumbnails1.uri, "/videos/190063150/pictures/624750928")
    }
    
    func test_AlbumDates_ParsesAndFormatCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        XCTAssertNotNil(album.createdTimeString)
        XCTAssertEqual(album.createdTime!.timeIntervalSince1970, TimeInterval(1538405413))
        XCTAssertNotNil(album.modifiedTimeString)
        XCTAssertEqual(album.modifiedTime!.timeIntervalSince1970, TimeInterval(1540585280))
    }
    
    func test_AlbumLogoOjbect_ParsesCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        guard let logo = album.albumLogo?.pictures?.first as? VIMPicture else {
            assertionFailure("Failed to unwrap the test album's logo.")
            return
        }
        
        XCTAssertEqual(logo.width, 200)
        XCTAssertEqual(logo.height, 200)
        XCTAssertEqual(logo.link, "https://i.vimeocdn.com/album_custom_logo/18363_200x200")
    }
    
    func test_AlbumEmbedObject_ParsesCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        XCTAssertNotNil(album.embed)
        XCTAssertEqual(album.embed?.html,
            """
            <div style='padding:56.25% 0 0 0;position:relative;'><iframe src='https://vimeo.com/album/5451829/embed' allowfullscreen frameborder='0' style='position:absolute;top:0;left:0;width:100%;height:100%;'></iframe></div>
            """)
    }
    
    func test_AlbumConnection_ParsesCorrectly() {
        guard let album = self.testAlbum else {
            assertionFailure("Failed to unwrap the test album.")
            return
        }
        
        XCTAssertNotNil(album.connectionWithName(connectionName: VIMConnectionNameVideos), "Expected to find a videos connection but return nil instead.")
        
        let videosConnection = album.connectionWithName(connectionName: VIMConnectionNameVideos)
        XCTAssertEqual(videosConnection?.uri, "/albums/5451829/videos", "The connection URI's do not match.")
        XCTAssertEqual(videosConnection?.total, 2, "The total number of videos in the connection do not much the expected number of 2.")
    }
    
    func test_isPasswordProtected_returnsTrue_whenPrivacyViewIsPassword()
    {
        let privacyDictionary: [String: Any] = ["view": "password"]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let albumDictionary: [String: Any] = ["privacy": privacy as Any]
        let testAlbum = Album(keyValueDictionary: albumDictionary)!
        XCTAssertTrue(testAlbum.isPasswordProtected(), "Test album should return as password protected.")
    }

    func test_privacyPassword_isEqualToExpectedValue_whenPrivacyViewIsPassword()
    {
        let privacyDictionary: [String: Any] = ["view": "password", "password": "test"]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let albumDictionary: [String: Any] = ["privacy": privacy as Any]
        let testAlbum = Album(keyValueDictionary: albumDictionary)!
        XCTAssertTrue(testAlbum.isPasswordProtected(), "Test album should return as password protected.")
        XCTAssertEqual(testAlbum.privacy?.password, "test", "Password should be 'test'.")
    }
    
    func test_isPasswordProtected_returnsFalse_whenPrivacyViewIsEmbedOnly()
    {
        let privacyDictionary: [String: Any] = ["view": "embed_only"]
        let privacy = VIMPrivacy(keyValueDictionary: privacyDictionary)!
        let videoDictionary: [String: Any] = ["privacy": privacy as Any]
        let testAlbum = Album(keyValueDictionary: videoDictionary)!
        XCTAssertFalse(testAlbum.isPasswordProtected(), "Test album should not return as password protected.")
    }
}
