//
//  ProgressHudobject.h
//  LiuQiangDemo
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface ProgressHudobject : NSObject
@property (nonatomic,strong)MBProgressHUD *hud;
//菊花旋转下面是字体.
-(void)singleProgress;
-(void)stop;
//只显示字体
-(void)showTextProgress:(NSString *)text;
-(void)textstop;
//上面显示图片,下面显示文字.
-(void)showTextImage:(NSString *)text sendImage:(UIImage *)image;
-(void)textImagestop;
@end
