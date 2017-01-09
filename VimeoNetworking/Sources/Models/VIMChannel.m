//
//  VIMChannel.m
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

#import "VIMChannel.h"

#import "VIMUser.h"
#import "VIMConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMPicture.h"
#import "VIMPrivacy.h"

@interface VIMChannel ()

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSDictionary *interactions;

@end

@implementation VIMChannel

#pragma mark - Public API

- (VIMConnection *)connectionWithName:(NSString *)connectionName
{
    return [self.connections objectForKey:connectionName];
}

- (VIMInteraction *)interactionWithName:(NSString *)name
{
    return [self.interactions objectForKey:name];
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
    return @{@"description" : @"channelDescription",
             @"pictures": @"pictureCollection",
             @"header": @"headerPictureCollection"};
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if( [key isEqualToString:@"privacy"] )
    {
        return [VIMPrivacy class];
    }

    if ([key isEqualToString:@"user"])
    {
        return [VIMUser class];
    }
    
    if ([key isEqualToString:@"pictures"])
    {
        return [VIMPictureCollection class];
    }
    
    if ([key isEqualToString:@"header"])
    {
        return [VIMPictureCollection class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if ([self.createdTime isKindOfClass:[NSString class]])
    {
        self.createdTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.createdTime];
    }

    [self parseConnections];
    [self parseInteractions];
    [self formatModifiedTime];
}

#pragma mark - Parsing Helpers

- (void)parseConnections
{
    NSMutableDictionary *connections = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:@"connections"];
    if([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if([value isKindOfClass:[NSDictionary class]])
            {
                VIMConnection *connection = [[VIMConnection alloc] initWithKeyValueDictionary:value];
                [connections setObject:connection forKey:key];
            }
        }
    }
    
    self.connections = connections;
}

- (void)parseInteractions
{
    NSMutableDictionary *interactions = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:@"interactions"];
    if([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if([value isKindOfClass:[NSDictionary class]])
            {
                VIMInteraction *interaction = [[VIMInteraction alloc] initWithKeyValueDictionary:value];
                if([interaction respondsToSelector:@selector(didFinishMapping)])
                    [interaction didFinishMapping];
                
                [interactions setObject:interaction forKey:key];
            }
        }
    }
    
    self.interactions = interactions;
}

- (void)formatModifiedTime
{
    if ([self.modifiedTime isKindOfClass:[NSString class]])
    {
        self.modifiedTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.modifiedTime];
    }
}

#pragma mark - Helpers

- (BOOL)isFollowing
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameFollow];
    return (interaction && interaction.added.boolValue);
}

@end
