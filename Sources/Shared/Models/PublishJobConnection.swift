//
//  PublishJobConnection.swift
//  VimeoNetworking
//
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

/// A `VIMConnection` subclass that includes additional data related to publishing to multiple social media platforms.
@objcMembers
public class PublishJobConnection: VIMConnection {

    /// Reasons for which this video cannot be published, split by platform.
    /// - Note: Values will return as `nil` unless a blocker is present.
    public private(set) var publishBlockers: PublishJobBlockers?

    /// Parameters describing maximum values for a video post, split by platfrom.
    /// - Note: Constraints vary by platform and are hard coded server-side.
    public private(set) var publishConstraints: PublishJobConstraints?

    /// Whether or not a post has been published, split by platform.
    public private(set) var publishDestinations: PublishJobDestinations?

    public override func getClassForObjectKey(_ key: String?) -> AnyClass? {
        switch key {
        case String.publishBlockers:
            return PublishJobBlockers.self
        case String.publishConstraints:
            return PublishJobConstraints.self
        case String.publishDestinations:
            return PublishJobDestinations.self
        default:
            return nil
        }
    }
}

/// Reasons for which this video cannot be published, split by platform.
@objcMembers
public class PublishJobBlockers: VIMModelObject {
    internal private(set) var facebookBlockers: [String]?
    internal private(set) var linkedInBlockers: [String]?
    internal private(set) var twitterBlockers: [String]?
    internal private(set) var youtubeBlockers: [String]?

    /// Current blockers that will prevent posting to Facebook. If `nil`, publishing is not blocked for this platform.
    public lazy var facebook: FacebookBlockers? = {
        return FacebookBlockers(blockers: self.facebookBlockers)
    }()

    /// Current blockers that will prevent posting to LinkedIn. If `nil`, publishing is not blocked for this platform.
    public lazy var linkedin: LinkedInBockers? = {
        return LinkedInBockers(blockers: self.linkedInBlockers)
    }()

    /// Current blockers that will prevent posting to Twitter. If `nil`, publishing is not blocked for this platform.
    public lazy var twitter: PublishBlockers? = {
        return PublishBlockers(blockers: self.twitterBlockers)
    }()

    /// Current blockers that will prevent posting to YouTube. If `nil`, publishing is not blocked for this platform.
    public lazy var youtube: YouTubeBlockers? = {
        return YouTubeBlockers(blockers: self.youtubeBlockers)
    }()

    public override func getObjectMapping() -> Any! {
        return [
            String.facebook: String.facebookBlockers,
            String.linkedin: String.linkedInBlockers,
            String.twitter: String.twitterBlockers,
            String.youtube: String.youtubeBlockers
        ]
    }
}

/// Parameters describing maximum values for a video post, split by platfrom.
/// - Note: Constraints vary by platform and are hard coded server-side.
@objcMembers
public class PublishJobConstraints: VIMModelObject {

    /// Publishing constraints for Facebook.
    public private(set) var facebook: PublishConstraints?

    /// Publishing constraints for YouTube.
    public private(set) var youtube: PublishConstraints?

    /// Publishing constraints for LinkedIn.
    public private(set) var linkedin: PublishConstraints?

    /// Publishing constraints for Twitter.
    public private(set) var twitter: PublishConstraints?

    public override func getClassForObjectKey(_ key: String?) -> AnyClass? {
        switch key {
        case String.facebook,
             String.youtube,
             String.linkedin,
             String.twitter:
            return PublishConstraints.self
        default:
            return nil
        }
    }
}

/// Whether or not a post has been published, split by platform.
@objcMembers
public class PublishJobDestinations: VIMModelObject {

    internal private(set) var publishedToFacebook: NSNumber?
    internal private(set) var publishedToLinkedIn: NSNumber?
    internal private(set) var publishedToTwitter: NSNumber?
    internal private(set) var publishedToYouTube: NSNumber?

    /// Whether the video was ever published to Facebook.
    @nonobjc public lazy var facebook: Bool = {
        return self.publishedToFacebook?.boolValue == true
    }()

    /// Whether the video was ever published to LinkedIn.
    @nonobjc public lazy var linkedin: Bool = {
        return self.publishedToLinkedIn?.boolValue == true
    }()

    /// Whether the video was ever published to Twitter.
    @nonobjc public lazy var twitter: Bool = {
        return self.publishedToTwitter?.boolValue == true
    }()

    /// Whether the video was ever published to YouTube.
    @nonobjc public lazy var youtube: Bool = {
        return self.publishedToYouTube?.boolValue == true
    }()

    public override func getObjectMapping() -> Any! {
        return [
            String.facebook: String.publishedToFacebook,
            String.linkedin: String.publishedToLinkedIn,
            String.twitter: String.publishedToTwitter,
            String.youtube: String.publishedToYouTube
        ]
    }
}

/// Reasons for which a video cannot be published.
public class PublishBlockers: VIMModelObject {
    internal private(set) var blockers: [String]?

    init?(blockers: [String]?) {
        self.blockers = blockers
        super.init()
    }

    required init?(coder: NSCoder) {
        nil
    }

    /// The file size of the video is too large for the platform.
    public lazy var size: Bool = {
        return self.blockers?.contains(.size) ?? false
    }()

    /// The duration of the video is too long for the platform.
    public lazy var duration: Bool = {
        return self.blockers?.contains(.duration) ?? false
    }()
}

/// Reasons for which a video cannot be published, specific to Facebook.
public class FacebookBlockers: PublishBlockers {

    /// The connected Facebook account has no pages. Publishing requires at least one Facebook page.
    public lazy var noPages: Bool = {
        return self.blockers?.contains(.facebookNoPages) ?? false
    }()
}

/// Reasons for which a video cannot be published, specific to LinkedIn.
public class LinkedInBockers: PublishBlockers {

    /// The connected LinkedIn account has no organizations. Pubishing requires at least one LinkedIn organization.
    public lazy var noOrganizations: Bool = {
        return self.blockers?.contains(.linkedInNoOrganizations) ?? false
    }()
}

/// Reasons for which a video cannot be published, specific to YouTube.
public class YouTubeBlockers: PublishBlockers {
    public lazy var noChannels: Bool = {
        return self.blockers?.contains(.youTubeNoChannels) ?? false
    }()
}

/// Parameters describing maximum values for a video post on a social media platform.
@objcMembers
public class PublishConstraints: VIMModelObject {

    /// The maximum time in seconds for a video to be uploaded to a platform.
    public private(set) var duration: NSNumber?

    /// The maximum file size in bytes for a video to be uploaded to a platform.
    public private(set) var size: NSNumber?
}

private extension String {
    static let size = "size"
    static let duration = "duration"
    static let facebookNoPages = "fb_no_pages"
    static let linkedInNoOrganizations = "li_no_organizations"
    static let youTubeNoChannels = "yt_no_channel"
    static let publishBlockers = "publish_blockers"
    static let publishConstraints = "publish_constraints"
    static let publishDestinations = "publish_destinations"
    static let publishedToFacebook = "publishedToFacebook"
    static let publishedToLinkedIn = "publishedToLinkedIn"
    static let publishedToTwitter = "publishedToTwitter"
    static let publishedToYouTube = "publishedToYouTube"
    static let facebookBlockers = "facebookBlockers"
    static let linkedInBlockers = "linkedInBlockers"
    static let twitterBlockers = "twitterBlockers"
    static let youtubeBlockers = "youtubeBlockers"
}
