//
//  chanpinzhanshiTableViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "chanpinzhanshiTableViewCell.h"

@implementation chanpinzhanshiTableViewCell
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
    _imageLeft.layer.borderWidth=1;
    _imageLeft.layer.borderColor=black204Color.CGColor;
    [self addSubview:_imageLeft];
    
    _labelTop=[[UILabel alloc]init];
    _labelTop.textColor=blackTextColor;
    _labelTop.font=DefaultFont(self.scale);
    _labelTop.numberOfLines=0;
    [self addSubview:_labelTop];
    _labelMoney=[[UILabel alloc]init];
    _labelMoney.textColor=textColorred;
    _labelMoney.font=DefaultFont(self.scale);
    [self addSubview:_labelMoney];
    
    _buttonsee=[[UIButton alloc]init];
    _buttonsee.titleLabel.font=SmallFont(self.scale);
       _buttonsee.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_buttonsee setTitleColor:blackTextColor forState:UIControlStateNormal];
     [_buttonsee setImage:[UIImage imageNamed:@"icon_eyesk"] forState:UIControlStateNormal];
    [_buttonsee addTarget:self action:@selector(see) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonsee];
    
    _buttonshoucang=[[UIButton alloc]init];
//    _buttonshoucang = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonshoucang.titleLabel.font=SmallFont(self.scale);
    _buttonshoucang.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_buttonshoucang setTitleColor:blackTextColor forState:UIControlStateNormal];
      [_buttonshoucang setImage:[UIImage imageNamed:@"icon_lvkongxin"] forState:UIControlStateNormal];

    [_buttonshoucang setImage:[UIImage imageNamed:@"icon_lvxin"] forState:UIControlStateSelected];
    
    [_buttonshoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buttonshoucang];
    _viewxian=[[UIView alloc]init];
    _viewxian.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self addSubview:_viewxian];
}
-(void)setSeeNum:(NSString *)seeNum
{
if(seeNum)
{
    CGSize size=[NSString getLabelText:seeNum getLabelSize:CGSizeMake(MAXFLOAT, MAXFLOAT) getTextFont:[UIFont systemFontOfSize:12*self.scale]];
    self.reminderseeNum=size.width;
}
}

-(void)setShocangNum:(NSString *)shocangNum
{
    if(shocangNum)
    {
        CGSize size=[NSString getLabelText:shocangNum getLabelSize:CGSizeMake(MAXFLOAT, MAXFLOAT) getTextFont:[UIFont systemFontOfSize:12*self.scale]];
        self.remindershoucangNum=size.width;
    }
}
-(void)layoutSubviews{
    _imageLeft.frame=CGRectMake(30/2.34*self.scale, 40/2.34*self.scale, 185/2.34*self.scale, 185/2.34*self.scale);
    _labelTop.frame=CGRectMake(_imageLeft.right+20/2.34*self.scale, _imageLeft.top, self.width-_imageLeft.right-50/2.34*self.scale, 100/2.34*self.scale);
    _labelMoney.frame=CGRectMake(_labelTop.left, _labelTop.bottom, _labelTop.width, 48/2.34*self.scale);
    _buttonshoucang.frame=CGRectMake(self.width-78/2.34*self.scale-self.remindershoucangNum,_labelMoney.bottom,_remindershoucangNum+40/2.34*self.scale, 42/2.34*self.scale);
    _buttonsee.frame=CGRectMake(_buttonshoucang.left-78/2.34*self.scale-_reminderseeNum, _labelMoney.bottom,_reminderseeNum+40/2.34*self.scale, 40/2.34*self.scale);
    _viewxian.frame=CGRectMake(30/2.34*self.scale, self.height-.5, self.width-60/2.34*self.scale, .5);
}
-(void)see
{
    //判断deleItem:这个代理方法是否被调用过.
    if([self.delegate respondsToSelector:@selector(seeItem:)])
    {
        [self.delegate seeItem:_indexPath];
    }
}
-(void)shoucang
{
//    _buttonshoucang.selected = !_buttonshoucang.selected;
    
    //判断deleItem:这个代理方法是否被调用过.
    if([self.delegate respondsToSelector:@selector(shoucangItem:)])
    {
        [self.delegate shoucangItem:_indexPath];
        
    }

    
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
