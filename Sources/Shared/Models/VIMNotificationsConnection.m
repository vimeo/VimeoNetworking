//
//  VIMNotificationsConnection.m
//  Pods
//
//  Created by Guhit, Fiel on 3/9/17.
//
//

#import "VIMNotificationsConnection.h"
#import "VIMNotification.h"

@interface VIMNotificationsConnection ()

@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSNumber *> *type_count;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSNumber *> *type_unseen_count;

@end

@implementation VIMNotificationsConnection

- (void)didFinishMapping
{
    [super didFinishMapping];

    // This is a migration for the outage on 2/20/18 where these counts were being returned as empty arrays for some users.
    // https://vimean.atlassian.net/browse/VIM-5996 [ghking] 2/22/18

    if (![self.type_count isKindOfClass:[NSDictionary class]])
    {
        self.type_count = [NSDictionary new];
    }
}

- (NSInteger)supportedNotificationNewTotal
{
    NSArray<NSString *> *supportedNotificationKeys = [[VIMNotification supportedTypeMap] allKeys];
    
    NSInteger total = 0;
    for (NSString *key in supportedNotificationKeys)
    {
        total += self.type_count[key].integerValue;
    }
    
    return total;
}

- (NSInteger)supportedNotificationUnseenTotal
{
    NSArray<NSString *> *supportedNotificationKeys = [[VIMNotification supportedTypeMap] allKeys];
    
    NSInteger total = 0;
    for (NSString *key in supportedNotificationKeys)
    {
        total += self.type_unseen_count[key].integerValue;
    }
    
    return total;
}

@end
