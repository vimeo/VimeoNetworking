//
//  VIMVideoFile.m
//  VimeoNetworking
//
//  Created by Kashif Mohammad on 4/13/13.
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

#import "VIMVideoFile.h"

#import <AVFoundation/AVFoundation.h>

NSString *const VIMVideoFileQualityHLS = @"hls";
NSString *const VIMVideoFileQualityHD = @"hd";
NSString *const VIMVideoFileQualitySD = @"sd";
NSString *const VIMVideoFileQualityMobile = @"mobile";

@interface VIMVideoFile ()

@property (nonatomic, copy) NSString *expires;

@end

@implementation VIMVideoFile

#pragma mark - VIMMappable

- (void)didFinishMapping
{
    if (![self.width isKindOfClass:[NSNumber class]])
    {
        self.width = @(0);
    }

    if (![self.height isKindOfClass:[NSNumber class]])
    {
        self.height = @(0);
    }

    if (![self.size isKindOfClass:[NSNumber class]])
    {
        self.size = @(0);
    }

    if ([self.expires isKindOfClass:[NSString class]])
    {
        self.expirationDate = [[VIMModelObject dateFormatter] dateFromString:self.expires];
    }
    else
    {
        self.expirationDate = nil;
    }
}

#pragma mark

//    As of Oct 27, 2014:
//    \VideoCodec::CODEC_H264 => 'video/mp4',
//    \VideoCodec::CODEC_VP8 => 'video/webm',
//    \VideoCodec::CODEC_VP6 => 'vp6/x-video'

- (BOOL)isSupportedMimeType
{
    if (self.type == nil)
    {
        return NO;
    }
    
    return [AVURLAsset isPlayableExtendedMIMEType:self.type];
}

- (BOOL)isDownloadable
{
    return [self isSupportedMimeType] && ([self.quality isEqualToString:VIMVideoFileQualityMobile] || [self.quality isEqualToString:VIMVideoFileQualitySD] || [self.quality isEqualToString:VIMVideoFileQualityHD]);
}

- (BOOL)isStreamable
{
    return [self isSupportedMimeType] && ([self.quality isEqualToString:VIMVideoFileQualityMobile] || [self.quality isEqualToString:VIMVideoFileQualitySD] || [self.quality isEqualToString:VIMVideoFileQualityHD] || [self.quality isEqualToString:VIMVideoFileQualityHLS]);
}

- (BOOL)isExpired
{
    if (!self.expirationDate) // This will yield NSOrderedSame (weird), so adding an explicit check here [AH] 9/14/2015
    {
        return NO;
    }
    
    NSComparisonResult result = [[NSDate date] compare:self.expirationDate];
    
    return (result == NSOrderedDescending);
}

@end
