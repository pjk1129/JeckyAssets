//
//  QBAssetsCollectionViewCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewCell.h"

// Views
#import "QBAssetsCollectionOverlayView.h"
#import "QBAssetsCollectionVideoIndicatorView.h"

@interface QBAssetsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QBAssetsCollectionOverlayView *overlayView;
@property (nonatomic, strong) QBAssetsCollectionVideoIndicatorView *videoIndicatorView;

@property (nonatomic, strong) UIImage *blankImage;

@end

@implementation QBAssetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsOverlayViewWhenSelected = YES;
        
        // Create a image view
        [self imageView];
        [self videoIndicatorView];
        [self overlayView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    if (selected && self.showsOverlayViewWhenSelected) {
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}


#pragma mark - Overlay View
- (void)showOverlayView
{
    self.overlayView.hidden = NO;
}

- (void)hideOverlayView
{
    self.overlayView.hidden = YES;

}

#pragma mark - Video Indicator View
- (void)showVideoIndicatorView
{
    self.videoIndicatorView.hidden = NO;
}

- (void)hideVideoIndicatorView
{
    self.videoIndicatorView.hidden = YES;
}

#pragma mark - setter/getter
- (void)setAsset:(ALAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
        
        // Update view
        CGImageRef thumbnailImageRef = [asset thumbnail];
        
        if (thumbnailImageRef) {
            self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
        } else {
            self.imageView.image = [self blankImage];
        }
        
        // Show video indicator if the asset is video
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
            double duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            self.videoIndicatorView.duration = round(duration);
            
            [self showVideoIndicatorView];
        } else {
            [self hideVideoIndicatorView];
        }
    }

}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _blankImage;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (QBAssetsCollectionOverlayView *)overlayView{
    if (!_overlayView) {
        _overlayView = [[QBAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.hidden = YES;
        [self.contentView addSubview:_overlayView];
    }
    return _overlayView;
}

- (QBAssetsCollectionVideoIndicatorView *)videoIndicatorView{
    if (!_videoIndicatorView) {
        CGFloat height = 19.0;
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height);
        _videoIndicatorView = [[QBAssetsCollectionVideoIndicatorView alloc] initWithFrame:frame];
        _videoIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _videoIndicatorView.hidden = YES;
        [self.contentView addSubview:_videoIndicatorView];
    }
    return _videoIndicatorView;
}

@end
