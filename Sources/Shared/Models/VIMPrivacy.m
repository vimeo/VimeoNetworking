//
//  VIMPrivacy.m
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

#import "VIMPrivacy.h"

NSString *VIMPrivacy_Private = @"nobody";
NSString *VIMPrivacy_Select = @"users";
NSString *VIMPrivacy_Public = @"anybody";
NSString *VIMPrivacy_VOD = @"ptv";
NSString *VIMPrivacy_Following = @"contacts";
NSString *VIMPrivacy_Password = @"password";
NSString *VIMPrivacy_Unlisted = @"unlisted";
NSString *VIMPrivacy_Disabled = @"disable";
NSString *VIMPrivacy_Stock = @"stock";
NSString *VIMPrivacy_EmbedOnly = @"embed_only";

@implementation VIMPrivacy

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
    return @{@"add": @"canAdd",
             @"download" : @"canDownload",
             @"_bypass_token" : @"bypassToken"};
}

@end
