//
//  pinpaixuanzeDataTableViewCell.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "pinpaixuanzeDataTableViewCell.h"

@implementation pinpaixuanzeDataTableViewCell
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
    _labelLeft.textColor=black102color;
    _labelLeft.font=DefaultFont(self.scale);
    [self addSubview:_labelLeft];
    
    _imageRight=[[UIImageView alloc]init];
    _imageRight.image=[UIImage imageNamed:@"icon_duihao"];
    [self addSubview:_imageRight];
    
    _viebottom=[[UIView alloc]init];
    _viebottom.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    [self addSubview:_viebottom];
}
-(void)layoutSubviews{
    _labelLeft.frame=CGRectMake(40/2.34*self.scale, 0, self.width-108/2.34*self.scale, self.height);
    _viebottom.frame=CGRectMake(0, self.height-.5, self.width, .5);
    _imageRight.frame=CGRectMake(self.width-65/2.34*self.scale, (self.height-35/2.34*self.scale)/2, 35/2.34*self.scale, 35/2.34*self.scale);
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
