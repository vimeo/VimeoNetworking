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
#import "VIMConnection.h"
#import "VIMInteraction.h"
#import "VIMPictureCollection.h"
#import "VIMPicture.h"
#import "VIMPreference.h"
#import "VIMUploadQuota.h"
#import "VIMUserBadge.h"

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

- (void)parseAccountType
{
    if ([self.account isEqualToString:@"plus"])
    {
        self.accountType = VIMUserAccountTypePlus;
    }
    else if ([self.account isEqualToString:@"pro"])
    {
        self.accountType = VIMUserAccountTypePro;
    }
    else if ([self.account isEqualToString:@"basic"])
    {
        self.accountType = VIMUserAccountTypeBasic;
    }
    else if ([self.account isEqualToString:@"business"])
    {
        self.accountType = VIMUserAccountTypeBusiness;
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

- (BOOL)hasCopyrightMatch
{
    VIMConnection *connection = [self connectionWithName:VIMConnectionNameViolations];
    return (connection && connection.total.intValue > 0);
}

- (BOOL)isFollowing
{
    VIMInteraction *interaction = [self interactionWithName:VIMInteractionNameFollow];
    return (interaction && interaction.added.boolValue);
}

- (NSString *)accountTypeAnalyticsIdentifier
{
    switch (self.accountType)
    {
        default:
        case VIMUserAccountTypeBasic:
            return @"basic";
        case VIMUserAccountTypePlus:
            return @"plus";
        case VIMUserAccountTypePro:
            return @"pro";
        case VIMUserAccountTypeBusiness:
            return @"business";
    }
}

#pragma mark - Model Versioning

// This is only called for unarchived model objects [AH]

- (void)upgradeFromModelVersion:(NSUInteger)fromVersion toModelVersion:(NSUInteger)toVersion
{
    if ((fromVersion == 1 && toVersion == 2) || (fromVersion == 2 && toVersion == 3))
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

@end
