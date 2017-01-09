//
//  VIMSeason.h
//  Pods
//
//  Created by Huebner, Rob on 10/4/16.
//
//

#import <VimeoNetworking/VimeoNetworking.h>

@interface VIMSeason : VIMModelObject

@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *type;

- (nullable VIMConnection *)connectionWithName:(nonnull NSString *)connectionName;
- (nullable VIMInteraction *)interactionWithName:(nonnull NSString *)name;

/**
 Reports whether the episodes in this season are protected by DRM.
 
 @return A BOOL indicating whether the receiver contains DRM-protected episodes.
 */
- (BOOL)containsDRMProtectedContent;


@end
