//
//  ProgressHudobject.m
//  LiuQiangDemo
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ProgressHudobject.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@implementation ProgressHudobject
//菊花旋转下面是字体.
-(void)singleProgress
{
    if(_hud)
    {
        [_hud removeFromSuperview];
    }
    //加载数据 添加到最顶层
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    //显示转圈的背景透明度
    //_hud.bezelView.alpha=0.5;
    //显示字体的颜色大小以及显示类型.
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text=@"加载中...";
    _hud.label.textColor=[UIColor whiteColor];
    _hud.label.font=[UIFont systemFontOfSize:13*[self scale]];
    //控制背景框的颜色
    _hud.bezelView.backgroundColor=[UIColor blackColor];
    _hud.removeFromSuperViewOnHide=YES;
}
-(void)stop
{
    [_hud hideAnimated:YES];
}
//只显示字体
-(void)showTextProgress:(NSString *)text
{
    if(_hud)
    {
        [_hud removeFromSuperview];
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _hud=[MBProgressHUD showHUDAddedTo:app.window animated:YES];
    _hud.mode=MBProgressHUDModeText;
    _hud.bezelView.color=[UIColor blackColor];
    _hud.label.text=text;
    _hud.label.textColor=[UIColor whiteColor];
    _hud.label.font=[UIFont systemFontOfSize:13*[self scale]];
    _hud.removeFromSuperViewOnHide=YES;
}
-(void)textstop
{
    [_hud hideAnimated:YES];
}
//上面显示图片,下面显示文字.
-(void)showTextImage:(NSString *)text sendImage:(UIImage *)image
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _hud=[MBProgressHUD showHUDAddedTo:app.window animated:YES];
    _hud.mode=MBProgressHUDModeCustomView;
    _hud.customView=[[UIImageView alloc]initWithImage:image];
    _hud.bezelView.color=[UIColor blackColor];
    _hud.label.text=text;
    _hud.label.textColor=[UIColor whiteColor];
    _hud.label.font=[UIFont systemFontOfSize:13*[self scale]];
}
-(void)textImagestop
{
    [_hud hideAnimated:YES];
}
-(CGFloat)scale
{
    CGFloat scale = 1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    return scale;
}
@end
