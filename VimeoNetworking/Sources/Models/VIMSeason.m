//
//  VIMSeason.m
//  Pods
//
//  Created by Huebner, Rob on 10/4/16.
//
//

#import "VIMSeason.h"

@interface VIMSeason ()

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSDictionary *interactions;

@end

@implementation VIMSeason

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

- (void)didFinishMapping
{
    [self parseConnections];
    [self parseInteractions];
}

#pragma mark - Parsing Helpers

- (void)parseConnections
{
    NSMutableDictionary *connections = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:VIMConnectionKey];
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
    
    NSDictionary *dict = [self.metadata valueForKey:VIMInteractionKey];
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

- (BOOL)containsDRMProtectedContent
{
    VIMInteraction *buyInteraction = [self interactionWithName:VIMInteractionNameBuy];
    BOOL isBuyDRMProtected = buyInteraction.isForDRMProtectedContent;
    
    VIMInteraction *rentInteraction = [self interactionWithName:VIMInteractionNameRent];
    BOOL isRentDRMProtected = rentInteraction.isForDRMProtectedContent;
    
    VIMInteraction *subscribeInteraction = [self interactionWithName:VIMInteractionNameSubscribe];
    BOOL isSubscribeDRMProtected = subscribeInteraction.isForDRMProtectedContent;
    
    return isBuyDRMProtected || isRentDRMProtected || isSubscribeDRMProtected;
}

@end
