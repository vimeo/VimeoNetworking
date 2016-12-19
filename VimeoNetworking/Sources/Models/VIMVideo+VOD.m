//
//  VIMVideo+VOD.m
//  Vimeo
//
//  Created by Lehrer, Nicole on 5/22/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

#import "VIMVideo+VOD.h"
#import "VIMConnection.h"
#import "VIMInteraction.h"

@implementation VIMVideo (VOD)

#pragma mark - Public API

- (BOOL)isVOD
{
    return [self vodItemURI] != nil;
}

- (BOOL)isVODTrailer
{
    return [self isVOD] && [self vodTrailerURI] == nil; // If video lacks a trailer connection, it IS a trailer [NL] 05/22/16
}

- (NSString *)vodTrailerURI
{
    VIMConnection *vodTrailer = [self connectionWithName:VIMConnectionNameVODTrailer];
    
    return vodTrailer.uri;
}

- (NSString *)vodItemURI
{
    VIMConnection *vodItem = [self connectionWithName:VIMConnectionNameVODItem];
    
    return vodItem.uri;
}

- (VIMVideoVODAccess)vodAccess  
{
    // TODO: As of 5/03/2016 purchase interactions from API are in flux
    // This logic follows anticipated behavior once work is complete
    // but will require testing [NL] 05/03/2016
    
    // For each type of purchase interaction (buy, rent, subscribe) check the value of streamStatus
    // to see if item was bought, rented, or subscribed
    
    // We need to check buy interaction first, because when an item is considered "bought",
    // the rent and subscribe interactions may still also return the "purchased" state for streamStatus
    
    VIMInteraction *buyInteraction = [self interactionWithName:VIMInteractionNameBuy];
    
    if (buyInteraction && buyInteraction.streamStatus == VIMInteractionStreamStatusPurchased)
    {
        return VIMVideoVODAccessBought;
    }
    
    // Then we check the case where item has been both rented and subscribed
    // In this case we return the interaction type with the later date
    
    VIMInteraction *rentInteraction = [self interactionWithName:VIMInteractionNameRent];
    VIMInteraction *subscribeInteraction = [self interactionWithName:VIMInteractionNameSubscribe];

    if (rentInteraction && rentInteraction.streamStatus == VIMInteractionStreamStatusPurchased &&
        subscribeInteraction && subscribeInteraction.streamStatus == VIMInteractionStreamStatusPurchased)
    {
        NSDate *rentalExpirationDate = [self expirationDateForAccess:VIMVideoVODAccessRented];
        NSDate *subscriptionExpirationDate = [self expirationDateForAccess:VIMVideoVODAccessSubscribed];
        
        NSDate *laterDate = [rentalExpirationDate laterDate:subscriptionExpirationDate];
        if ([laterDate isEqualToDate:subscriptionExpirationDate])
        {
            return VIMVideoVODAccessSubscribed;
        }
        
        return VIMVideoVODAccessRented;
    }
    
    // Otherwise check for cases where item is rented or subscribed to [NL] 06/02/2016
    
    if (rentInteraction && rentInteraction.streamStatus == VIMInteractionStreamStatusPurchased)
    {
        return VIMVideoVODAccessRented;
    }
    
    if (subscribeInteraction && subscribeInteraction.streamStatus == VIMInteractionStreamStatusPurchased)
    {
        return VIMVideoVODAccessSubscribed;
    }
    
    return VIMVideoVODAccessUnavailable;
}

- (NSDate *)expirationDateForAccess:(VIMVideoVODAccess)access
{
    if (access == VIMVideoVODAccessRented)
    {
        VIMInteraction *rentInteraction = [self interactionWithName:VIMInteractionNameRent];
        return rentInteraction.expirationDate;
    }
    
    if (access == VIMVideoVODAccessSubscribed)
    {
        VIMInteraction *subscribeInteraction = [self interactionWithName:VIMInteractionNameSubscribe];
        return subscribeInteraction.expirationDate;
    }
    
    return nil;
}

@end
