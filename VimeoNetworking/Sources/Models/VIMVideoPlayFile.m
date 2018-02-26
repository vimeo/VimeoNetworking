//
//  VIMVideoPlayFile.m
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

#import "VIMVideoPlayFile.h"
#import <VimeoNetworking/VimeoNetworking-Swift.h>

@interface VIMVideoPlayFile()

@property (nonatomic, copy) NSString *expires;

@end

@implementation VIMVideoPlayFile

#pragma mark - VIMMappable

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"live"])
    {
        return [VIMLiveHeartbeat class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if ([self.expires isKindOfClass:[NSString class]])
    {
        self.expirationDate = [[VIMModelObject dateFormatter] dateFromString:self.expires];
    }
    
    // With API version 3.3.1, `log` was converted to a string rather than a dictionary.
    // We need this migraiton in place to guard against unarchiving cached objects with the old representaiton.
    // So, when we uncache objects with the dictionary style `log`, we just set `log` to nil and any plays will not be logged.
    // Next time the obejct is refreshed from network the `log` field will then be populated with the correct string.
    // This migration can eventially be removed as peoples cached content is overwritten. [ghking] 2/3/17
    
    if (![self.log isKindOfClass:[NSString class]])
    {
        self.log = nil;
    }
}

- (NSDictionary *)getObjectMapping
{
    return @{@"link_expiration_time": @"expires", @"live": @"heartbeat"};
}

#pragma mark - Instance methods

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
