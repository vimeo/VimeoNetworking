//
//  VIMAccount.m
//  VimeoNetworking
//
//  Created by Kashif Muhammad on 10/28/13.
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

#import "VIMAccount.h"
#import "VIMUser.h"

static NSString *BearerKey = @"bearer";
static NSString *UserKey = @"user";

@interface VIMAccount () <NSCoding, NSSecureCoding>

@end

@implementation VIMAccount

#pragma mark - Public API

- (BOOL)isAuthenticated
{
    return [self.accessToken length] > 0 && [[self.tokenType lowercaseString] isEqualToString:BearerKey];
}

- (BOOL)isAuthenticatedWithUser
{
    return [self isAuthenticated] && self.user;
}

- (BOOL)isAuthenticatedWithClientCredentials
{
    return [self isAuthenticated] && !self.user;
}

#pragma mark - VIMMappable

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:UserKey])
    {
        return [VIMUser class];
    }
    
    return nil;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.accessToken = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(accessToken))];
        self.tokenType = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(tokenType))];
        self.scope = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(scope))];
        self.userJSON = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(userJSON))];
        
        // Intentionally not persisting the VIMUser object [AH]
        // Intentionally not persisting the fact that a token is invalid, the next request will just re-set the flag [AH]
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessToken forKey:NSStringFromSelector(@selector(accessToken))];
    [aCoder encodeObject:self.tokenType forKey:NSStringFromSelector(@selector(tokenType))];
    [aCoder encodeObject:self.scope forKey:NSStringFromSelector(@selector(scope))];
    [aCoder encodeObject:self.userJSON forKey:NSStringFromSelector(@selector(userJSON))];
    
    // Intentionally not persisting the VIMUser object [AH]
    // Intentionally not persisting the fact that a token is invalid, the next request will just re-set the flag [AH]
}

@end
