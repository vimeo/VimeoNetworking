//
//  VIMVideoPlayRepresentation.h
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

#import "VIMModelObject.h"

@class VIMVideoHLSFile;
@class VIMVideoDASHFile;
@class VIMVideoDRMFiles;
@class VIMVideoProgressiveFile;
@class PlayProgress;

typedef NS_ENUM(NSUInteger, VIMVideoPlayabilityStatus) {
    VIMVideoPlayabilityStatusUnavailable,           // Not finished transcoding
    VIMVideoPlayabilityStatusPlayable,              // Can be played
    VIMVideoPlayabilityStatusPurchaseRequired,      // On demand video that is not purchased
    VIMVideoPlayabilityStatusRestricted,            // User's region cannot play or purchase
    VIMVideoPlayabilityStatusPassword               // The video is protected by a password
};

@interface VIMVideoPlayRepresentation : VIMModelObject

@property (nonatomic, strong, nullable) VIMVideoHLSFile *hlsFile;
@property (nonatomic, strong, nullable) VIMVideoDASHFile *dashFile;
@property (nonatomic, strong, nullable) VIMVideoDRMFiles *drmFiles;
@property (nonatomic, strong, nullable) NSArray<VIMVideoProgressiveFile *> *progressiveFiles;
@property (nonatomic, assign) VIMVideoPlayabilityStatus playabilityStatus;
@property (nonatomic, strong, nullable) PlayProgress *progress;

@end
