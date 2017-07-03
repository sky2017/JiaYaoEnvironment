//
//  liebiaoCollectionViewCell.h
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface liebiaoCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageAll;
@property (nonatomic,strong)UILabel *labelB;
@property (nonatomic,assign)float scale;
@property (nonatomic,strong)UIView *ViewB;
-(CGFloat)getScale;
@end
