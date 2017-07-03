//
//  zhixiaoDetailViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "zhixiaoDetailViewController.h"
#import "LoginViewController.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface zhixiaoDetailViewController ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSDictionary *dictData;
@end

@implementation zhixiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dictData=[[NSDictionary alloc]init];
    [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy huanjingpingguxiangqing:self.ID Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
          _dictData=[models mutableCopy];
            
        [self webViewLoadHTML:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"name"]] Title:[NSString stringWithFormat:@"%@%@%@",[_dictData objectForKey:@"add_time"],@" ",[_dictData objectForKey:@"source"]] Content:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"content"]]];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    self.NavTitle.text=@"详情";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    
    UIButton *buttonT=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-10-37, (40-37)/2+25, 37, 37)];
    [buttonT setImage:[UIImage imageNamed:@"icon_baiseyou"] forState:UIControlStateNormal];
    buttonT.tag=155;
    [self.NavImg addSubview:buttonT];
    [buttonT addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:[self getView:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)]];
    [self setUI];

}
-(void)setUI
{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webView];
}
-(void)webViewLoadHTML:(NSString *)Title Title:(NSString *)Timer Content:(NSString *)content
{
    NSString *BookStr = [NSString stringWithFormat:@"%@",content];
    [_webView loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
}

#pragma mark---EVENT---
-(void)share
{
    //分享界面
    [self getshareSdk];
}
-(void)getshareSdk
{
    //1、创建分享参数
   
   // NSString *shareImage=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"shareImg"]];
    //1、创建分享参数
    NSString *shareURL=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"shareUrl"]];
     NSArray* imageArray = @[[UIImage imageNamed:@"logotouxiang"]];
    NSString *titleName=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"name"]];
    NSString *shareText=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"shareDes"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:shareText
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:titleName
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)leftJump
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
