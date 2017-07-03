//
//  chanpinzhanshiTableViewCell.h
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@protocol ShopingCarCellDelegate<NSObject>
@optional
-(void)seeItem:(NSIndexPath*)path;
-(void)shoucangItem:(NSIndexPath*)path;

@end
@interface chanpinzhanshiTableViewCell : SuperTableViewCell
@property (nonatomic,strong)UIImageView *imageLeft;
@property (nonatomic,strong)UILabel *labelTop;
@property (nonatomic,strong)UILabel *labelMoney;
@property (nonatomic,strong)UIButton *buttonsee;
@property (nonatomic,strong)UIButton *buttonshoucang;
@property (nonatomic,strong)UIView *viewxian;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<ShopingCarCellDelegate>delegate;
@property (nonatomic,copy)NSString *seeNum;
@property (nonatomic,copy)NSString *shocangNum;
@property (nonatomic,assign)CGFloat reminderseeNum;
@property (nonatomic,assign)BOOL isshoucang;
@property (nonatomic,assign)CGFloat remindershoucangNum;
@end
