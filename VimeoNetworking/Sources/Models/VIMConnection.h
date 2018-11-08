//
//  VIMConnection.h
//  VimeoNetworking
//
//  Created by Kashif Muhammad on 6/16/14.
//  Copyright (c) 2014-2015 Vimeo (https://vimeo.com)
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

#import "VIMModelObject.h"

// Connection names

extern NSString *const __nonnull VIMConnectionNameActivities;
extern NSString *const __nonnull VIMConnectionNameAlbums;
extern NSString *const __nonnull VIMConnectionNameChannels;
extern NSString *const __nonnull VIMConnectionNameCategories;
extern NSString *const __nonnull VIMConnectionNameRelated;
extern NSString *const __nonnull VIMConnectionNameRecommendations;
extern NSString *const __nonnull VIMConnectionNameComments;
extern NSString *const __nonnull VIMConnectionNameReplies;
extern NSString *const __nonnull VIMConnectionNameCovers;
extern NSString *const __nonnull VIMConnectionNameCredits;
extern NSString *const __nonnull VIMConnectionNameFeed;
extern NSString *const __nonnull VIMConnectionNameFollowers;
extern NSString *const __nonnull VIMConnectionNameFollowing;
extern NSString *const __nonnull VIMConnectionNameUsers;
extern NSString *const __nonnull VIMConnectionNameGroups;
extern NSString *const __nonnull VIMConnectionNameLikes;
extern NSString *const __nonnull VIMConnectionNamePictures;
extern NSString *const __nonnull VIMConnectionNamePortfolios;
extern NSString *const __nonnull VIMConnectionNameShared;
extern NSString *const __nonnull VIMConnectionNameVideos;
extern NSString *const __nonnull VIMConnectionNameWatchlater;
extern NSString *const __nonnull VIMConnectionNameWatchedVideos;
extern NSString *const __nonnull VIMConnectionNameViolations;
extern NSString *const __nonnull VIMConnectionNameVODItem;
extern NSString *const __nonnull VIMConnectionNameVODTrailer;
extern NSString *const __nonnull VIMConnectionNameVODSeasons;
extern NSString *const __nonnull VIMConnectionNameRecommendedChannels;
extern NSString *const __nonnull VIMConnectionNameRecommendedUsers;
extern NSString *const __nonnull VIMConnectionNameModeratedChannels;
extern NSString *const __nonnull VIMConnectionNameContents;
extern NSString *const __nonnull VIMConnectionNameNotifications;
extern NSString *const __nonnull VIMConnectionNameBlockUser;
extern NSString *const __nonnull VIMConnectionNameLiveStats;
extern NSString *const __nonnull VIMConnectionNameUploadAttempt;

@interface VIMConnection : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) NSNumber *total;
@property (nonatomic, strong, nullable) NSArray *options;

- (BOOL)canGet;
- (BOOL)canPost;

@end
