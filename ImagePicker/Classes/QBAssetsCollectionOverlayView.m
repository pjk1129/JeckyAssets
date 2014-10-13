//
//  QBAssetsCollectionOverlayView.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2014/01/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionOverlayView.h"
#import <QuartzCore/QuartzCore.h>

// Views
#import "QBAssetsCollectionCheckmarkView.h"

@interface QBAssetsCollectionOverlayView ()

@property (nonatomic, strong) QBAssetsCollectionCheckmarkView *checkmarkView;

@end

@implementation QBAssetsCollectionOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        // Create a checkmark view
        [self checkmarkView];
    }
    
    return self;
}

- (QBAssetsCollectionCheckmarkView *)checkmarkView{
    if (!_checkmarkView) {
        _checkmarkView = [[QBAssetsCollectionCheckmarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0), self.bounds.size.height - (4.0 + 24.0), 24.0, 24.0)];
        _checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        _checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        _checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        _checkmarkView.layer.shadowOpacity = 0.6;
        _checkmarkView.layer.shadowRadius = 2.0;
        [self addSubview:_checkmarkView];
    }
    return _checkmarkView;
}

@end
