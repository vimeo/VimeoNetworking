//
//  VIMAlbum.h
//  TennisLockerPro
//
//  Created by Miroslav Kutak on 07/01/2018.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

#import <VimeoNetworking/VimeoNetworking.h>

@class VIMPictureCollection;
@class VIMPrivacy;
@class VIMUser;
@class VIMConnection;
@class VIMInteraction;

@interface VIMAlbum : VIMModelObject

@property (nonatomic, strong, nullable) NSDate *createdTime;
@property (nonatomic, strong, nullable) NSDate *modifiedTime;
@property (nonatomic, copy, nullable) NSString *channelDescription;
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *duration;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, strong, nullable) VIMPictureCollection *headerPictureCollection;
@property (nonatomic, strong, nullable) VIMPrivacy *privacy;
@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) VIMUser *user;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

- (BOOL)isFollowing;

@end

/*
 created_time
 description
 duration
 link
 metadata
 modified_time
 name
 pictures
 privacy
 uri
 user
 */
