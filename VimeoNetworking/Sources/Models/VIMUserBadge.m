//
//  VIMUserBadge.m
//  VimeoNetworking
//
//  Created by Jake Oliver on 8/8/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

#import "VIMUserBadge.h"

@implementation VIMUserBadge

static NSString *const Plus = @"plus";
static NSString *const Pro = @"pro";
static NSString *const Business = @"business";
static NSString *const Staff = @"staff";
static NSString *const Curation = @"curation";
static NSString *const Support = @"support";
static NSString *const Alum = @"alum";
static NSString *const LivePro = @"live_pro";
static NSString *const LiveBusiness = @"live_business";
static NSString *const Producer = @"producer";

- (void)didFinishMapping
{
    [self parseBadge];
}

- (void)parseBadge
{
    if ([self.type isEqualToString:Plus])
    {
        self.badgeType = VIMUserBadgeTypePlus;
    }
    else if ([self.type isEqualToString:Pro])
    {
        self.badgeType = VIMUserBadgeTypePro;
    }
    else if ([self.type isEqualToString:Business])
    {
        self.badgeType = VIMUserBadgeTypeBusiness;
    }
    else if ([self.type isEqualToString:Staff])
    {
        self.badgeType = VIMUserBadgeTypeStaff;
    }
    else if ([self.type isEqualToString:Curation])
    {
        self.badgeType = VIMUserBadgeTypeCuration;
    }
    else if ([self.type isEqualToString:Support])
    {
        self.badgeType = VIMUserBadgeTypeSupport;
    }
    else if ([self.type isEqualToString:Alum])
    {
        self.badgeType = VIMUserBadgeTypeAlum;
    }
    else if ([self.type isEqualToString:LivePro])
    {
        self.badgeType = VIMUserBadgeTypeLivePro;
    }
    else if ([self.type isEqualToString:LiveBusiness])
    {
        self.badgeType = VIMUserBadgeTypeLiveBusiness;
    }
    else if ([self.type isEqualToString:Producer])
    {
        self.badgeType = VIMUserBadgeTypeProducer;
    }
    else
    {
        self.badgeType = VIMUserBadgeTypeDefault;
    }
}

@end
