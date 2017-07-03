//
//  BrandCollectionViewCell.m
//  JiaYaoEnvironment
//
//  Created by 清溪 on 2017/6/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BrandCollectionViewCell.h"

@implementation BrandCollectionViewCell




-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:self.bounds];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.label.textAlignment = NSTextAlignmentCenter;
        
        self.label.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}


@end
