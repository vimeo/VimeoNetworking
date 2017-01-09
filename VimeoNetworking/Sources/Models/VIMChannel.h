//
//  VIMChannel.h
//  VimeoNetworking
//
//  Created by Hanssen, Alfie on 9/30/14.
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

@class VIMPictureCollection;
@class VIMPrivacy;
@class VIMUser;
@class VIMConnection;
@class VIMInteraction;

@interface VIMChannel : VIMModelObject

@property (nonatomic, strong, nullable) NSDate *createdTime;
@property (nonatomic, strong, nullable) NSDate *modifiedTime;
@property (nonatomic, copy, nullable) NSString *channelDescription;
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, strong, nullable) VIMPictureCollection *headerPictureCollection;
@property (nonatomic, strong, nullable) VIMPrivacy *privacy;
@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) VIMUser *user;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

- (BOOL)isFollowing;

@end
