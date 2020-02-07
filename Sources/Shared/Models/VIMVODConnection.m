//
//  VIMVODConnection.m
//  Pods
//
//  Created by Guhit, Fiel on 3/9/17.
//
//

#import "VIMVODConnection.h"

@interface VIMVODConnection ()

@property (nonatomic, strong, nullable) NSNumber *extra_total;
@property (nonatomic, strong, nullable) NSNumber *main_total;
@property (nonatomic, strong, nullable) NSNumber *viewable_total;

@end

@implementation VIMVODConnection

- (void)didFinishMapping
{
    [super didFinishMapping];

    self.extraVideosCount = self.extra_total;
    self.mainVideosCount = self.main_total;
    self.viewableVideosCount = self.viewable_total;
}

@end
