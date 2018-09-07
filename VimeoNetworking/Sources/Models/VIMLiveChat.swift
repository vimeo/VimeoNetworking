//
//  VIMLiveChat.swift
//  VimeoNetworking
//
//  Created by Van Nguyen on 10/10/2017.
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

/// An object representing the `chat` field in a `live` response. This
/// `live` response is part of the `clip` representation.
public class VIMLiveChat: VIMModelObject
{
    private struct Constants
    {
        static let UserKey = "user"
    }
    
    /// The ID of the live event chat room.
    @objc public private(set) var roomId: NSNumber?
    
    /// JWT for the user to access the live event chat room.
    @objc public private(set) var token: String?
    
    /// The current user.
    @objc public private(set) var user: VIMLiveChatUser?
    
    @objc public override func getClassForObjectKey(_ key: String!) -> AnyClass?
    {
        if key == Constants.UserKey
        {
            return VIMLiveChatUser.self
        }
        
        return nil
    }
}
