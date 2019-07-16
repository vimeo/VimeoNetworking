//
//  VIMUser.h
//  VimeoNetworking
//
//  Created by Kashif Mohammad on 4/4/13.
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

@class VIMConnection;
@class VIMNotificationsConnection;
@class VIMInteraction;
@class VIMPictureCollection;
@class VIMPreference;
@class VIMUploadQuota;
@class VIMUserBadge;
@class VIMLiveQuota;
@class UserMembership;

typedef NS_ENUM(NSInteger, VIMUserAccountType);

@interface VIMUser : VIMModelObject


@property (nonatomic, assign, readonly) VIMUserAccountType accountType;

/// Object storing information about the badge to display for the user's account type
/// DEPRECATED: Use membership.badge instead
/// - seealso: UserMembership
//@property (nonatomic, strong, nullable) VIMUserBadge *badge;

@property (nonatomic, copy, nullable) NSString *bio;
@property (nonatomic, copy, nullable) NSArray *contentFilter;
@property (nonatomic, strong, nullable) NSDate *createdTime;
@property (nonatomic, strong, nullable) NSDate *modifiedTime; // This doesn't exist on user objects...yet [AH]
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *location;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, strong, nullable) id stats;
@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) NSArray *websites;
@property (nonatomic, strong, nullable) NSArray *userEmails;
@property (nonatomic, strong, nullable) VIMPreference *preferences;
@property (nonatomic, strong, nullable) VIMUploadQuota *uploadQuota;

/// A string representation of the user's account type, not to be used for display purposes.
/// DEPRECATED: use membership.type instead for this information, use membership.display for a non-localized string for use in UI displays,
/// Note: It is better to use the accountType property to retrieve an enum value representing the user's account type rather than working with the string representations directly.
/// -seealso: UserMembership
//@property (nonatomic, copy, nullable) NSString *account;

@property (nonatomic, strong, nullable) VIMLiveQuota *liveQuota;
@property (nonatomic, strong, nullable) UserMembership *membership;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMNotificationsConnection *)notificationsConnection;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

- (BOOL)isFollowing;
- (BOOL)hasModeratedChannels;

- (nullable NSString *)accountTypeAnalyticsIdentifier;
- (BOOL)hasSameBadgeCount:(nullable VIMUser *)newUser;

/// @brief Method for determining whether or not the user has ever had a free trial on Vimeo.
/// @return true if the user has ever been in a free trial, otherwise it will return false
/// @attention THIS METHOD IS FOR VIMEO INTERNAL USE ONLY
- (BOOL)hasBeenInFreeTrial;

@end
