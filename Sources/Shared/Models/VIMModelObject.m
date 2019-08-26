//
//  VIMModelObject.m
//  VIMObjectMapper
//
//  Created by Kashif Mohammad on 6/5/13.
//  Copyright (c) 2014-2016 Vimeo (https://vimeo.com)
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

#import "VIMModelObject.h"

#import <objc/runtime.h>

/*
 Model Changelog
 
 Version 4: Updated VIMUser object based on API version 3.4.2
    - Removes user badge & account string from root level of VIMUser object
    - Adds UserMembership object which now holds badge & account info along with new subscription info
 */
static NSUInteger const VIMModelObjectVersion = 4;

NSString *const VIMModelObjectErrorDomain = @"VIMModelObjectErrorDomain";
NSString *const VIMConnectionKey = @"connections";
NSString *const VIMInteractionKey = @"interactions";
NSInteger const VIMModelObjectValidationErrorCode = 10101;

@implementation VIMModelObject

+ (NSUInteger)modelVersion
{
	return VIMModelObjectVersion;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    });
    
    return dateFormatter;
}

#pragma mark - KeyValueDictionary creation

- (instancetype)initWithKeyValueDictionary:(NSDictionary *)dictionary
{
	self = [self init];
    if (self)
    {
        NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"Can't initilize model object with invalid dictionary");
        
        for (NSString *key in dictionary)
        {
            id value = [dictionary objectForKey:key];
            
            if ([value isEqual:NSNull.null] || [value isKindOfClass:[NSNull class]])
            {
                value = nil;
            }
            
            [self setValue:value forKey:key];
        }
    }
	
	return self;
}

- (NSDictionary *)keyValueDictionary
{
	return [self dictionaryWithValuesForKeys:self.class.propertyKeys.allObjects];
}

#pragma mark - VIMMappable

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@: Undefined Key '%@'", NSStringFromClass(self.class), key);
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	NSNumber *modelVersion = [aDecoder decodeObjectForKey:@"modelVersion"];

	if (modelVersion.unsignedIntegerValue > self.class.modelVersion)
	{
		NSLog(@"%@:initWithCoder: Could not unarchive %@. Unsupported model version %ld", NSStringFromClass(self.class), self.class, (unsigned long)modelVersion.unsignedIntegerValue);
		
        return nil;
	}
	
	NSSet *propertyKeys = self.class.propertyKeys;
	NSMutableDictionary *KVDictionary = [[NSMutableDictionary alloc] initWithCapacity:propertyKeys.count];
	
	for (NSString *key in propertyKeys)
	{
		id value = [aDecoder decodeObjectForKey:key];
		
        if (value == nil)
        {
            continue;
        }
		
		KVDictionary[key] = value;
	}
	
	self = [self initWithKeyValueDictionary:KVDictionary];
	if (self == nil)
    {
        NSLog(@"%@:initWithCoder: Could not unarchive %@", NSStringFromClass(self.class), self.class);
    }
    else
    {
        if (modelVersion.unsignedIntegerValue < self.class.modelVersion)
        {
            [self upgradeFromModelVersion: modelVersion.unsignedIntegerValue
                           toModelVersion: self.class.modelVersion
                                withCoder: aDecoder];
        }
    }
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:@(self.class.modelVersion) forKey:@"modelVersion"];
	
	[self.keyValueDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {

        if ([value respondsToSelector:@selector(encodeWithCoder:)])
        {
            [aCoder encodeObject:value forKey:key];
        }
        
	}];
}

- (void)upgradeFromModelVersion:(NSUInteger)fromVersion toModelVersion:(NSUInteger)toVersion withCoder:(NSCoder *)aDecoder
{
    // Override in subclasses
}

#pragma mark - Model Validation

- (BOOL)validateModel:(NSError **)error
{
    *error = nil;
    return YES;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
	return [[self.class allocWithZone:zone] initWithKeyValueDictionary:self.keyValueDictionary];
}

#pragma mark - Class Property Enumeration

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
{
	Class selfClass = self;
	BOOL stop = NO;
	
	while (!stop && ![selfClass isEqual:VIMModelObject.class])
	{
		unsigned count = 0;
		objc_property_t *properties = class_copyPropertyList(selfClass, &count);
		
		selfClass = selfClass.superclass;
		
        if (properties == NULL)
        {
            continue;
        }
		
		for (unsigned i = 0; i < count; i++)
		{
			block(properties[i], &stop);
			
            if (stop)
			{
                if (properties)
                {
                    free(properties);
                    properties = NULL;
                }

				break;
			}
		}

        if (properties)
        {
            free(properties);
            properties = NULL;
        }
	}
}

+ (NSSet *)propertyKeys
{
	NSSet *cachedKeys = objc_getAssociatedObject(self, @"VIMModelObject_propertyKeys");
	
    if (cachedKeys != nil)
    {
        return cachedKeys;
    }
    
	NSMutableSet *keys = [NSMutableSet set];
	
	[self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
		NSString *key = @(property_getName(property));
		[keys addObject:key];
	}];
	
	objc_setAssociatedObject(self, @"VIMModelObject_propertyKeys", keys, OBJC_ASSOCIATION_COPY);
	
	return keys;
}

@end
