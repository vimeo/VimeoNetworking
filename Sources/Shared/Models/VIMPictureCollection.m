//
//  VIMPictureCollection.m
//  VimeoNetworking
//
//  Created by Whitcomb, Andrew on 9/4/14.
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

#import "VIMPictureCollection.h"
#import "VIMPicture.h"

@interface VIMPictureCollection ()

@property (strong, nonatomic) NSNumber *active;
@property (nonatomic, readwrite) BOOL isActive;

@end

@implementation VIMPictureCollection

- (VIMPicture *)pictureForWidth:(float)width
{
    if (self.pictures.count == 0)
        return nil;
    
    if (width < 1)
    {
        width = 1;
    }
    
    VIMPicture *selectedPicture = [self.pictures lastObject];
    
    for (VIMPicture *picture in self.pictures)
    {
        if (picture.width.floatValue >= width && fabs(picture.width.floatValue - width) < fabs(selectedPicture.width.floatValue - width))
        {
            selectedPicture = picture;
        }
    }
    
    return selectedPicture;
}

- (VIMPicture *)pictureForHeight:(float)height
{
    if (self.pictures.count == 0)
        return nil;
    
    if (height < 1)
    {
        height = 1;
    }
    
    VIMPicture *selectedPicture = [self.pictures lastObject];
    
    for( VIMPicture *picture in self.pictures)
    {
        if (picture.height.floatValue >= height && fabs(picture.height.floatValue - height) < fabs(selectedPicture.height.floatValue - height))
        {
            selectedPicture = picture;
        }
    }
    
    return selectedPicture;
}

#pragma mark - VIMMappable

- (NSDictionary *)getObjectMapping
{
    return @{@"sizes": @"pictures"};
}

- (Class)getClassForCollectionKey:(NSString *)key
{
    if ( [key isEqualToString:@"sizes"] )
    {
        return [VIMPicture class];
    }
    
    return nil;
}

- (void)didFinishMapping
{
    if (self.active && [self.active isKindOfClass:[NSNumber class]])
    {
        self.isActive = [self.active boolValue];
    }
}

@end
