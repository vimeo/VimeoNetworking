//
//  VIMVideo+VOD.h
//  Vimeo
//
//  Created by Lehrer, Nicole on 5/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

#import "VIMVideo.h"

typedef NS_ENUM(NSUInteger, VIMVideoVODAccess) {
    VIMVideoVODAccessBought,
    VIMVideoVODAccessRented,
    VIMVideoVODAccessSubscribed,
    VIMVideoVODAccessUnavailable
};

@interface VIMVideo (VOD)

- (BOOL)isVOD;
- (BOOL)isVODTrailer;
- (VIMVideoVODAccess)vodAccess;
- (NSDate * _Nullable)expirationDateForAccess:(VIMVideoVODAccess)access;
- (NSString * _Nullable)vodTrailerURI;

@end
