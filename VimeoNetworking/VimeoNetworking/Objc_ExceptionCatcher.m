//
//  ObjC_ExceptionCatcher.m
//  VimeoNetworking
//
//  Created by Huebner, Rob on 4/26/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

#import "Objc_ExceptionCatcher.h"

@implementation ObjC_ExceptionCatcher

+ (nullable NSError *)_doUnsafe:(nonnull void(^)(void))unsafeBlock
{
    @try
    {
        if (unsafeBlock)
        {
            unsafeBlock();
        }
    }
    @catch (NSException *exception)
    {
        return [NSError errorWithDomain:exception.name code:0 userInfo:@{NSLocalizedDescriptionKey: exception.description}];
    }
    
    return nil;
}

@end
