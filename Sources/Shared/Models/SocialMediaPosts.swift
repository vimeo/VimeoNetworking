//
//  SocialMediaPosts.swift
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

/// A structure representing a single post to Facebook.
public struct PublishToFacebookPost {

    /// The title of the post as it will appear on Facebook.
    public let title: String?

    /// The description of the post as it will appear on Facebook.
    public let description: String?

    /// The identifier of the Facebook page being posted to.
    public let destination: Int

    /// The Facebook category of the video. May be `nil`.
    public let categoryID: String?

    /// Whether or not this Facbeook post should be embeddable.
    public let allowEmbedding: Bool

    /// Whether or not this post should appear on the Facebook News Feed.
    public let shouldAppearOnNewsFeed: Bool

    /// Whether or not this video should be searchable and show up in the user's video library on Facebook.
    public let isSecretVideo: Bool

    /// Whether or not to allow social actions on the post on Facebook.
    public let allowSocialActions: Bool

    public init(
        title: String? = nil,
        description: String? = nil,
        destination: Int,
        categoryID: String? = nil,
        allowEmbedding: Bool,
        shouldAppearOnNewsFeed: Bool,
        isSecretVideo: Bool,
        allowSocialActions: Bool
    ) {
        self.title = title
        self.description = description
        self.destination = destination
        self.categoryID = categoryID
        self.allowEmbedding = allowEmbedding
        self.shouldAppearOnNewsFeed = shouldAppearOnNewsFeed
        self.isSecretVideo = isSecretVideo
        self.allowSocialActions = allowSocialActions
    }
}

/// A structure representing a single post to LinkedIn.
public struct PublishToLinkedInPost {

    /// The LinkedIn page identifier that the video will be posted to.
    public let pageID: Int

    /// The title of the post as it will appear on LinkedIn.
    public let title: String

    /// The description of the post as it will appear on LinkedIn. May be `nil`.
    public let description: String?

    public init(
        pageID: Int,
        title: String,
        description: String? = nil
    ) {
        self.pageID = pageID
        self.title = title
        self.description = description
    }
}

/// A structure representing a single tweet on Twitter.
public struct PublishToTwitterPost {

    /// The contents of the tweet as it will appear on Twitter.
    public let tweet: String

    public init(tweet: String) {
        self.tweet = tweet
    }
}

/// A structure representing a single post to YouTube.
public struct PublishToYouTubePost {

    /// The privacy options available when sharing a video to YouTube.
    /// - public: The video will be publically available.
    /// - private: The video will not be publically available, and only viewable to the owner.
    public enum Privacy: String, CaseIterable {
        case `public`
        case `private`
    }

    /// The title of the video as it will appear on YouTube.
    public let title: String

    /// The description of the video as it will appear on YouTube. May be `nil`.
    public let description: String?

    /// A list of tags for the video on YouTube. May be `nil`.
    public let tags: [String]?

    /// The privacy option for this video on YouTube.
    public let privacy: Privacy

    /// The YouTube category identifier which this video falls into.
    public let categoryID: String?

    public init(
        title: String,
        description: String? = nil,
        tags: [String]? = nil,
        privacy: Privacy,
        categoryID: String? = nil
    ) {
        self.title = title
        self.description = description
        self.tags = tags
        self.privacy = privacy
        self.categoryID = categoryID
    }
}

/// A structure encapsulating publishing data for each of the supported social media platforms.
public struct SocialMediaPosts {

    /// A single post to Facebook.
    public var facebook: PublishToFacebookPost? = nil

    /// A single post to LinkedIn.
    public var linkedIn: PublishToLinkedInPost? = nil

    /// A single post to Twitter.
    public var twitter: PublishToTwitterPost? = nil

    /// A single post to YouTube.
    public var youTube: PublishToYouTubePost? = nil

    public init(
        facebook: PublishToFacebookPost? = nil,
        linkedIn: PublishToLinkedInPost? = nil,
        twitter: PublishToTwitterPost? = nil,
        youTube: PublishToYouTubePost? = nil
    ) {
        self.facebook = facebook
        self.linkedIn = linkedIn
        self.twitter = twitter
        self.youTube = youTube
    }
}
