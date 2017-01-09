//
//  VIMVideoProgressiveFile.m
//  VimeoNetworking
//
//  Created by Lehrer, Nicole on 5/12/16.
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

#import "VIMVideoProgressiveFile.h"
@import AVFoundation;

@interface VIMVideoProgressiveFile()

@property (nonatomic, copy, nullable) NSString *createdTime;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSNumber *width;
@property (nonatomic, strong, nullable) NSNumber *height;

@end

@implementation VIMVideoProgressiveFile

#pragma mark - VIMVideoPlayFile override

- (NSDictionary *)getObjectMapping
{
    NSMutableDictionary *objectMappingDict = [[NSMutableDictionary alloc] initWithDictionary:[super getObjectMapping]];
    
    [objectMappingDict addEntriesFromDictionary:@{@"type": @"mimeType",
                                                  @"size": @"sizeInBytes"}];
    return objectMappingDict;
}

- (void)didFinishMapping
{
    [super didFinishMapping];
    
    if (![self.width isKindOfClass:[NSNumber class]])
    {
        self.width = @(0);
    }
    
    if (![self.height isKindOfClass:[NSNumber class]])
    {
        self.height = @(0);
    }
    
    if (![self.sizeInBytes isKindOfClass:[NSNumber class]])
    {
        self.sizeInBytes = @(0);
    }
    
    if (![self.fps isKindOfClass:[NSNumber class]])
    {
        self.fps = @(0);
    }
    
    if ([self.createdTime isKindOfClass:[NSString class]])
    {
        self.creationDate = [[VIMModelObject dateFormatter] dateFromString:self.createdTime];
    }
    
    [self setDimensions];
}

#pragma mark - Instance methods

- (void)setDimensions
{
    NSInteger width = self.width.integerValue;
    NSInteger height = self.height.integerValue;
    
    self.dimensions = CGSizeMake(width, height);
}

//    As of Oct 27, 2014:
//    \VideoCodec::CODEC_H264 => 'video/mp4',
//    \VideoCodec::CODEC_VP8 => 'video/webm',
//    \VideoCodec::CODEC_VP6 => 'vp6/x-video'

- (BOOL)isSupportedMimeType
{
    if (self.mimeType == nil)
    {
        return NO;
    }
    
    return [AVURLAsset isPlayableExtendedMIMEType:self.mimeType];
}

@end
