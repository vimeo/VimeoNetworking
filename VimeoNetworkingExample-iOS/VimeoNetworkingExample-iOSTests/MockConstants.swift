//
//  MockConstants.swift
//  VimeoNetworkingExample-iOSTests
//
//  Created by Nguyen, Van on 10/30/17.
//  Copyright © 2017 Vimeo. All rights reserved.
//

import Foundation

struct MockLive
{
    static let Link = "mock_live_link"
    static let Key = "mock_live_key"
    static let ActiveTime = "mock_live_active_time"
}

struct MockLiveChat
{
    static let RoomId: Int64 = -1
    static let Token = "mock_chat_token"
}

struct MockLiveChatUser
{
    static let Uri = "mock_user_uri"
    static let Id: Int64 = -2
    static let Name = "mock_user_name"
    static let Link = "mock_user_link"
}

struct MockLiveHeartbeat
{
    static let Heartbeat = "mock_live_heartbeat"
}

struct Constants
{
    static let CensoredId = "xxxxxx"
}
