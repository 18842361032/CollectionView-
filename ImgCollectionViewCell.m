//
//  ImgCollectionViewCell.m
//  CollectionView多选删除图片
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 Danae. All rights reserved.
//

#import "ImgCollectionViewCell.h"

@implementation ImgCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)createSubViews
{
    self.img = [[UIImageView alloc] init];
    self.img.userInteractionEnabled = YES;
    self.img.backgroundColor = [UIColor redColor];
    self.img.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    [self.contentView addSubview:_img];
    
    self.selectedImg = [[UIImageView alloc] init];
    self.selectedImg.frame = CGRectMake(self.img.frame.size.width - 25, self.img.frame.size.height - 25, 25, 25);
    [self.contentView addSubview:self.selectedImg];
}

@end
