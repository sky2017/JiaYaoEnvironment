//
//  zhixiaoHuanjingTableViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "zhixiaoHuanjingTableViewCell.h"

@implementation zhixiaoHuanjingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.selectionStyle=0;
        [self newView];
    }
    return self;
}
-(void)newView
{
    _imageLeft=[[UIImageView alloc]init];
    [self addSubview:_imageLeft];
    
    _labelTitle=[[UILabel alloc]init];
    _labelTitle.textColor=blackTextColor;
    _labelTitle.font=Big14Font(self.scale);
    _labelTitle.numberOfLines=0;
    _labelTitle.contentMode=NSLineBreakByCharWrapping;
    [self addSubview:_labelTitle];
    
    _labelTimer=[[UILabel alloc]init];
    _labelTimer.textColor=black153Color;
    _labelTimer.font=SmallFont(self.scale);
    _labelTimer.numberOfLines=0;
    [self addSubview:_labelTimer];
    
    _buttonsee=[[UIButton alloc]init];
    _buttonsee.titleLabel.font=SmallFont(self.scale);
   [_buttonsee setTitleColor:blackTextColor forState:UIControlStateNormal];
    [_buttonsee setImage:[UIImage imageNamed:@"icon_eyesk"] forState:UIControlStateNormal];
    [_buttonsee addTarget:self action:@selector(see) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonsee];
    _viewxian=[[UIView alloc]init];
    _viewxian.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self addSubview:_viewxian];

}
-(void)setSeeNum:(NSString *)seeNum
{
    if(seeNum)
    {
    CGSize size=[NSString getLabelText:seeNum getLabelSize:CGSizeMake(MAXFLOAT, MAXFLOAT) getTextFont:[UIFont systemFontOfSize:12*self.scale]];
    self.floatsee=size.width;
    }
}
-(void)see
{
    //判断deleItem:这个代理方法是否被调用过.
    if([self.delegate respondsToSelector:@selector(seeItem:)])
    {
        [self.delegate seeItem:_indexPath];
    }
    }
-(void)layoutSubviews{
    _imageLeft.frame=CGRectMake(20/2.34*self.scale, 20/2.34*self.scale, 220/2.34*self.scale, 150/2.34*self.scale);
    _labelTitle.frame=CGRectMake(_imageLeft.right+20/2.34*self.scale, _imageLeft.top, self.width-_imageLeft.right-40/2.34*self.scale, 90/2.34*self.scale);
    _labelTimer.frame=CGRectMake(_labelTitle.left, _labelTitle.bottom+20/2.34*self.scale, _labelTitle.width/2, 40/2.34*self.scale);
    _buttonsee.frame=CGRectMake(self.width-self.floatsee-70/2.34*self.scale, _labelTimer.top, self.floatsee+50/2.34*self.scale, _labelTimer.height);
    _viewxian.frame=CGRectMake(20/2.34*self.scale, self.height-.5, self.width-40/2.34*self.scale, .5);

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
