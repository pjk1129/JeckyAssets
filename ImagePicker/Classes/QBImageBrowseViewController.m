//
//  QBImageBrowseViewController.m
//  JeckyAssets
//
//  Created by Jecky on 14-10-12.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "QBImageBrowseViewController.h"

#define kQBImageScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kQBImageScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface QBImageBrowseViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIImageView    *imageView;
@property (nonatomic, strong) UIView    *bottomView;
@end

@implementation QBImageBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"移动和缩放";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDidTouched)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self imageView];
    [self bottomView];

    CGRect frame;
    
    CALayer  *layer = [CALayer layer];
    if (kQBImageScreenHeight<500) {
        frame = CGRectMake(0, self.view.bounds.size.height-CGRectGetHeight(self.bottomView.frame)-kQBImageScreenWidth-40, kQBImageScreenWidth, kQBImageScreenWidth);
    }else{
        frame = CGRectMake(0, self.view.center.y-kQBImageScreenWidth/2, kQBImageScreenWidth, kQBImageScreenWidth);
    }
    layer.frame = frame;
    self.scrollView.frame = frame;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    UIImage  *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    UIImage  *img = nil;
    if (image.size.width>image.size.height) {
        img = [self image:image fitToHeight:kQBImageScreenWidth];
    }else{
        img = [self image:image fitToWidth:kQBImageScreenWidth];
    }

    self.imageView.image = img;
    self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    self.scrollView.contentSize = CGSizeMake(img.size.width, img.size.height);
    self.scrollView.contentOffset = CGPointMake((img.size.width-self.scrollView.bounds.size.width)/2,
                                                (img.size.height-self.scrollView.bounds.size.height)/2);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)back
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerDidTouched
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsImageBrowseViewController:didSelectAsset:didFinishEditedImag:)]) {
        
        UIImage  *image = [self imageByRenderInContextWithView:self.view atFrame:CGRectMake(1, self.view.center.y-kQBImageScreenWidth/2, kQBImageScreenWidth-2, kQBImageScreenWidth-2)];
        [self.delegate assetsImageBrowseViewController:self didSelectAsset:self.asset didFinishEditedImag:image];
    }
}

- (UIImage*)imageByRenderInContextWithView:(UIView *)theView atFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [theView.layer renderInContext:context];
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef  imageRef = CGImageCreateWithImageInRect(temp.CGImage, rect);
    UIImage *theImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return  theImage;
}

- (UIImage*)image:(UIImage*)image fitToWidth:(CGFloat)width
{
    CGSize newSize = image.size;
    CGFloat scale;
    if (newSize.width != 0) {
        scale = width/newSize.width;
    } else {
        return nil;
    }
    return [self image:image drawInRect:CGRectMake(0, 0, width, newSize.height*scale)];
}

- (UIImage*)image:(UIImage*)image fitToHeight:(CGFloat)height
{
    CGSize newSize = image.size;
    CGFloat scale;
    if (newSize.height != 0) {
        scale = height/newSize.height;
    } else {
        return nil;
    }
    return [self image:image drawInRect:CGRectMake(0, 0, newSize.width*scale, height)];
}

- (UIImage *)image:(UIImage *)image drawInRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UIScrollView Delegate method
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.center.y-kQBImageScreenWidth/2, kQBImageScreenWidth, kQBImageScreenWidth)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;        
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 2.0f;
        _scrollView.clipsToBounds = NO;
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-60, kQBImageScreenWidth, 60)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2f];
        _bottomView.userInteractionEnabled = YES;
        
        UILabel  *cancel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 60, 30)];
        cancel.backgroundColor = [UIColor clearColor];
        cancel.textAlignment = NSTextAlignmentLeft;
        cancel.textColor = [UIColor whiteColor];
        cancel.userInteractionEnabled = YES;
        cancel.font = [UIFont systemFontOfSize:17.0f];
        cancel.text = @"取消";
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
        [cancel addGestureRecognizer:tap];
        [_bottomView addSubview:cancel];
        
        UILabel  *picker = [[UILabel alloc] initWithFrame:CGRectMake(kQBImageScreenWidth-70, 15, 60, 30)];
        picker.backgroundColor = [UIColor clearColor];
        picker.textAlignment = NSTextAlignmentRight;
        picker.textColor = [UIColor whiteColor];
        picker.userInteractionEnabled = YES;
        picker.font = [UIFont systemFontOfSize:17.0f];
        picker.text = @"选取";
        UITapGestureRecognizer  *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerDidTouched)];
        [picker addGestureRecognizer:tap1];
        [_bottomView addSubview:picker];

        
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

@end
