//
//  AppDelegate.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "shouyeViewController.h"
#import "zhixiaohuanjingViewController.h"
#import "jiancepingguViewController.h"
#import "myViewController.h"
#import "DefaultPageSource.h"
#import "analyticClass.h"
#import "LoginViewController.h"
//shareSDK分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic,strong) UINavigationController *homeNav;
@property (nonatomic,strong) UINavigationController *erShouNav;
@property (nonatomic,strong) UINavigationController *orderNav;
@property (nonatomic,strong) UINavigationController *tuiJianNav;
@property (nonatomic,strong) UINavigationController *gouwucheNav;
//@property (nonatomic,strong) 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.jiaYaoController=[self newTabBarController];
    self.window.rootViewController=self.jiaYaoController;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor=[UIColor whiteColor];
    [self getShareSDK];
    [self judgeAPPVersion];
    return YES;
}

-(void)judgeAPPVersion
{
    //    https://itunes.apple.com/lookup?id=1219140574
    //https://itunes.apple.com/us/app/%E4%BD%B3%E5%9E%9A%E7%8E%AF%E5%A2%83/id1219140574?mt=8
    
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1219140574";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    NSLog(@"商店的版本是 %@",version);
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前的版本是 %@",currentVersion);
    analyticClass *analy = [analyticClass new];
    [analy jichupeizhiBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"1"]) {
            NSMutableDictionary *dic = [models mutableCopy];

            NSString *prompt = [dic objectForKey:@"opendialog"];
//iosversion
            NSString *iosversion = [dic objectForKey:@"iosversion"];
            
            
            
            if (![iosversion isEqualToString:currentVersion]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"有新版本更新，请及时去App Store更新" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
                
                if ([prompt isEqual:@1]) {
                    [alert show];
                   
                }
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil,nil];
            [alert show];
        }
    }];
    
    
    
}

-(UITabBarController *)newTabBarController
{
    //首页
    UITabBarItem *shouyeItem=[[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"icon_r7_c2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_r3_c2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:shouyeItem];
    [self selectedTapTabBarItems:shouyeItem];
    
    _homeNav=[[UINavigationController alloc]initWithRootViewController:[[shouyeViewController alloc]init]];
    _homeNav.tabBarItem = shouyeItem;
    
    //科目
    UITabBarItem *foundItem=[[UITabBarItem alloc]initWithTitle:@"知晓环境" image:[[UIImage imageNamed:@"icon_r7_c4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_r3_c4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:foundItem];
    [self selectedTapTabBarItems:foundItem];
    
    _erShouNav=[[UINavigationController alloc]initWithRootViewController:[[zhixiaohuanjingViewController alloc]init]];
    _erShouNav.tabBarItem = foundItem;
    /*
    //购物车
    UITabBarItem *gouwucheItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[[UIImage imageNamed:@"icon_r7_c4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_r3_c4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:gouwucheItem];
    [self selectedTapTabBarItems:gouwucheItem];
    _gouwucheNav = [[UINavigationController alloc]initWithRootViewController:[[GouwucheViewController alloc]init]];
    _gouwucheNav.tabBarItem = gouwucheItem;
    */
    //发现
    UITabBarItem *orderItem=[[UITabBarItem alloc]initWithTitle:@"检测评估" image:[[UIImage imageNamed:@"icon_r6_c6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_r2_c6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:orderItem];
    [self selectedTapTabBarItems:orderItem];
    
    _orderNav=[[UINavigationController alloc]initWithRootViewController:[[jiancepingguViewController alloc]init]];
    _orderNav.tabBarItem = orderItem;
    
    //我的
    UITabBarItem *TuiJianItem=[[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"icon_r6_c8"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_r2_c8"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:TuiJianItem];
    [self selectedTapTabBarItems:TuiJianItem];
    
    _tuiJianNav=[[UINavigationController alloc]initWithRootViewController:[[myViewController alloc]init]];
    _tuiJianNav.tabBarItem = TuiJianItem;
    
    
    
    UITabBarController *tabBar=[[UITabBarController alloc]init];
    tabBar.viewControllers=@[_homeNav,_erShouNav,_orderNav,_tuiJianNav];
    tabBar.view.backgroundColor = [UIColor whiteColor];
    tabBar.selectedIndex = 0;
    //tabBar.delegate=self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        tabBar.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return tabBar;
    
}
#pragma mark----UITabBarController的代理---
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if (_homeNav==viewController||_erShouNav==viewController||_orderNav==viewController) {
//        return YES;
//    }
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    NSString *userID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
//    //在这里直接判断是否登陆了
//    if([userID isEmptyString])
//    {
//        //跳到首页
//        LoginViewController *login=[LoginViewController new];
//        UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:login];
//        [_jiaYaoController presentViewController:navigation animated:YES completion:nil];
//        return NO;
//    }
//    return YES;
//}

#pragma mark----系统的设置TabBar字体颜色---
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12],
                                        NSFontAttributeName,black153Color,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}
#pragma mark----系统的设置TabBar被选中字体颜色---
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12],
                                        NSFontAttributeName,Fmaincolor,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

-(void)getShareSDK
{
    
    NSMutableArray *Marry=[[NSMutableArray alloc]initWithObjects:@(SSDKPlatformTypeSinaWeibo), nil];
    if([QQApiInterface isQQInstalled])
    {
        [Marry addObject:@(SSDKPlatformTypeQQ)];
    }
    if([WXApi isWXAppSupportApi])
    {
        [Marry addObject:@(SSDKPlatformSubTypeWechatSession)];
        [Marry addObject:@(SSDKPlatformSubTypeWechatTimeline)];
    }
    NSLog(@"%d",[WXApi isWXAppInstalled]);
    [ShareSDK registerApp:@"a95bb852a402" activePlatforms:Marry onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
                //  http://jy.diandiankongqi.com/oauth2/sina
                //http://sns.whalecloud.com/sina2/callback
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"718609467"
                                          appSecret:@"c6be57000590c5852139cc7e46954ee7"
                                        redirectUri:@"http://jy.diandiankongqi.com/oauth2/sina"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxe83172a8ed47eb75"
                                      appSecret:@"6708bd595bb353a46b41aa1dce12061f"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105960997"
                                     appKey:@"d61KCaOnrs3eiejc"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
