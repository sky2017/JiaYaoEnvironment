//
//  changjianwentiDetailViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "changjianwentiDetailViewController.h"

@interface changjianwentiDetailViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation changjianwentiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
      [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
    [self startProgress];
     analyticClass *analy=[analyticClass new];
    [analy changjianwentidetail:self.detailID Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            NSDictionary *dict=[models mutableCopy];
            [self webViewLoadHTML:@"" Title:@"" Content:[NSString stringWithFormat:@"%@",[dict objectForKey:@"contents"]]];
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
    [_webView loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
}
-(void)setNavigation
{
    self.NavTitle.text=@"常见问题-详情";
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
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webView];
}
#pragma mark---EVENT---
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
