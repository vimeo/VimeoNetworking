//
//  VIMActivity.m
//  VimeoNetworking
//
//  Created by Kashif Muhammad on 9/26/14.
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

#import "VIMActivity.h"
#import "VIMVideo.h"
#import "VIMUser.h"
#import "VIMChannel.h"
#import "VIMGroup.h"
#import "VIMTag.h"
#import "VIMCategory.h"

NSString *VIMActivityType_Channel = @"channel";
NSString *VIMActivityType_Group = @"group";
NSString *VIMActivityType_Category = @"category";
NSString *VIMActivityType_Tag = @"tag";
NSString *VIMActivityType_Appearance = @"appearance";
NSString *VIMActivityType_Like = @"like";
NSString *VIMActivityType_Upload = @"upload";
NSString *VIMActivityType_Share = @"share";

@implementation VIMActivity

#pragma mark - Accessors

- (NSDate *)modifiedTime
{
    return self.video.modifiedTime;
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
    return @{@"clip" : @"video"};
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"clip"])
    {
        return [VIMVideo class];
    }

    if ([key isEqualToString:@"user"])
    {
        return [VIMUser class];
    }

    if ([key isEqualToString:@"channel"])
    {
        return [VIMChannel class];
    }

    if ([key isEqualToString:@"group"])
    {
        return [VIMGroup class];
    }
    
    if ([key isEqualToString:@"tag"])
    {
        return [VIMTag class];
    }
    
    if ([key isEqualToString:@"category"])
    {
        return [VIMCategory class];
    }

    return nil;
}

- (void)didFinishMapping
{
    if ([self.time isKindOfClass:[NSString class]])
    {
        self.time = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.time];
    }
}

@end
