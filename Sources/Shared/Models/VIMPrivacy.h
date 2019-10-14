//
//  VIMPrivacy.h
//  VimeoNetworking
//
//  Created by Kashif Muhammad on 9/24/14.
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

extern NSString * __nonnull VIMPrivacy_Private;
extern NSString * __nonnull VIMPrivacy_Select;
extern NSString * __nonnull VIMPrivacy_Public;
extern NSString * __nonnull VIMPrivacy_VOD;
extern NSString * __nonnull VIMPrivacy_Following;
extern NSString * __nonnull VIMPrivacy_Password;
extern NSString * __nonnull VIMPrivacy_Unlisted;
extern NSString * __nonnull VIMPrivacy_Disabled;
extern NSString * __nonnull VIMPrivacy_Stock;
extern NSString * __nonnull VIMPrivacy_EmbedOnly;

@interface VIMPrivacy : VIMModelObject

@property (nonatomic, copy, nullable) NSNumber *canAdd;
@property (nonatomic, copy, nullable) NSNumber *canDownload;

@property (nonatomic, copy, nullable) NSString *comments;
@property (nonatomic, copy, nullable) NSString *embed;
@property (nonatomic, copy, nullable) NSString *view;
@property (nonatomic, copy, nullable) NSString *bypassToken;
@property (nonatomic, copy, nullable) NSString *password;

@end
