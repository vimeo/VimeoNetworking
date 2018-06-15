//
//  VIMVideo.h
//  VimeoNetworking
//
//  Created by Kashif Mohammad on 3/23/13.
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

@class VIMUser;
@class VIMVideoFile;
@class VIMConnection;
@class VIMPictureCollection;
@class VIMInteraction;
@class VIMPrivacy;
@class VIMAppeal;
@class VIMVideoPlayRepresentation;
@class VIMBadge;
@class Spatial;
@class VIMLive;
@class VIMReviewPage;
@class VIMUpload;

extern NSString * __nonnull VIMContentRating_Language;
extern NSString * __nonnull VIMContentRating_Drugs;
extern NSString * __nonnull VIMContentRating_Violence;
extern NSString * __nonnull VIMContentRating_Nudity;
extern NSString * __nonnull VIMContentRating_Unrated;
extern NSString * __nonnull VIMContentRating_Safe;

typedef NS_ENUM(NSUInteger, VIMVideoProcessingStatus) {
    VIMVideoProcessingStatusUnavailable,
    VIMVideoProcessingStatusAvailable,
    VIMVideoProcessingStatusUploading,
    VIMVideoProcessingStatusTranscodeStarting, // New state added to API 11/18/2015 with in-app support added 2/11/2016 [AH]
    VIMVideoProcessingStatusTranscoding,
    VIMVideoProcessingStatusUploadingError,
    VIMVideoProcessingStatusTranscodingError,
    VIMVideoProcessingStatusQuotaExceeded,
    VIMVideoProcessingStatusTotalCapExceeded
};

@interface VIMVideo : VIMModelObject

@property (nonatomic, copy, nullable) NSArray *contentRating;
@property (nonatomic, strong, nullable) NSDate *createdTime;
@property (nonatomic, strong, nullable) NSDate *releaseTime;
@property (nonatomic, strong, nullable) NSDate *modifiedTime;
@property (nonatomic, copy, nullable) NSString *videoDescription;
@property (nonatomic, strong, nullable) NSNumber *duration;
@property (nonatomic, strong, nullable) NSArray *files;
@property (nonatomic, strong, nullable) VIMVideoPlayRepresentation *playRepresentation;
@property (nonatomic, strong, nullable) NSNumber *width;
@property (nonatomic, strong, nullable) NSNumber *height;
@property (nonatomic, copy, nullable) NSString *license;
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, strong, nullable) NSDictionary *stats;
@property (nonatomic, strong, nullable) NSArray *tags;
@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, copy, nullable) NSString *resourceKey;
@property (nonatomic, strong, nullable) VIMUser *user;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, strong, nullable) VIMAppeal *appeal;
@property (nonatomic, strong, nullable) VIMPrivacy *privacy;
@property (nonatomic, strong, nullable) NSNumber *numPlays;
@property (nonatomic, strong, nullable) NSArray *categories;
@property (nonatomic, copy, nullable) NSString *password;
@property (nonatomic, strong, nullable) VIMBadge *badge;
@property (nonatomic, strong, nullable) Spatial *spatial;
@property (nonatomic, strong, nullable) VIMLive *live;
@property (nonatomic, strong, nullable) VIMReviewPage *reviewPage;
@property (nonatomic, strong, nullable) VIMUpload *upload;

@property (nonatomic, assign) VIMVideoProcessingStatus videoStatus;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

// Helpers

- (BOOL)canComment;
- (BOOL)canLike;
- (BOOL)canViewComments;
- (BOOL)isPrivate;
- (BOOL)isAvailable;
- (BOOL)isTranscoding;
- (BOOL)isUploading;

- (BOOL)isLiked;
- (BOOL)isWatchLater;
- (BOOL)isRatedAllAudiences;
- (BOOL)isNotYetRated;
- (BOOL)isRatedMature;
- (BOOL)isDRMProtected;
- (NSInteger)likesCount;
- (NSInteger)commentsCount;

/**
 Checks for the existence of a Spatial object on this VIMVideo and returns @p true if one exists.
 
 @return Returns @p true if a Spatial object exists for this VIMVideo.
 */
- (BOOL)is360;

/**
 Checks for the existence of a VIMLive object on this VIMVideo and returns @p true if one exists, but does not check the state of the live event.

 @return Returns @p true if a VIMLive object exists for this VIMVideo.
 */
- (BOOL)isLive;

/**
 Determines whether the current video represents a live event and if the event is in the pre, mid, or archiving state indicating that a live event is currently underway.

 @return Returns @p true if the live video's broadcast is about to begin, is underway, or is being archived. Returns @p false if the live video's broadcast has already been archived.
 */
- (BOOL)isLiveEventInProgress;

/**
 Determines whether the current video represents a live event and whether or not the broadcast has started.

 @return Returns @p true if the live video's broadcast has not begun.
 */
- (BOOL)isPreBroadcast;

/**
 Determines whether the current video represents a live event and if the broadcast is underway.

 @return Returns @p true when the live video's broadcast is underway.
 */
- (BOOL)isMidBroadcast;

/**
 Determines whether the current video represents a live event that is in the process of being archived.

 @return Returns @p true when the live video's broadcast has ended and is being archived.
 */
- (BOOL)isArchivingBroadcast;

/**
 Determines whether the current video represents a live event, whether it has ended, and if an archive of the broadcast is ready for playback.

 @return Returns @p true when the live video event has ended and an archive of the broadcast is available.
 */
- (BOOL)isPostBroadcast;

- (void)setIsLiked:(BOOL)isLiked;
- (void)setIsWatchLater:(BOOL)isWatchLater;
- (BOOL)hasReviewPage;
- (BOOL)canDownloadFromDesktop;

@end
