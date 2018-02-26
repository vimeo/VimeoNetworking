//
//  VIMInteraction.h
//  VimeoNetworking
//
//  Created by Kashif Muhammad on 9/23/14.
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

// Interaction names

extern NSString * const __nonnull VIMInteractionNameWatchLater;
extern NSString * const __nonnull VIMInteractionNameFollow;
extern NSString * const __nonnull VIMInteractionNameLike;
extern NSString * const __nonnull VIMInteractionNameBuy;
extern NSString * const __nonnull VIMInteractionNameRent;
extern NSString * const __nonnull VIMInteractionNameSubscribe;
extern NSString * const __nonnull VIMInteractionNamePurchase;

typedef NS_ENUM(NSInteger, VIMInteractionStreamStatus) {
    VIMInteractionStreamStatusUnavailable = 0,      // user cannot purchase
    VIMInteractionStreamStatusPurchased,            // user has purchased
    VIMInteractionStreamStatusRestricted,           // user cannot purchase in this geographic region
    VIMInteractionStreamStatusAvailable             // user can purchase but has not yet
};

@interface VIMInteraction : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) NSNumber *added;
@property (nonatomic, strong, nullable) NSDate *addedTime;

@property (nonatomic, strong, nullable) NSString *status;

# pragma mark - VOD related only
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *download;
@property (nonatomic, strong, nullable) NSDate *expirationDate;
@property (nonatomic, strong, nullable) NSDate *purchaseDate;
@property (nonatomic, assign) VIMInteractionStreamStatus streamStatus;

# pragma mark - DRM

/**
 Indicates whether this VIMInteraction (to buy, rent, or subscribe) relates to content that is protected by DRM.
 Returns true if buying, renting, or subscribing to the related content will be governed by DRM.
 */
@property (nonatomic, assign, readonly) BOOL isForDRMProtectedContent;

@end
