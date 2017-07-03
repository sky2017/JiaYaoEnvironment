//
//  updateLoginmimaViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "updateLoginmimaViewController.h"
#import "LoginViewController.h"
@interface updateLoginmimaViewController ()

@end

@implementation updateLoginmimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"修改登录密码";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-110/2.34*self.scale, buttonL.top,80/2.34*self.scale, self.NavTitle.height)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=DefaultFont(self.scale);
    [button addTarget:self action:@selector(saves) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:button];
    [self setUI];
}
-(void)setUI
{
    self.view.backgroundColor=Fbottomcolor;
    NSArray *arryLeft=[[NSArray alloc]initWithObjects:@"请输入旧密码", @"设置新密码",@"确定新密码",nil];
    for (int i=0; i<arryLeft.count; i++) {
        UIView *viewbg=[[UIView alloc]initWithFrame:CGRectMake(0,64+20/2.34*self.scale+90/2.34*self.scale*i,self.view.width, 90/2.34*self.scale)];
        viewbg.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:viewbg];
        
        UITextField *textfiled=[[UITextField alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 0,  self.view.width-60/2.34*self.scale, viewbg.height)];
        [textfiled setMaxLength:20];
        textfiled.textColor=blackTextColor;
        textfiled.placeholder=arryLeft[i];
        textfiled.font=DefaultFont(self.scale);
        textfiled.tag=100+i;
        textfiled.secureTextEntry=YES;
        [viewbg addSubview:textfiled];
        if(i==0||i==1)
        {
            if(i==0)
            {
                [viewbg addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
            }
            [viewbg addSubview:[self getView:CGRectMake(30/2.34*self.scale, viewbg.height-.5, self.view.width-30/2.34*self.scale, .5)]];
        }
        if(i==2)
        {
            [viewbg addSubview:[self getView:CGRectMake(0, viewbg.height-.5, self.view.width ,.5)]];
        }
    }

}
#pragma mark---EVENT---
-(void)saves
{
    UITextField *textoldmima=(UITextField *)[self.view viewWithTag:100];
    UITextField *textNewmima=(UITextField *)[self.view viewWithTag:101];
    UITextField *textquedingmima=(UITextField *)[self.view viewWithTag:102];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    NSString *Passwd=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"passwd"]];
    if(![Passwd isEqualToString:textoldmima.text])
    {
        [self showMessage:@"旧密码输入有误" getself:self];
        return;
    }
    if(![textNewmima.text isEqualToString:textquedingmima.text])
    {
        [self showMessage:@"新密码前后不一致" getself:self];
        return;
    }
    if(![textNewmima.text isValidatePassword])
    {
        [self showMessage:@"密码格式有误" getself:self];
        return;
    }
    if(![textquedingmima.text isValidatePassword])
    {
        [self showMessage:@"密码格式有误" getself:self];
        return;
    }
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy xiugaimima:ID getoldpwd:textoldmima.text getpwd:textNewmima.text getqrwd:textquedingmima.text Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"id"];
            [defaults setObject:@"" forKey:@"UserName"];
            [defaults setObject:@"" forKey:@"passwd"];
            [defaults setObject:@"" forKey:@"Address"];
            [defaults setObject:@"" forKey:@"user_avatar.png"];
            [defaults setObject:@"" forKey:@"RealName"];
            [defaults setObject:@"" forKey:@"RegTime"];
            [defaults setObject:@"" forKey:@"Sex"];
            [defaults synchronize];
            AppDelegate *delete=(AppDelegate*)[UIApplication sharedApplication].delegate;
            delete.jiaYaoController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            //弹出登陆界面
            LoginViewController *login=[[LoginViewController alloc]init];
            UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:login];
            [delete.jiaYaoController presentViewController:navigation animated:YES completion:nil];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
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
