//
//  VIMVideo.m
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

#import <VimeoNetworking/VimeoNetworking-Swift.h>
#import "VIMVideo.h"
#import "VIMObjectMapper.h"
#import "VIMUser.h"
#import "VIMPicture.h"
#import "VIMVideoFile.h"
#import "VIMConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMPrivacy.h"
#import "VIMAppeal.h"
#import "VIMTag.h"
#import "VIMCategory.h"
#import "VIMVideoPlayRepresentation.h"
#import "VIMVideoDRMFiles.h"

NSString *VIMContentRating_Language = @"language";
NSString *VIMContentRating_Drugs = @"drugs";
NSString *VIMContentRating_Violence = @"violence";
NSString *VIMContentRating_Nudity = @"nudity";
NSString *VIMContentRating_Unrated = @"unrated";
NSString *VIMContentRating_Safe = @"safe";

@interface VIMVideo ()

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSDictionary *interactions;

@end

@implementation VIMVideo

#pragma mark - Accessors

#pragma mark - Public API

- (VIMConnection *)connectionWithName:(NSString *)connectionName
{
    return [self.connections objectForKey:connectionName];
}

- (VIMInteraction *)interactionWithName:(NSString *)name
{
    return [self.interactions objectForKey:name];
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping {
    return @{
        @"description": @"videoDescription",
        @"pictures": @"pictureCollection",
        @"play": @"playRepresentation",
        @"review_page": @"reviewPage",
        @"file_transfer": @"fileTransfer",
        @"app": @"sourceClientApp",
        @"publish_to_social": @"publishJobConnection"
    };
}

- (Class)getClassForCollectionKey:(NSString *)key
{
    if([key isEqualToString:@"files"])
        return [VIMVideoFile class];
    
    if ([key isEqualToString:@"tags"])
        return [VIMTag class];
    
    if ([key isEqualToString:@"categories"])
        return [VIMCategory class];
    
	return nil;
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"pictures"])
    {
        return [VIMPictureCollection class];
    }

    if ([key isEqualToString:@"user"])
    {
        return [VIMUser class];
    }

	if ([key isEqualToString:@"metadata"])
    {
        return [NSMutableDictionary class];
    }

    if ([key isEqualToString:@"privacy"])
    {
        return [VIMPrivacy class];
    }
    
    if ([key isEqualToString:@"appeal"])
    {
        return [VIMAppeal class];
    }
    
    if ([key isEqualToString:@"play"])
    {
        return [VIMVideoPlayRepresentation class];
    }
    
    if ([key isEqualToString:@"badge"])
    {
        return [VIMBadge class];
    }
    
    if ([key isEqualToString:@"spatial"])
    {
        return [Spatial class];
    }
    
    if ([key isEqualToString:@"live"])
    {
        return [VIMLive class];
    }
    
    if ([key isEqualToString:@"review_page"])
    {
        return [VIMReviewPage class];
    }
    
    if ([key isEqualToString:@"upload"])
    {
        return [VIMUpload class];
    }
    
    if ([key isEqualToString:@"file_transfer"])
    {
        return [FileTransfer class];
    }

    if ([key isEqualToString:@"app"])
    {
        return [APIClientApp class];
    }

    if ([key isEqualToString:@"publish_to_social"])
    {
        return [PublishJobConnection class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if ([self.pictureCollection isEqual:[NSNull null]])
    {
        self.pictureCollection = nil;
    }

    // This is a temporary fix until we implement model versioning for cached JSON [AH]
    [self checkIntegrityOfPictureCollection];

    [self parseConnections];
    [self parseInteractions];
    [self parsePublishJobConnection];
    [self formatCreatedTime];
    [self formatReleaseTime];
    [self formatModifiedTime];
    
    id ob = [self.stats valueForKey:@"plays"];
    if (ob && [ob isKindOfClass:[NSNumber class]])
    {
        self.numPlays = ob;
    }
    
    [self setVideoStatus];
}

#pragma mark - Model Validation

- (BOOL)validateModel:(NSError *__autoreleasing *)error
{
    if ([super validateModel:error] == NO)
    {
        return NO;
    }
    
    if (self.uri == nil)
    {
        NSString *description = @"VIMVideo failed validation: uri cannot be nil";
        *error = [NSError errorWithDomain:VIMModelObjectErrorDomain code:VIMModelObjectValidationErrorCode userInfo:@{NSLocalizedDescriptionKey: description}];
        
        return NO;
    }
    
    if (self.resourceKey == nil)
    {
        NSString *description = @"VIMVideo failed validation: resourceKey cannot be nil";
        *error = [NSError errorWithDomain:VIMModelObjectErrorDomain code:VIMModelObjectValidationErrorCode userInfo:@{NSLocalizedDescriptionKey: description}];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Model Versioning

// This is only called for unarchived model objects [AH]

- (void)upgradeFromModelVersion:(NSUInteger)fromVersion toModelVersion:(NSUInteger)toVersion withCoder:(NSCoder *)aDecoder
{
    if (fromVersion == 2 && toVersion == 3)
    {
        [self checkIntegrityOfPictureCollection];
    }
}

- (void)checkIntegrityOfPictureCollection
{
    if ([self.pictureCollection isKindOfClass:[NSArray class]])
    {
        NSArray *pictures = (NSArray *)self.pictureCollection;
        self.pictureCollection = [VIMPictureCollection new];
        
        if ([pictures count])
        {
            if ([[pictures firstObject] isKindOfClass:[VIMPicture class]])
            {
                self.pictureCollection.pictures = pictures;
            }
            else if ([[pictures firstObject] isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *pictureObjects = [NSMutableArray array];
                for (NSDictionary *dictionary in pictures)
                {
                    VIMPicture *picture = [[VIMPicture alloc] initWithKeyValueDictionary:dictionary];
                    [pictureObjects addObject:picture];
                }
                
                self.pictureCollection.pictures = pictureObjects;
            }
        }
    }
}

#pragma mark - Parsing Helpers

- (void)parseConnections
{
    NSMutableDictionary *connections = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:@"connections"];
    if([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if([value isKindOfClass:[NSDictionary class]])
            {
                VIMConnection *connection = [[VIMConnection alloc] initWithKeyValueDictionary:value];
                if([connection respondsToSelector:@selector(didFinishMapping)])
                    [connection didFinishMapping];

                [connections setObject:connection forKey:key];
            }
        }
    }
    
    self.connections = connections;
}

- (void)parsePublishJobConnection
{
    NSDictionary *dictionary = [[self.metadata valueForKey:@"connections"] valueForKey:@"publish_to_social"];
    if (dictionary != nil) {
        VIMObjectMapper *mapper = [[VIMObjectMapper alloc] init];
        [mapper addMappingClass: [PublishJobConnection class] forKeypath:@""];
        self.publishJobConnection = [mapper applyMappingToJSON:dictionary];
    }
}

- (void)parseInteractions
{
    NSMutableDictionary *interactions = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:@"interactions"];
    if([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if([value isKindOfClass:[NSDictionary class]])
            {
                VIMInteraction *interaction = [[VIMInteraction alloc] initWithKeyValueDictionary:value];
                if([interaction respondsToSelector:@selector(didFinishMapping)])
                    [interaction didFinishMapping];
                
                [interactions setObject:interaction forKey:key];
            }
        }
    }
    
    self.interactions = interactions;
}

- (void)formatReleaseTime
{
    if ([self.releaseTime isKindOfClass:[NSString class]])
    {
        self.releaseTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.releaseTime];
    }
}

- (void)formatCreatedTime
{
    if ([self.createdTime isKindOfClass:[NSString class]])
    {
        self.createdTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.createdTime];
    }
}

