//
//  Request+Teams.swift
//  VimeoNetworking
//
//  Created by Song, Alexander on 10/1/19.
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

public extension Request {

    /// Returns a new request to fetch an array of team members.
    /// - Parameter uri: The team member's URI.
    /// - Parameter hasAccessOnly: Flag that determines the set of players to be returned. When `true` it returns only
    /// the list of players added to the folder. When `false` returns all team members.
    /// - Parameter filterString: The filter string to be applied to the fields request parameter.
    static func getTeamMembers(
        forURI uri: String,
        hasAccessOnly: Bool? = nil,
        filterString: String? = nil
    ) -> Request {
        let hasAccessOnlyPair = hasAccessOnly.map { "\(String.hasAccessOnly)=\($0)" }
        let filterStringPair = filterString.map { "\(String.fieldsKey)=\($0)" }
        let parametersString = [
            hasAccessOnlyPair,
            filterStringPair
        ]
        .compactMap { $0 }
        .joined(separator: "&" )
        let path = [
            uri,
            parametersString
        ]
        .joined(separator: "?")
        return Request(path: path)
    }
}

// MARK: - Constants

private extension String {
    static let hasAccessOnly = "has_access_only"
    static let fieldsKey = "fields"
}
