//
//  VIMNotification.h
//  Pods
//
//  Created by Fiel Guhit on 1/20/17.
//  Copyright (c) 2014-2017 Vimeo (https://vimeo.com)
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

@class VIMComment;
@class VIMVideo;
@class VIMCredit;
@class VIMUser;

typedef NS_ENUM(NSUInteger, VIMNotificationType) {
    VIMNotificationTypeNone = 0,
    VIMNotificationTypeComment,
    VIMNotificationTypeCredit,
    VIMNotificationTypeFollow,
    VIMNotificationTypeLike,
    VIMNotificationTypeReply,
    VIMNotificationTypeVideoAvailable, // User new video available
    VIMNotificationTypeFollowedUserVideoAvailable // Followed user new video available
};

@interface VIMNotification : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, nullable) NSDate *createdTime;
@property (nonatomic) BOOL new;
@property (nonatomic) BOOL seen;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, nullable) VIMComment *comment;
@property (nonatomic, nullable) VIMVideo *video;
@property (nonatomic, nullable) VIMCredit *credit;
@property (nonatomic, nullable) VIMUser *user;

@property (nonatomic) VIMNotificationType notificationType;

+ (nonnull NSDictionary<NSString *, NSNumber *> *)supportedTypeMap;

@property (nonatomic, strong, nullable) NSNumber *typeUnseenCount;

@end