- (void)formatModifiedTime
{
    if ([self.modifiedTime isKindOfClass:[NSString class]])
    {
        self.modifiedTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.modifiedTime];
    }
}

- (void)setVideoStatus
{
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusUnavailable], @"unavailable",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusAvailable], @"available",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusUploading], @"uploading",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusTranscoding], @"transcoding",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusTranscodeStarting], @"transcode_starting",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusUploadingError], @"uploading_error",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusTranscodingError], @"transcoding_error",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusQuotaExceeded], @"quota_exceeded",
                                      [NSNumber numberWithInt:VIMVideoProcessingStatusTotalCapExceeded], @"total_cap_exceeded",
                                      nil];
    
    NSNumber *number = [statusDictionary objectForKey:self.status];
    
    NSAssert(number != nil, @"Video status not handled, unknown video status");
    
    self.videoStatus = [number intValue];
}

# pragma mark - Helpers

- (BOOL)canComment
{
    NSString *privacy = self.privacy.comments;
    if( [privacy isEqualToString:VIMPrivacy_Public] )
    {
        return YES;
    }
    else if( [privacy isEqualToString:VIMPrivacy_Private] )
    {
        return NO;
    }
    else
    {
        VIMConnection *connection = [self connectionWithName:VIMConnectionNameComments];
        
        return (connection && [connection canPost]);
    }
}

- (BOOL)canLike
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameLike];
    
    return interaction && [interaction.uri length];
}

- (BOOL)canViewComments
{
    return [self connectionWithName:VIMConnectionNameComments].uri != nil;
}

- (BOOL)isPrivate
{
    NSString *privacy = self.privacy.view;
    return ![privacy isEqualToString:VIMPrivacy_Public] && ![privacy isEqualToString:VIMPrivacy_VOD] && ![privacy isEqualToString:VIMPrivacy_Stock];
}

- (BOOL)isAvailable
{
    return self.videoStatus == VIMVideoProcessingStatusAvailable;
}

- (BOOL)isTranscoding
{
    return self.videoStatus == VIMVideoProcessingStatusTranscoding || self.videoStatus == VIMVideoProcessingStatusTranscodeStarting;
}

- (BOOL)isUploading
{
    return self.videoStatus == VIMVideoProcessingStatusUploading;
}

- (BOOL)isStock
{
    NSString *privacy = self.privacy.view;
    return [privacy isEqualToString:VIMPrivacy_Stock];
}

// New

