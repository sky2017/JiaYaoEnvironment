//
//  wodeTableViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "wodeTableViewCell.h"

@implementation wodeTableViewCell
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
    
    _labelRight=[[UILabel alloc]init];
    _labelRight.textColor=blackTextColor;
    _labelRight.font=DefaultFont(self.scale);
    [self addSubview:_labelRight];
    
    _imageRight=[[UIImageView alloc]init];
    _imageRight.image=[UIImage imageNamed:@"arrow_rightkk"];
    [self addSubview:_imageRight];
    _viewxian=[[UIView alloc]init];
    _viewxian.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self addSubview:_viewxian];
}
-(void)layoutSubviews{
    _imageLeft.frame=CGRectMake(30/2.34*self.scale, (self.height-60/2.34*self.scale)/2, 60/2.34*self.scale, 60/2.34*self.scale);
    _labelRight.frame=CGRectMake(_imageLeft.right+20/2.34*self.scale, 0, self.width-_imageLeft.right-65/2.34*self.scale, self.height);
    _imageRight.frame=CGRectMake(self.width-65/2.34*self.scale, (self.height-48/2.34*self.scale)/2, 48/2.34*self.scale, 48/2.34*self.scale);
    _viewxian.frame=CGRectMake(110/2.34*self.scale, self.height-.5, self.width-110/2.34*self.scale, .5);
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
