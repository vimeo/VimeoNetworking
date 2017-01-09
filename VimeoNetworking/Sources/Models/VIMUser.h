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
@class VIMInteraction;
@class VIMPictureCollection;
@class VIMPreference;
@class VIMUploadQuota;
@class VIMUserBadge;

typedef NS_ENUM(NSInteger, VIMUserAccountType)
{
    VIMUserAccountTypeBasic = 0,
    VIMUserAccountTypePro,
    VIMUserAccountTypePlus,
    VIMUserAccountTypeBusiness
};

@interface VIMUser : VIMModelObject

@property (nonatomic, assign, readonly) VIMUserAccountType accountType;
@property (nonatomic, strong, nullable) VIMUserBadge *badge;
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
@property (nonatomic, copy, nullable) NSString *account;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

- (BOOL)hasCopyrightMatch;
- (BOOL)isFollowing;

- (nullable NSString *)accountTypeAnalyticsIdentifier;

@end
