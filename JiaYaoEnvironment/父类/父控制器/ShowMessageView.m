//
//  ShowMessageView.m
//  JiaYaoEnvironment
//
//  Created by 清溪 on 2017/5/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShowMessageView.h"

@implementation ShowMessageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.frame;
        [self addSubview:visualEffectView];
        
//        self.informationTableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
