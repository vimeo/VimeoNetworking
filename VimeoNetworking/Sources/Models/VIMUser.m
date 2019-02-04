//
//  VIMUser.m
//  VimeoNetworking
//
//  Created by Kashif Mohammad on 4/4/13.
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

#import "VIMObjectMapper.h"
#import "VIMUser.h"
#import "VIMNotificationsConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMPicture.h"
#import "VIMPreference.h"
#import "VIMUserBadge.h"
#import <VimeoNetworking/VimeoNetworking-Swift.h>

static NSString *const Basic = @"basic";
static NSString *const Plus = @"plus";
static NSString *const Pro = @"pro";
static NSString *const Business = @"business";
static NSString *const LivePro = @"live_pro";
static NSString *const LiveBusiness = @"live_business";
static NSString *const LivePremium = @"live_premium";
static NSString *const ProUnlimited = @"pro_unlimited";
static NSString *const Producer = @"producer";

@interface VIMUser ()

@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSDictionary *interactions;
@property (nonatomic, strong, nullable) NSArray *emails;

@property (nonatomic, assign, readwrite) VIMUserAccountType accountType;

@end

@implementation VIMUser

#pragma mark - Public API

- (VIMConnection *)connectionWithName:(NSString *)connectionName
{
    return [self.connections objectForKey:connectionName];
}

- (VIMNotificationsConnection *)notificationsConnection
{
    return [self.connections objectForKey:VIMConnectionNameNotifications];
}

- (VIMInteraction *)interactionWithName:(NSString *)name
{
    return [self.interactions objectForKey:name];
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
	return @{@"pictures": @"pictureCollection"};
}

