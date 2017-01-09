//
//  VIMVideoUtils.m
//  VimeoNetworking
//
//  Created by Hanssen, Alfie on 11/5/15.
//  Copyright © 2015 Vimeo. All rights reserved.
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

#import "VIMVideoUtils.h"
#import "VIMVideo.h"
#import "VIMVideoFile.h"

@implementation VIMVideoUtils

+ (nullable VIMVideoFile *)hlsFileForVideo:(nonnull VIMVideo *)video screenSize:(CGSize)size
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality == %@", VIMVideoFileQualityHLS];
    
    return [VIMVideoUtils fileForVideo:video predicate:predicate screenSize:size];
}

+ (nullable VIMVideoFile *)mp4FileForVideo:(nonnull VIMVideo *)video screenSize:(CGSize)size
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quality != %@", VIMVideoFileQualityHLS];
    
    return [VIMVideoUtils fileForVideo:video predicate:predicate screenSize:size];
}

+ (nullable VIMVideoFile *)fallbackFileForVideo:(nonnull VIMVideo *)video file:(nonnull VIMVideoFile *)file screenSize:(CGSize)size
{
    if (!video || !file)
    {
        return nil;
    }
    
    NSPredicate *predicate = nil;
    
    if ([file.quality isEqualToString:VIMVideoFileQualityHLS])
    {
        // There will only ever be one HSL file so we choose !HLS [AH] 8/31/2015
        predicate = [NSPredicate predicateWithFormat:@"quality != %@", VIMVideoFileQualityHLS];
    }
    else
    {
        if (!file.width ||
            !file.height ||
            [file.width isEqual:[NSNull null]] ||
            [file.height isEqual:[NSNull null]] ||
            [file.width isEqual:@(0)] ||
            [file.height isEqual:@(0)])
        {
            return nil;
        }
        
        // And we want to exclude the file we're falling back from [AH] 8/31/2015
        predicate = [NSPredicate predicateWithFormat:@"quality != %@ && width.integerValue < %i", VIMVideoFileQualityHLS, file.width.integerValue];
    }
    
    return [VIMVideoUtils fileForVideo:video predicate:predicate screenSize:size];
}

#pragma mark - Private API

+ (VIMVideoFile *)fileForVideo:(VIMVideo *)video predicate:(NSPredicate *)predicate screenSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero) || predicate == nil || video == nil)
    {
        return nil;
    }
    
    NSArray *filteredFiles = [video.files filteredArrayUsingPredicate:predicate];
    
    // Sort largest to smallest
    NSArray *sortedFiles = [filteredFiles sortedArrayUsingComparator:^NSComparisonResult(VIMVideoFile *a, VIMVideoFile *b) {
        
        NSNumber *first = [a width];
        NSNumber *second = [b width];
        
        return [second compare:first];
        
    }];
    
    VIMVideoFile *file = nil;
    
    // TODO: augment this to handle portrait videos [AH]
    NSInteger targetScreenWidth = MAX(size.width, size.height);
    
    for (VIMVideoFile *currentFile in sortedFiles)
    {
        if ([currentFile isSupportedMimeType] && currentFile.link)
        {
            // We dont yet have a file, grab the largest one (based on sort order above)
            if (file == nil)
            {
                file = currentFile;
                
                continue;
            }
            
            // We dont have the info with which to compare the files
            // TODO: is this a problem? HLS files report width/height of 0,0 [AH] 8/31/2015
            if ((file.width == nil || currentFile.width == nil ||
                 [file.width isEqual:[NSNull null]] || [currentFile.width isEqual:[NSNull null]] ||
                 [file.width isEqual:@(0)] || [currentFile.width isEqual:@(0)]))
            {
                continue;
            }
            
            if (currentFile.width.intValue > targetScreenWidth && currentFile.width.intValue < file.width.intValue)
            {
                file = currentFile;
            }
        }
    }
    
    //    NSLog(@"selected (%@, %@) for screensize (%@) out of %lu choices with format %@", file.width, file.height, NSStringFromCGSize(size), (unsigned long)[sortedFiles count], predicate.predicateFormat);
    
    return file;
}


@end
