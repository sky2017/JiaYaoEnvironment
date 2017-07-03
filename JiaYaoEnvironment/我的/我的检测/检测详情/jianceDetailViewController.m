//
//  jianceDetailViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "jianceDetailViewController.h"

@interface jianceDetailViewController ()
@property (nonatomic,assign)NSInteger reminderBefore;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIWebView *webview;
@property (nonatomic,strong)NSDictionary *dictData;
@end

@implementation jianceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _reminderBefore=1;
    _dictData=[[NSDictionary alloc]init];
    [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy wodejiandetail:self.detailID Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            _dictData=[models mutableCopy];
            self.NavTitle.text=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"name"]];
            [self setUI];
            
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    
}
-(void)setUI
{
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 110/2.34*self.scale)];
    viewTop.backgroundColor=[UIColor whiteColor];
    [viewTop addSubview:[self getView:CGRectMake(0, viewTop.height-.5, self.view.width, .5)]];
    NSArray *arryList=[[NSArray alloc]initWithObjects:@"检测报告",@"解决方案",nil];
    for (int i=0; i<arryList.count; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake((i%2)*self.view.width/arryList.count, 0, self.view.width/arryList.count, 90/2.34*self.scale)];
        [button setTitleColor:blackTextColor forState:UIControlStateNormal];
        button.tag=i+1;
        button.titleLabel.font=Big15Font(self.scale);
        [button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:Fmaincolor forState:UIControlStateSelected];
        [viewTop addSubview:button];
        if(i==0)
        {
            button.selected=YES;
        }
        [button setTitle:arryList[i] forState:UIControlStateNormal];
    }
    UIButton *button=(UIButton *)[viewTop viewWithTag:_reminderBefore];
    button.selected=YES;
    _reminderBefore=button.tag;
    _label=[[UILabel alloc]init];
    _label.center=CGPointMake(button.center.x,90/2.34*self.scale-.5);
    _label.bounds=CGRectMake(0, 0, button.width, 1);
    _label.backgroundColor=Fmaincolor;
    [viewTop addSubview:_label];
    UIView *viewBottom=[[UIView alloc]initWithFrame:CGRectMake(0, 90/2.34*self.scale, self.view.width, 20/2.34*self.scale)];
    viewBottom.backgroundColor=Fbottomcolor;
    [viewTop addSubview:viewBottom];
    [viewBottom addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [viewBottom addSubview:[self getView:CGRectMake(0, viewBottom.height-.5, self.view.width, .5)]];
    [self.view addSubview:viewTop];
    
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, viewTop.bottom, self.view.width, self.view.height-viewTop.bottom)];
    _webview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webview];
    [self webViewLoadHTML:@"" Title:@"" Content:[_dictData objectForKey:@"reportContent"]];
}
-(void)next:(UIButton *)button
{
    if(_reminderBefore==button.tag)
    {
        return;
    }
    UIButton *buttonBefore=(UIButton *)[self.view viewWithTag:_reminderBefore];
    buttonBefore.selected=NO;
    button.selected=YES;
    _reminderBefore=button.tag;
    [UIView animateWithDuration:0.5 animations:^{
        _label.center=CGPointMake(button.center.x, 90/2.34*self.scale-.5);
        _label.bounds=CGRectMake(0, 0, button.width, 1);
    }];
    if(button.tag==1)
    {
      [self webViewLoadHTML:@"" Title:@"" Content:[_dictData objectForKey:@"reportContent"]];
    }
    else
    {
        [self webViewLoadHTML:@"" Title:@"" Content:[_dictData objectForKey:@"solutionContent"]];
    }
}
-(void)webViewLoadHTML:(NSString *)Title Title:(NSString *)Timer Content:(NSString *)content
{
    NSString *BookStr = [NSString stringWithFormat:@"%@",content];
    [_webview loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
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
