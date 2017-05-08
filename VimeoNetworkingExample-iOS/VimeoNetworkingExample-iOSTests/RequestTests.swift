//
//  RequestTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Lim, Jennifer on 4/17/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import XCTest

@testable import VimeoNetworkingExample_iOS

class RequestTests: XCTestCase
{
    func testCacheKeyFirstPage()
    {
        let cacheKeyFirstPageURI = "/channels/staffpicks/videos"
        let request = Request<VIMNullResponse>(path: cacheKeyFirstPageURI)
        
        XCTAssertTrue(request.cacheKey == "cached.channels.staffpicks.videos.5286765347155622285", "")
    }
    
    func testCacheKeyNextPage()
    {
        // That test ensure that for a URI with filters the url Path remains `/channels/staffpicks/videos`.
        let cacheKeyNextPageURI = "/channels/staffpicks/videos?fields=uri%2Cresource_key%2Cname%2Cdescription%2Ccreated_time%2Crelease_time%2Cduration%2Cplay.status%2Cplay.hls%2Cplay.drm%2Cplay.progressive%2Cwidth%2Cheight%2Clink%2Cpictures.sizes.width%2Cpictures.sizes.link%2Cstatus%2Cprivacy.view%2Cprivacy.comments%2Ccategories.uri%2Cmetadata.interactions%2Cmetadata.connections.comments%2Cmetadata.connections.likes%2Cmetadata.connections.related%2Cmetadata.connections.recommendations%2Cmetadata.connections.ondemand%2Cmetadata.connections.trailer%2Cstats%2Cpassword%2Ccontent_rating%2Cbadge%2Cspatial%2Cuser.uri%2Cuser.name%2Cuser.badge.type%2Cuser.badge.text%2Cuser.bio%2Cuser.account%2Cuser.location%2Cuser.pictures.uri%2Cuser.pictures.sizes.width%2Cuser.pictures.sizes.link%2Cuser.upload_quota%2Cuser.metadata.interactions%2Cuser.metadata.connections.pictures%2Cuser.metadata.connections.likes%2Cuser.metadata.connections.following%2Cuser.metadata.connections.followers%2Cuser.metadata.connections.videos%2Cuser.metadata.connections.watchlater%2Cuser.created_time&page=9&sort=default"
        let request = Request<VIMNullResponse>(path: cacheKeyNextPageURI)
        
        XCTAssertTrue(request.cacheKey == "cached.channels.staffpicks.videos.7451360055660162083", "")
    }
}