- (void)setIsLiked:(BOOL)isLiked
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameLike];
    interaction.added = @(isLiked);
    
    [self.interactions setValue:interaction forKey:VIMInteractionNameLike];
}

- (void)setIsWatchLater:(BOOL)isWatchLater
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameWatchLater];
    interaction.added = @(isWatchLater);
    
    [self.interactions setValue:interaction forKey:VIMInteractionNameWatchLater];
}

- (BOOL)isLiked
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameLike];
    
    return interaction.added.boolValue;
}

- (BOOL)isWatchLater
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameWatchLater];

    return interaction.added.boolValue;
}

- (BOOL)isRatedAllAudiences
{
    NSString *contentRating = [self singleContentRatingIfAvailable];
    
    return [contentRating isEqualToString:VIMContentRating_Safe];
}

- (BOOL)isNotYetRated
{
    NSString *contentRating = [self singleContentRatingIfAvailable];
    
    return [contentRating isEqualToString:VIMContentRating_Unrated];
}

- (BOOL)isRatedMature
{
    NSString *contentRating = [self singleContentRatingIfAvailable];
    
    return ![contentRating isEqualToString:VIMContentRating_Unrated] && ![contentRating isEqualToString:VIMContentRating_Safe];
}

- (BOOL)isDRMProtected
{
    if (self.playRepresentation.drmFiles.fairPlayFile)
    {
        return YES;
    }

    // The following only applies to VIMVideos with VOD metadata.
    // If the VOD item that this VIMVideo represents (through purchase, rental, or subscription) is proteceted by DRM,
    // we consider this VIMVideo to be protected by DRM [ghking] 2/8/17 cc [jasonhawkins]
    
    VIMInteraction *buyInteraction = [self interactionWithName:VIMInteractionNameBuy];
    BOOL isBuyDRMProtected = buyInteraction.isForDRMProtectedContent;
    
    VIMInteraction *rentInteraction = [self interactionWithName:VIMInteractionNameRent];
    BOOL isRentDRMProtected = rentInteraction.isForDRMProtectedContent;
    
    VIMInteraction *subscribeInteraction = [self interactionWithName:VIMInteractionNameSubscribe];
    BOOL isSubscribeDRMProtected = subscribeInteraction.isForDRMProtectedContent;
    
    return isBuyDRMProtected || isRentDRMProtected || isSubscribeDRMProtected;
}

- (NSString *)singleContentRatingIfAvailable
{
    NSString *contentRating = nil;
    
    if (self.contentRating)
    {
        if ([self.contentRating isKindOfClass:[NSArray class]])
        {
            if ([self.contentRating count] == 1)
            {
                contentRating = [self.contentRating firstObject];
            }
        }
        else if ([self.contentRating isKindOfClass:[NSString class]])
        {
            contentRating = (NSString *)self.contentRating;
        }
    }
    
    return contentRating;
}

- (NSInteger)likesCount
{
    VIMConnection *likesConnection = [self connectionWithName:VIMConnectionNameLikes];
    
    return likesConnection.total.intValue;
}

- (NSInteger)commentsCount
{
    VIMConnection *commentsConnection = [self connectionWithName:VIMConnectionNameComments];

    return (self.canViewComments ? commentsConnection.total.intValue : 0);
}

- (BOOL)is360
{
    return self.spatial != nil;
}

- (BOOL)isLive
{
    return self.live != nil;
}

- (BOOL)isLiveEventInProgress
{
    return self.live != nil && (self.isPreBroadcast || self.isMidBroadcast || self.isArchivingBroadcast);
}

- (BOOL)isPreBroadcast
{
    return self.isLive && ([self.live.status isEqual: VIMLive.LiveStreamStatusUnavailable] || [self.live.status isEqual: VIMLive.LiveStreamStatusReady] || [self.live.status isEqual: VIMLive.LiveStreamStatusPending]);
}

- (BOOL)isMidBroadcast
{
    return self.isLive && [self.live.status isEqual: VIMLive.LiveStreamStatusStreaming];
}

- (BOOL)isArchivingBroadcast
{
    return self.isLive && [self.live.status isEqualToString:VIMLive.LiveStreamStatusArchiving];
}

- (BOOL)isPostBroadcast
{
    return self.isLive && ([self.live.status isEqual: VIMLive.LiveStreamStatusDone]);
}

- (BOOL)hasReviewPage
{
    NSString *trimmedReviewLink = [self.reviewPage.link stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return  self.reviewPage != nil &&
            self.reviewPage.isActive.boolValue == true &&
            self.reviewPage.link != nil &&
            trimmedReviewLink.length > 0;
}

- (BOOL)canDownloadFromDesktop
{
    if ([self.privacy.canDownload respondsToSelector: @selector(boolValue)])
    {
        return [self.privacy.canDownload boolValue];
    }
    
    NSAssert(false, @"`video.privacy.canDownload` is an unexpected type.");
    return false;
}

- (BOOL)allowsFileTransfer
{
    return self.fileTransfer != nil && self.fileTransfer.url != nil && [self canDownloadFromDesktop] == YES;
}

@end
