//
//  superclassViewController.m
//  ZhengNengLiang
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//



#import "superclassViewController.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "AppDelegate.h"
@interface superclassViewController ()<UIGestureRecognizerDelegate>

@end

@implementation superclassViewController


- (void)viewDidLoad{

    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    //获取高度的比例
    _scale = 1;
    if ([[UIScreen mainScreen] bounds].size.height!= 480) {
    _scale = [[UIScreen mainScreen] bounds].size.height / 568;
    }

    //继承该类的子类需要满足的条件。
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.bgImg setImage:[UIImage imageNamed:@"bg"]];
    self.bgImg.hidden  = NO;
    [self.view  addSubview:self.bgImg];
    

    self.NavImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.NavImg setBackgroundColor:Fmaincolor];
    self.NavImg.userInteractionEnabled = YES;
    self.NavImg.hidden  = NO;
    [self.view  addSubview:self.NavImg];

    
    self.NavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44 )];
    self.NavTitle.textColor = [UIColor whiteColor];
    self.NavTitle.textAlignment = 1;
    //    self.NavTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:17*_ZSY];
    self.NavTitle.font = [UIFont systemFontOfSize:17*_scale];
    self.NavTitle.backgroundColor = [UIColor clearColor];
    [self.NavImg addSubview:self.NavTitle];
    
    self.fd_prefersNavigationBarHidden=YES;
//    self.ActivityIndicatorV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    [self.ActivityIndicatorV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    self.ActivityIndicatorV.color = [UIColor grayColor];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jianPanGuanBi:)];
    singleRecognizer.delegate = self;
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    //转圈加载数据
    
//    _progress=[[ProgressHudobject alloc]init];
    
}
- (void)jianPanGuanBi:(UITapGestureRecognizer *)ShouShi{
    [self.view endEditing:YES];
}
//区分手势事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    //为了防止父类的手势和UICollectionView中的手势有冲突.(UIView的原因是点击不调用UICollectionViewCell的输出视图为UIView)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {//如果当前是tableView
        //做自己想做的事
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

