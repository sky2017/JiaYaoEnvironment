//
//  gonggaoTableViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "gonggaoTableViewCell.h"

@implementation gonggaoTableViewCell
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
    _labelLeft=[[UILabel alloc]init];
    _labelLeft.textColor=blackTextColor;
    _labelLeft.font=DefaultFont(self.scale);
    [self addSubview:_labelLeft];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = DefaultFont(self.scale);
    [self addSubview:_timeLabel];
    
    _imageRight=[[UIImageView alloc]init];
    _imageRight.image=[UIImage imageNamed:@"arrow_rightkk"];
    [self addSubview:_imageRight];
    
    _viewxian=[[UIView alloc]init];
    _viewxian.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    [self addSubview:_viewxian];
}

-(void)layoutSubviews{
//    _labelLeft.frame=CGRectMake(30/2.34*self.scale, 0,self.width-95/2.34*self.scale, self.height-50/2.34*self.scale);
    _labelLeft.frame=CGRectMake(30/2.34*self.scale, (self.height-50/2.34*self.scale)/2,self.width-95/2.34*self.scale-184/2.34*self.scale, 50/2.34*self.scale);
     _imageRight.frame=CGRectMake(self.width-65/2.34*self.scale, (self.height-48/2.34*self.scale)/2, 48/2.34*self.scale, 48/2.34*self.scale);
    _timeLabel.frame = CGRectMake(self.width-234/2.34*self.scale,(self.height-50/2.34*self.scale)/2,184/2.34*self.scale ,50/2.34*self.scale );
    _viewxian.frame=CGRectMake(0, self.height-.5, self.width, .5);
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
