//
//  VIMInteraction.m
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

#import "VIMInteraction.h"

// Interaction names

NSString * const VIMInteractionNameWatchLater = @"watchlater";
NSString * const VIMInteractionNameFollow = @"follow";
NSString * const VIMInteractionNameLike = @"like";
NSString * const VIMInteractionNameBuy = @"buy";
NSString * const VIMInteractionNameRent = @"rent";
NSString * const VIMInteractionNameSubscribe = @"subscribe";
NSString * const VIMInteractionNamePurchase = @"purchase";

@interface VIMInteraction()
@property (nonatomic, copy, nullable) NSString *added_time;
@property (nonatomic, copy, nullable) NSString *expires_time;
@property (nonatomic, copy, nullable) NSString *purchase_time;
@property (nonatomic, copy, nullable) NSString *stream;
@property (nonatomic, assign) BOOL drm;
@property (nonatomic, assign, readwrite) BOOL isForDRMProtectedContent;
@end

@implementation VIMInteraction

#pragma mark - VIMMappable

- (void)didFinishMapping
{
    if ([self.added_time isKindOfClass:[NSString class]])
    {
        self.addedTime = [[VIMModelObject dateFormatter] dateFromString:self.added_time];
    }
    
    if ([self.expires_time isKindOfClass:[NSString class]])
    {
        self.expirationDate = [[VIMModelObject dateFormatter] dateFromString:self.expires_time];
    }
    
    if ([self.purchase_time isKindOfClass:[NSString class]])
    {
        self.purchaseDate = [[VIMModelObject dateFormatter] dateFromString:self.purchase_time];
    }
    
    self.isForDRMProtectedContent = self.drm;
    
    // Not every interaction has a stream status, only buy, rent, subscribe [NL] 05/22/16
    if (self.stream != nil)
    {
        [self setStreamStatus];
    }
}

#pragma mark - Parsing Helpers

- (void)setStreamStatus
{
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:VIMInteractionStreamStatusPurchased], @"purchased",
                                      [NSNumber numberWithInt:VIMInteractionStreamStatusRestricted], @"restricted",
                                      [NSNumber numberWithInt:VIMInteractionStreamStatusAvailable], @"available",
                                      [NSNumber numberWithInt:VIMInteractionStreamStatusUnavailable], @"unavailable",
                                      nil];
    
    NSNumber *number = [statusDictionary objectForKey:self.stream];
    
    NSAssert(number != nil, @"VOD video stream status not handled, unknown stream status");
    
    self.streamStatus = [number intValue];
}

@end
