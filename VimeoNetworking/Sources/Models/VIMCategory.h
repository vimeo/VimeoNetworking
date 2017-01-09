//
//  VIMCategory.h
//  VimeoNetworking
//
//  Created by Huebner, Rob on 5/14/15.
//  Copyright (c) 2015 Vimeo. All rights reserved.
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
@class VIMConnection;
@class VIMInteraction;

@interface VIMCategory : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSDate *modifiedTime;
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, assign) BOOL isTopLevel;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, strong, nullable) NSArray* subcategories;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

- (BOOL)isFollowing;

@end
