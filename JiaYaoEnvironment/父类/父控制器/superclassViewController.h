//
//  superclassViewController.h
//  ZhengNengLiang
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "analyticClass.h"

#import "Stockpile.h"

//#import "UIButton+WebCache.h"
//#import "UIImageView+WebCache.h"
#import "UIImage+AFNetworking.h"

#import "UIViewAdditions.h"
#import <CoreText/CoreText.h>

#import "MJRefresh.h"
#import "NSString+Helper.h"
#import "CExpandHeader.h"
#import "DefaultPageSource.h"
#import "NSString+GetNewStringDemo.h"
#import "NSString+Encrypt.h"
#import "CacheManager.h"

#import "ClockObject.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
//加载数据
#import "ProgressHudobject.h"
#import "UIButton+Helper.h"
#import "UITextField+RYNumberKeyboard.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define YUMING  @"https://jy.diandiankongqi.com/"

#define tableBarHeight  96/2

#define grayTextColor [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1]
#define pinkTextColor [UIColor colorWithRed:211/255.0 green:94/255.0 blue:0/255.0 alpha:1]


@interface superclassViewController : UIViewController<UIAlertViewDelegate>
typedef void(^AlertBlock)(NSInteger index);
@property(nonatomic,strong)AlertBlock alertBlock;

//自适应  适配4 5 6
@property (nonatomic,assign)float scale;
@property (nonatomic,strong)UIImageView *NavImg;
@property (nonatomic,strong)UILabel *NavTitle;
@property (nonatomic,strong)UIImageView * bgImg;
@property (nonatomic,strong)UIActivityIndicatorView *ActivityIndicatorV;
@property (nonatomic,strong)ProgressHudobject *progress;
@property (nonatomic,assign)CGFloat scaleBy;
//- (NSString *)MCode;

- (UIImage *)setImgNameBianShen:(NSString *)Img;

- (NSString *)HuoQuShouJiYunYingShang;

- (NSString *)HuoQuZiFuChuanZhongDeShuZi:(NSString *)str;

- (NSDictionary *)Style;


- (NSString *)panDuanNull:(NSString *)str;

- (void)boDaDianHua:(NSString *)tel;

-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone;

-(void)ShowAlertWithMessage:(NSString *)message;

-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
//来显示线的
-(UIView *)getView:(CGRect)rect;
//显示提示框
-(void)showMessage:(NSString *)showData getself:(id)controlself;
//图片优化
-(UIImage *)scaleImage:(UIImage *)image;

@property (nonatomic, strong)UIView *showMessageView;
-(void)startProgress;
-(void)stopProgress;
-(void)startTextProgress:(NSString *)textData sendImage:(UIImage *)image;
-(void)stopTextProgress;
@end
