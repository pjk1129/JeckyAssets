//
//  QBPhotoView.m
//  JeckyAssets
//
//  Created by Jecky on 14-10-12.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "QBPhotoView.h"

@implementation QBPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setMaximumZoomScale:2.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];

    }
    return self;
}

@end
