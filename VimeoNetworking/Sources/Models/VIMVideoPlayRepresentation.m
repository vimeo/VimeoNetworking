//
//  VIMVideoPlayRepresentation.m
//  VimeoNetworking
//
//  Created by Lehrer, Nicole on 5/11/16.
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


#import "VIMVideoPlayRepresentation.h"
#import "VIMVideoHLSFile.h"
#import "VIMVideoDASHFile.h"
#import "VIMVideoDRMFiles.h"
#import "VIMVideoProgressiveFile.h"
#import <VimeoNetworking/VimeoNetworking-Swift.h>

@interface VIMVideoPlayRepresentation()

@property (nonatomic, copy, nullable) NSString *status;

@end

@implementation VIMVideoPlayRepresentation

#pragma mark - VIMMappable

- (void)didFinishMapping
{
    [self setPlayabilityStatus];
}

- (NSDictionary *)getObjectMapping
{
    return @{@"hls": @"hlsFile",
             @"dash": @"dashFile",
             @"drm": @"drmFiles",
             @"progressive": @"progressiveFiles"};
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"hls"])
    {
        return [VIMVideoHLSFile class];
    }
    
    if ([key isEqualToString:@"dash"])
    {
        return [VIMVideoDASHFile class];
    }
    
    if ([key isEqualToString:@"drm"])
    {
        return [VIMVideoDRMFiles class];
    }
    
    if ([key isEqualToString:@"progress"])
    {
        return [PlayProgress class];
    }
    
    return nil;
}

- (Class)getClassForCollectionKey:(NSString *)key
{
    if ([key isEqualToString:@"progressive"])
    {
        return [VIMVideoProgressiveFile class];
    }
    
    return nil;
}

- (void)setPlayabilityStatus
{
    NSDictionary *statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:VIMVideoPlayabilityStatusUnavailable], @"unavailable",
                                      [NSNumber numberWithInt:VIMVideoPlayabilityStatusPlayable], @"playable",
                                      [NSNumber numberWithInt:VIMVideoPlayabilityStatusPurchaseRequired], @"purchase_required",
                                      [NSNumber numberWithInt:VIMVideoPlayabilityStatusRestricted], @"restricted",
                                      [NSNumber numberWithInt:VIMVideoPlayabilityStatusPassword], @"password",
                                      nil];
    
    NSNumber *number = [statusDictionary objectForKey:self.status];
    
    NSAssert(number != nil, @"Playability status not handled, unknown playability status");
    
    self.playabilityStatus = [number intValue];
}

@end
