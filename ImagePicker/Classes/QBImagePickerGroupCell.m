//
//  QBImagePickerGroupCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerGroupCell.h"

// Views
#import "QBImagePickerThumbnailView.h"

@interface QBImagePickerGroupCell ()

@property (nonatomic, strong) QBImagePickerThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation QBImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Cell settings
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Create thumbnail view
        [self thumbnailView];
        
        // Create name label
        [self nameLabel];
        
        // Create count label
        [self countLabel];
    }
    
    return self;
}


#pragma mark - setter
- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    if (_assetsGroup != assetsGroup) {
        _assetsGroup = assetsGroup;
        
        // Update thumbnail view
        self.thumbnailView.assetsGroup = _assetsGroup;
        
        // Update label
        self.nameLabel.text = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)[_assetsGroup numberOfAssets]];
    }
}

#pragma mark - getter
- (QBImagePickerThumbnailView *)thumbnailView{
    if (!_thumbnailView) {
        _thumbnailView = [[QBImagePickerThumbnailView alloc] initWithFrame:CGRectMake(8, 4, 70, 74)];
        _thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:_thumbnailView];
    }
    return _thumbnailView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 22, 180, 21)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 + 70 + 18, 46, 180, 15)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

@end
