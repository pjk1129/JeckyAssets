//
//  QBImageBrowseViewController.h
//  JeckyAssets
//
//  Created by Jecky on 14-10-12.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class QBImageBrowseViewController;

@protocol QBImageBrowseViewControllerDelegate <NSObject>

@optional
- (void)assetsImageBrowseViewController:(QBImageBrowseViewController *)imageBrowseController didSelectAsset:(ALAsset *)asset didFinishEditedImag:(UIImage *)image;

@end

@interface QBImageBrowseViewController : UIViewController

@property (nonatomic, weak) id<QBImageBrowseViewControllerDelegate> delegate;

@property (nonatomic, strong) ALAsset *asset;

@end
