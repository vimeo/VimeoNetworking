//
//  VIMAlbum.m
//  TennisLockerPro
//
//  Created by Miroslav Kutak on 07/01/2018.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

#import "VIMAlbum.h"
#import "VIMUser.h"
#import "VIMConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMPicture.h"
#import "VIMPrivacy.h"

@interface VIMAlbum ()

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSDictionary *interactions;

@end

@implementation VIMAlbum

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