//拉伸图片效果
- (UIImage *)setImgNameBianShen:(NSString *)Img{

    UIImage * img = [UIImage imageNamed:Img];
    return  [img stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

//-(NSString *)MCode{
//
//    return  [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//}

- (NSString *)HuoQuShouJiYunYingShang{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    
    return currentCountry;
}

- (NSString *)HuoQuZiFuChuanZhongDeShuZi:(NSString *)str{

    NSString *strNum = @"";

    for (int i=0; i<str.length; i++) {
        
        NSString * character=[str substringWithRange:NSMakeRange(i, 1)];
        
        if ([character isEqualToString: @"0"]|
            [character isEqualToString: @"1"]|
            [character isEqualToString: @"2"]|
            [character isEqualToString: @"3"]|
            [character isEqualToString: @"4"]|
            [character isEqualToString: @"5"]|
            [character isEqualToString: @"6"]|
            [character isEqualToString: @"7"]|
            [character isEqualToString: @"8"]|
            [character isEqualToString: @"9"]) {
            
            strNum=[strNum stringByAppendingString:character];
        }
    }

    return strNum;
}
//字体颜色风格
-(NSDictionary *)Style{
    NSDictionary *style=@{
                          @"body":[UIFont systemFontOfSize:12*self.scale],
                          @"Big":[UIFont systemFontOfSize:14*self.scale],
                          @"mainColor":@[[UIColor colorWithRed:57/255.0 green:184/225.0 blue:86/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"matchColor":@[[UIColor colorWithRed:255/255.0 green:90/225.0 blue:36/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"blackColor":@[[UIColor colorWithRed:51/255.0 green:51/225.0 blue:51/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"smallmainColor":@[[UIColor colorWithRed:57/255.0 green:184/225.0 blue:86/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:11*self.scale  ]],
                          @"bigmainColor":@[[UIColor colorWithRed:57/255.0 green:184/225.0 blue:86/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:20*self.scale  ]],
                          @"defaultmatch":@[[UIColor colorWithRed:255/255.0 green:90/225.0 blue:36/255.0 alpha:1],[UIFont systemFontOfSize:13*self.scale]],
                          
                          @"huise":@[[UIColor colorWithRed:153/255.0 green:153/225.0 blue:153/255.0 alpha:1],[UIFont systemFontOfSize:12*self.scale]],
                          @"main":@[[UIColor colorWithRed:34/255.0 green:126/255.0 blue:38/255.0 alpha:1],[UIFont systemFontOfSize:12*self.scale]],
                          @"red13":@[[UIColor redColor],[UIFont systemFontOfSize:12*self.scale]],
                          
                          @"red15":@[[UIColor redColor],[UIFont systemFontOfSize:15*self.scale]],
                          @"white15":@[[UIColor whiteColor],[UIFont systemFontOfSize:15*self.scale]],
                          @"white20":@[[UIColor whiteColor],[UIFont systemFontOfSize:20*self.scale]],
                          @"17H":@[[UIFont systemFontOfSize:17*self.scale]],
                          @"orange30":@[[UIColor colorWithRed:252/255.0 green:103/255.0 blue:30/255.0 alpha:1],[UIFont boldSystemFontOfSize:14*self.scale]],
                          @"lvSe30":@[[UIColor colorWithRed:62/255.0 green:170/255.0 blue:107/255.0 alpha:1],[UIFont boldSystemFontOfSize:14*self.scale]]
                          
                          };
    

    return style;
}

- (NSString *)panDuanNull:(NSString *)str{

    str = [NSString stringWithFormat:@"%@",str];
    if ([str isEqualToString:@"(null)"]) {
        str = @"";
    }
    
    return str;
}

- (void)boDaDianHua:(NSString *)tel{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
}


-(void)ShowAlertWithMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alert show];
}

-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    alert.tintColor=pinkTextColor;
    [alert show];
    _alertBlock=block;
}
#pragma mark--alertView--
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_alertBlock) {
        _alertBlock(buttonIndex);
    }
}
//设置文本风格
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fone, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}
//划线
-(UIView *)getView:(CGRect)rect
{
    UIView *viewT=[[UIView alloc]initWithFrame:rect];
    viewT.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    return viewT;
}
//显示提示框
-(void)showMessage:(NSString *)showData getself:(id)controlself;
{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:@"" message:showData preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [controlself presentViewController:alertC animated:YES completion:nil];

}


//用于图片的优化,比图片的压缩更清晰
-(UIImage *) scaleImage: (UIImage *)image
{
    if (image.size.width>800) {
        _scaleBy = 800/image.size.width;
    }else{
        _scaleBy= 1.0;
    }
    CGSize size = CGSizeMake(image.size.width * _scaleBy, image.size.height * _scaleBy);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, _scaleBy, _scaleBy);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
#pragma mark---加载数据---
-(void)startProgress
{
    [_progress singleProgress];
}
-(void)stopProgress
{
    [_progress stop];
}
-(void)startTextProgress:(NSString *)textData sendImage:(UIImage *)image
{
    [_progress showTextImage:textData sendImage:image];
}
-(void)stopTextProgress
{
    [_progress textImagestop];
}
//设置屏幕最上方的导航条显示白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//-(NSDictionary *)Style{
//    NSDictionary *style=@{
//                          @"body":[UIFont systemFontOfSize:12*self.ZSY],
//                          @"Big":[UIFont systemFontOfSize:14*self.ZSY],
//                          @"red":[UIColor redColor],
//                          @"orange":@[[UIColor colorWithRed:255/255.0 green:132/225.0 blue:0/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.ZSY]],
//                          @"gray13":@[[UIColor grayColor],[UIFont fontWithName:@"HelveticaNeue" size:13*self.ZSY  ]],
//                          @"red13":@[[UIColor redColor],[UIFont systemFontOfSize:13*self.ZSY]],
//                          @"gray10":@[[UIColor grayColor],[UIFont systemFontOfSize:10*self.ZSY]],
//                          @"gray12":@[[UIColor grayColor],[UIFont systemFontOfSize:12*self.ZSY]],
//                          @"red12":@[[UIColor redColor],[UIFont systemFontOfSize:12*self.ZSY]],
//                          @"red15":@[[UIColor redColor],[UIFont systemFontOfSize:15*self.ZSY]]
//                          };
//    return style;
//}

@end
