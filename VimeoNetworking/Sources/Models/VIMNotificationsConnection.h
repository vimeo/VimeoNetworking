//
//  VIMNotificationsConnection.h
//  Pods
//
//  Created by Guhit, Fiel on 3/9/17.
//
//

#import <VimeoNetworking/VimeoNetworking.h>

@interface VIMNotificationsConnection : VIMConnection

/**
 Calculates the total for new notifications that are currently supported by VIMNotification's supportedTypeMap
 
 @return An NSInteger specifying the total of new notifications currently supported
 */
- (NSInteger)supportedNotificationNewTotal;
- (NSInteger)supportedNotificationUnseenTotal;

@end