- (Class)getClassForObjectKey:(NSString *)key
{
    if ([key isEqualToString:@"badge"])
    {
        return [VIMUserBadge class];
    }
    
    if ([key isEqualToString:@"pictures"])
    {
        return [VIMPictureCollection class];
    }

    if ([key isEqualToString:@"preferences"])
    {
        return [VIMPreference class];
    }

    if ([key isEqualToString:@"upload_quota"])
    {
        return [VIMUploadQuota class];
    }
    
    if ([key isEqualToString:@"live_quota"])
    {
        return [VIMLiveQuota class];
    }

    if ([key isEqualToString:@"membership"]) {
        return [UserMembership class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if ([self.pictureCollection isEqual:[NSNull null]])
    {
        self.pictureCollection = nil;
    }

    // This is a temporary fix until we implement (1) ability to refresh authenticated user cache, and (2) model versioning for cached JSON [AH]
    [self checkIntegrityOfPictureCollection];
    
    [self parseConnections];
    [self parseInteractions];
    [self parseAccountType];
    [self parseEmails];
    [self formatCreatedTime];
    [self formatModifiedTime];
}

#pragma mark - Model Validation

- (void)validateModel:(NSError *__autoreleasing *)error
{
    [super validateModel:error];
    
    if (*error)
    {
        return;
    }
    
    if (self.uri == nil)
    {
        NSString *description = @"VIMUser failed validation: uri cannot be nil";
        *error = [NSError errorWithDomain:VIMModelObjectErrorDomain code:VIMModelObjectValidationErrorCode userInfo:@{NSLocalizedDescriptionKey: description}];
        
        return;
    }
    
    // TODO: Uncomment this when user objects get resource keys [RH] (5/17/16)
    //    if (self.resourceKey == nil)
    //    {
    //        NSString *description = @"VIMUser failed validation: resourceKey cannot be nil";
    //        *error = [NSError errorWithDomain:VIMModelObjectErrorDomain code:VIMModelObjectValidationErrorCode userInfo:@{NSLocalizedDescriptionKey: description}];
    //
    //        return;
    //    }
}

#pragma mark - Parsing Helpers

- (void)parseConnections
{
    NSMutableDictionary *connections = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = [self.metadata valueForKey:@"connections"];
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if ([value isKindOfClass:[NSDictionary class]])
            {
                Class connectionClass = [key isEqualToString:VIMConnectionNameNotifications] ? [VIMNotificationsConnection class] : [VIMConnection class];
                VIMConnection *connection = [[connectionClass alloc] initWithKeyValueDictionary:value];
                
                if ([connection respondsToSelector:@selector(didFinishMapping)])
                {
                    [connection didFinishMapping];
                }
                
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
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        for(NSString *key in [dict allKeys])
        {
            NSDictionary *value = [dict valueForKey:key];
            if ([value isKindOfClass:[NSDictionary class]])
            {
                VIMInteraction *interaction = [[VIMInteraction alloc] initWithKeyValueDictionary:value];
                if ([interaction respondsToSelector:@selector(didFinishMapping)])
                    [interaction didFinishMapping];
                
                [interactions setObject:interaction forKey:key];
            }
        }
    }
    
    self.interactions = interactions;
}

- (void)parseAccountType
{
    if ([self.membership.type isEqualToString:Plus])
    {
        self.accountType = VIMUserAccountTypePlus;
    }
    else if ([self.membership.type isEqualToString:Pro])
    {
        self.accountType = VIMUserAccountTypePro;
    }
    else if ([self.membership.type isEqualToString:Basic])
    {
        self.accountType = VIMUserAccountTypeBasic;
    }
    else if ([self.membership.type isEqualToString:Business])
    {
        self.accountType = VIMUserAccountTypeBusiness;
    }
    else if ([self.membership.type isEqualToString:LivePro])
    {
        self.accountType = VIMUserAccountTypeLivePro;
    }
    else if ([self.membership.type isEqualToString:LiveBusiness])
    {
        self.accountType = VIMUserAccountTypeLiveBusiness;
    }
    else if ([self.membership.type isEqualToString:LivePremium])
    {
        self.accountType = VIMUserAccountTypeLivePremium;
    }
    else if ([self.membership.type isEqualToString:ProUnlimited])
    {
        self.accountType = VIMUserAccountTypeProUnlimited;
    }
    else if ([self.membership.type isEqualToString:Producer])
    {
        self.accountType = VIMUserAccountTypeProducer;
    }
}

- (void)parseEmails
{
    NSMutableArray *parsedEmails = [[NSMutableArray alloc] init];
    
    for (NSDictionary *email in self.emails)
    {
        NSString *emailString = email[@"email"];
        
        if (emailString)
        {
            [parsedEmails addObject:emailString];
        }
    }
    
    self.userEmails = parsedEmails; 
}

- (void)formatCreatedTime
{
    if ([self.createdTime isKindOfClass:[NSString class]])
    {
        self.createdTime = [[VIMModelObject dateFormatter] dateFromString:(NSString *)self.createdTime];
    }
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

- (BOOL)hasModeratedChannels
{
    VIMConnection *connection = [self connectionWithName:VIMConnectionNameModeratedChannels];
    return (connection && connection.total.intValue > 0);
}

- (NSString *)accountTypeAnalyticsIdentifier
{
    switch (self.accountType)
    {
        default:
        case VIMUserAccountTypeBasic:
            return Basic;
        case VIMUserAccountTypePlus:
            return Plus;
        case VIMUserAccountTypePro:
            return Pro;
        case VIMUserAccountTypeBusiness:
            return Business;
        case VIMUserAccountTypeLivePro:
            return LivePro;
        case VIMUserAccountTypeLiveBusiness:
            return LiveBusiness;
        case VIMUserAccountTypeLivePremium:
            return LivePremium;
        case VIMUserAccountTypeProUnlimited:
            return ProUnlimited;
        case VIMUserAccountTypeProducer:
            return Producer;
    }
}

#pragma mark - Model Versioning

// This is only called for unarchived model objects [AH]

- (void)upgradeFromModelVersion:(NSUInteger)fromVersion toModelVersion:(NSUInteger)toVersion withCoder:(NSCoder *)aDecoder
{
    if ((fromVersion == 1 && toVersion == 2) || (fromVersion == 2 && toVersion == 3))
    {
        [self checkIntegrityOfPictureCollection];
    }
    
    if(fromVersion < 4)
    {
        [self updateMembershipInfo: aDecoder];
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

// For models prior to version 4, there was a computed property defined in VIMUser+Extension.swift named "membership" which returned a String
// value.  That computed property has been renamed to "localizedAccountName" and "membership" is now a property defined in VIMUser.h with a type
// of "UserMembership".  This means that during de-serialization, the wrong type will be put into membership and needs to be fixed.  We check to
// see if this mismatch has occurred and re-create a correct UserMembership object from the data we have in the decoder object.
// [MW] 1/18/19
- (void)updateMembershipInfo:(NSCoder *)aDecoder
{
    if(![self.membership isKindOfClass: [UserMembership self]])
    {
        self.membership = [[UserMembership alloc] init];
        
        VIMUserBadge *badge = [aDecoder decodeObjectForKey: @"badge"];
        self.membership.badge = badge;
        
        NSString *account = [aDecoder decodeObjectForKey: @"account"];
        self.membership.type = account;
        
        // Set new properties to nil since the data didn't exist at the time this model was serialized to disk.
        self.membership.display = nil;
        self.membership.subscription = nil;
    }
}

- (BOOL)hasSameBadgeCount:(VIMUser *)newUser
{
    VIMNotificationsConnection *currentAccountConnection = [self notificationsConnection];
    NSInteger currentAccountTotal = [currentAccountConnection supportedNotificationNewTotal];
    
    VIMNotificationsConnection *responseConnection = [newUser notificationsConnection];
    NSInteger responseTotal = [responseConnection supportedNotificationNewTotal];
    
    return currentAccountTotal == responseTotal;
}

- (BOOL)hasBeenInFreeTrial
{
    if([self.membership.subscription.trial.hasBeenInFreeTrial respondsToSelector: @selector(boolValue)] == NO)
    {
        NSAssert(NO, @"hasBeenInFreeTrial is expected to be an NSNumber and should respond to boolValue!");
        return NO;
    }
    
    return self.membership.subscription.trial.hasBeenInFreeTrial.boolValue;
}

@end
