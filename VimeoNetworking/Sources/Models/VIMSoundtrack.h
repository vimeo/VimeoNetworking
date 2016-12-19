//
//  VIMSoundtrack.h
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 4/26/16.
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

@interface VIMSoundtrack : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *artist;
@property (nonatomic, copy, nullable) NSString *pictureLink;
@property (nonatomic, copy, nullable) NSString *billboardImageUrl;
@property (nonatomic, copy, nullable) NSString *featureImageUrl;
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *albumName;
@property (nonatomic, copy, nullable) NSString *genre;
@property (nonatomic, copy, nullable) NSString *vibe;
@property (nonatomic, copy, nullable) NSString *soundtrackDescription;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, copy, nullable) NSString *statusFeatured;
@property (nonatomic, copy, nullable) NSString *statusBillboard;
@property (nonatomic, copy, nullable) NSString *itunesUrl;
@property (nonatomic, copy, nullable) NSString *coverColor;
@property (nonatomic, copy, nullable) NSString *streamUrl;
@property (nonatomic, copy, nullable) NSString *audioUrl;
@property (nonatomic, copy, nullable) NSString *resourceKey;
@property (nonatomic, copy, nullable) NSString *echonestId;

@property (nonatomic, strong, nullable) NSNumber *orderBillboard;
@property (nonatomic, strong, nullable) NSNumber *orderFeatured;
@property (nonatomic, strong, nullable) NSNumber *tempo;
@property (nonatomic, strong, nullable) NSNumber *tempoBucket;
@property (nonatomic, strong, nullable) NSNumber *valence;
@property (nonatomic, strong, nullable) NSNumber *valenceBucket;
@property (nonatomic, strong, nullable) NSNumber *energy;
@property (nonatomic, strong, nullable) NSNumber *energyBucket;

@end
