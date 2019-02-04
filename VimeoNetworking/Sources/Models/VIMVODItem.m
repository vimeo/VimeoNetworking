//
//  VIMVODItem.m
//  Vimeo
//
//  Created by Lehrer, Nicole on 5/18/16.
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

#import "VIMVODItem.h"

#import "VIMObjectMapper.h"
#import "VIMUser.h"
#import "VIMPicture.h"
#import "VIMVODConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMVideo.h"

@interface VIMVODItem ()

// MARK: Naming mirrors API (where names with underscores are mapped to camelCase)
@property (nonatomic, strong, nullable) NSDictionary *metadata;
@property (nonatomic, strong, nullable) NSDictionary *connections;
@property (nonatomic, strong, nullable) NSDictionary *interactions;
@property (nonatomic, strong, nullable) NSDictionary *publish;
@property (nonatomic, copy, nullable) NSString *type;

@end

@implementation VIMVODItem

#pragma mark - Public API

- (NSNumber * _Nullable)videosTotal;
{
    VIMConnection *videosConnection = [self getVideosConnection];
    
    return videosConnection.total;
}

- (NSNumber * _Nullable)extraVideosTotal;
{
    VIMVODConnection *videosConnection = [self getVideosConnection];
    
    return videosConnection.extraVideosCount;
}

- (NSNumber * _Nullable)mainVideosTotal;
{
    VIMVODConnection *videosConnection = [self getVideosConnection];
    
    return videosConnection.mainVideosCount;
}

- (NSNumber * _Nullable)viewableVideosTotal;
{
    VIMVODConnection *videosConnection = [self getVideosConnection];
    
    return videosConnection.viewableVideosCount;
}

- (NSString * _Nullable)videosURI
{
    VIMConnection *videosConnection = [self getVideosConnection];
    
    return videosConnection.uri;
}

- (VIMConnection *)connectionWithName:(NSString *)connectionName
{
    return [self.connections objectForKey:connectionName];
}

- (VIMInteraction *)interactionWithName:(NSString *)interactionName
{
    return [self.interactions objectForKey:interactionName];
}

- (BOOL)canBuy
{
    return [self canDoInteraction:VIMInteractionNameBuy];
}

- (BOOL)canRent
{
    return [self canDoInteraction:VIMInteractionNameRent];
}

- (BOOL)canSubscribe
{
    return [self canDoInteraction:VIMInteractionNameSubscribe];
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
    return @{@"description": @"vodDescription",
             @"pictures": @"pictureCollection"};
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"film"])
    {
        return [VIMVideo class];
    }
    
    if ([key isEqualToString:@"trailer"])
    {
        return [VIMVideo class];
    }
    
    if ([key isEqualToString:@"pictures"])
    {
        return [VIMPictureCollection class];
    }
    
    if ([key isEqualToString:@"user"])
    {
        return [VIMUser class];
    }
    
    if ([key isEqualToString:@"metadata"])
    {
        return [NSMutableDictionary class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if ([self.pictureCollection isEqual:[NSNull null]])
    {
        self.pictureCollection = nil;
    }
    
    // This is a temporary fix until we implement model versioning for cached JSON [AH]
    [self checkIntegrityOfPictureCollection];
    
    [self parseConnections];
    [self parseInteractions];
    [self formatPublishTime];
    [self setVODItemType];
}

#pragma mark - Model Versioning

// This is only called for unarchived model objects [AH]

- (void)upgradeFromModelVersion:(NSUInteger)fromVersion toModelVersion:(NSUInteger)toVersion withCoder:(NSCoder *)aDecoder
{
    if (fromVersion == 2 && toVersion == 3)
    {
        [self checkIntegrityOfPictureCollection];
    }
}

- (void)checkIntegrityOfPictureCollection
{
    if ([self.pictureCollection isKindOfClass:[NSArray class]])
    {
        NSArray *pictures = (NSArray *)self.pictureCollection;
        self.pictureCollection = [VIMPictureCollection new];
        
        if ([pictures count])
        {
            if ([[pictures firstObject] isKindOfClass:[VIMPicture class]])
            {
                self.pictureCollection.pictures = pictures;
            }
            else if ([[pictures firstObject] isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *pictureObjects = [NSMutableArray array];
                for (NSDictionary *dictionary in pictures)
                {
                    VIMPicture *picture = [[VIMPicture alloc] initWithKeyValueDictionary:dictionary];
                    [pictureObjects addObject:picture];
                }
                
                self.pictureCollection.pictures = pictureObjects;
            }
        }
    }
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
                Class connectionClass = [key isEqualToString:VIMConnectionNameVideos] ? [VIMVODConnection class] : [VIMConnection class];
                VIMConnection *connection = [[connectionClass alloc] initWithKeyValueDictionary:value];
                if([connection respondsToSelector:@selector(didFinishMapping)])
                    [connection didFinishMapping];
                
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

- (void)formatPublishTime
{
    NSString *publishTimeString = [self.publish objectForKey:@"time"];
    
    if ([publishTimeString isKindOfClass:[NSString class]])
    {
        self.publishDate = [[VIMModelObject dateFormatter] dateFromString:publishTimeString];
    }
}

- (void)setVODItemType
{
    NSDictionary *vodTypeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:VIMVODItemTypeSeries], @"series",
                                      [NSNumber numberWithInt:VIMVODItemTypeFilm], @"film",
                                      nil];
    
    NSNumber *number = [vodTypeDictionary objectForKey:self.type];
    
    NSAssert(number != nil, @"VOD type not handled, unknown VOD type");
    
    self.itemType = [number intValue];
}

#pragma mark - Helpers

- (VIMVODConnection *)getVideosConnection
{
    return (VIMVODConnection *)[self connectionWithName:VIMConnectionNameVideos];
}

- (BOOL)canDoInteraction:(NSString *)interactionName
{
    VIMInteraction *interaction = [self interactionWithName:interactionName];
    
    return interaction && [interaction.uri length];
}

@end
