//
//  zhuceyonghuxieyiDataViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "zhuceyonghuxieyiDataViewController.h"

@interface zhuceyonghuxieyiDataViewController ()
@property (nonatomic,strong)UIWebView *webview;
@end

@implementation zhuceyonghuxieyiDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
      [self getData];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"注册用户协议";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    [self setUI];
    
}
-(void)setUI
{
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    _webview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webview];

}
-(void)getData
{
    analyticClass *analy=[analyticClass new];
    [analy jichupeizhiBlock:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
            NSDictionary *dict=[models mutableCopy];
            [self webViewLoadHTML:@"" Title:@"" Content:[dict objectForKey:@"regXY"]];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
    
}
-(void)webViewLoadHTML:(NSString *)Title Title:(NSString *)Timer Content:(NSString *)content
{
    NSString *BookStr = [NSString stringWithFormat:@"%@",content];
    [_webview loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
}

#pragma mark---EVENT--
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
