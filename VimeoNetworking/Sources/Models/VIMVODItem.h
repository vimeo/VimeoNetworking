//
//  VIMVODItem.h
//  Vimeo
//
//  Created by Lehrer, Nicole on 5/18/16.
//  Copyright © 2016 Vimeo. All rights reserved.
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

@class VIMVideo;
@class VIMUser;
@class VIMConnection;
@class VIMPictureCollection;
@class VIMInteraction;

typedef NS_ENUM(NSUInteger, VIMVODItemType) {
    VIMVODItemTypeUnknown,
    VIMVODItemTypeSeries,
    VIMVODItemTypeFilm
};

@interface VIMVODItem : VIMModelObject

// MARK: Naming mirrors API (where names with underscores are mapped to camelCase)
@property (nonatomic, copy, nullable) NSString *link;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) VIMVideo *trailer;
@property (nonatomic, strong, nullable) VIMVideo *film;
@property (nonatomic, copy, nullable) NSString *uri;
@property (nonatomic, strong, nullable) VIMUser *user;
@property (nonatomic, copy, nullable) NSString *resourceKey;

// MARK: Naming is different than API - see implementation file for mapping
@property (nonatomic, copy, nullable) NSString *vodDescription;
@property (nonatomic, strong, nullable) VIMPictureCollection *pictureCollection;
@property (nonatomic, assign) VIMVODItemType itemType;
@property (nonatomic, strong, nullable) NSDate *publishDate;

- (VIMConnection * _Nullable)connectionWithName:(NSString * _Nullable)connectionName;
- (VIMInteraction * _Nullable)interactionWithName:(NSString * _Nullable)name;
- (NSNumber * _Nullable)videosTotal;
- (NSNumber * _Nullable)viewableVideosTotal;
- (NSNumber * _Nullable)mainVideosTotal;
- (NSNumber * _Nullable)extraVideosTotal;
- (NSString * _Nullable)videosURI;
- (BOOL) canRent;
- (BOOL) canSubscribe;
- (BOOL) canBuy;

@end
