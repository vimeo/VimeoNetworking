//
//  Request+Album.swift
//  VimeoNetworking
//
//  Copyright © 2018 Vimeo. All rights reserved.
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

fileprivate enum Key {
    static let name = "name"
    static let description = "description"
    static let password = "password"
    static let privacy = "privacy"
}

public extension Request {
    /// Returns a new request to fetch a specific album.
    ///
    /// - Parameter uri: The album's URI.
    /// - Returns: Returns a new `Request` for an individual album.
    static func albumRequest(for uri: String) -> Request {
        return Request(path: uri)
    }

    /// Returns a new request for creating an album.
    /// - Parameter userURI: The URI for the current user, and owner of the album being created.
    /// - Parameter name: The name of the album being created.
    /// - Parameter description: An optional description for the album.
    /// - Parameter privacy: The privacy parameter as a String. If none is specified it defaults to "anyone".
    /// - Parameter password: An optional password parameter, only required when privacy is set to "password".
    static func createAlbumRequest(
        userURI: String,
        name: String,
        description: String? = nil,
        privacy: String = VIMPrivacy_Public,
        password: String? = nil
    ) -> Request {
        var parameters = [String: String]()
        parameters[Key.name] = name
        parameters[Key.description] = description
        parameters[Key.privacy] = privacy
        password.map { parameters[Key.password] = $0 }

        return Request(method: .post, path: userURI + "/albums", parameters: parameters)
    }

    /// Returns a new request for updating an exising album.
    /// - Parameter albumURI: The URI for the album that will be updated.
    /// - Parameter name: The name of the album.
    /// - Parameter description: An optional description for the album.
    /// - Parameter privacy: The privacy parameter as a String.
    /// - Parameter password: An optional password parameter, only required when the privacy is set to "password".
    static func updateAlbumRequest(
        albumURI: String,
        name: String,
        description: String? = nil,
        privacy: String?,
        password: String? = nil
    ) -> Request {
        var parameters = [String: String]()
        parameters[Key.name] = name
        parameters[Key.description] = description
        privacy.map { parameters[Key.privacy] = $0 }
        password.map { parameters[Key.password] = $0 }

        return Request(method: .patch, path: albumURI, parameters: parameters)
    }

    /// Returns a new request to delete the album for the given URI.
    /// - Parameter albumURI: The album's URI.
    static func deleteAlbumRequest(for albumURI: String) -> Request {
        return Request(method: .delete, path: albumURI)
    }
}
