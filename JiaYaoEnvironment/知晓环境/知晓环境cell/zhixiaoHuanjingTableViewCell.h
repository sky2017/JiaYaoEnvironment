//
//  zhixiaoHuanjingTableViewCell.h
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@protocol ZhixiaoCarCellDelegate<NSObject>
@optional
-(void)seeItem:(NSIndexPath*)path;
@end
@interface zhixiaoHuanjingTableViewCell : SuperTableViewCell
@property (nonatomic,strong)UIImageView *imageLeft;
@property (nonatomic,strong)UILabel *labelTitle;
@property (nonatomic,strong)UILabel *labelTimer;
@property (nonatomic,strong)UIButton *buttonsee;
@property (nonatomic,strong)UIView *viewxian;
@property (nonatomic,copy)NSString *seeNum;
@property (nonatomic,assign)CGFloat floatsee;
@property(nonatomic,weak)id<ZhixiaoCarCellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
