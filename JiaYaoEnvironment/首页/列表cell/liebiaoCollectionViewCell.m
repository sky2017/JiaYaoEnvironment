//
//  liebiaoCollectionViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "liebiaoCollectionViewCell.h"
#import "superclassViewController.h"
@implementation liebiaoCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
     if (self) {
         [self getScale];
         self.imageAll=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width, self.height)];
         [self addSubview:self.imageAll];
         self.labelB=[[UILabel alloc]initWithFrame:CGRectMake(0, self.height-80/2.34*self.scale, self.width, 80/2.34*self.scale)];
         self.ViewB = [[UIView alloc]initWithFrame:self.labelB.frame];
         self.ViewB.backgroundColor = [UIColor blackColor];
         self.ViewB.layer.opacity = 0.2;
         self.labelB.font=Big14Font(self.scale);
         self.labelB.textColor=[UIColor whiteColor];
         
         self.labelB.backgroundColor=[UIColor clearColor];

         self.labelB.textAlignment=NSTextAlignmentCenter;
         self.layer.borderColor=black204Color.CGColor;
         self.layer.borderWidth=.5;
         [self addSubview:self.ViewB];
         [self addSubview:self.labelB];
     }
       return self;
}
-(CGFloat)getScale
{
    //获取高度的比例
    _scale = 1;
    if ([[UIScreen mainScreen] bounds].size.height!= 480) {
        _scale = [[UIScreen mainScreen] bounds].size.height / 568;
    }
    return _scale;
}
@end
