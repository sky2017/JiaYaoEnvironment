//
//  shezhiNicknameViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "shezhiNicknameViewController.h"

@interface shezhiNicknameViewController ()

@end

@implementation shezhiNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"设置昵称";
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
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 64+20/2.34*self.scale, self.view.width, 90/2.34*self.scale)];
    viewTop.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    UITextField *textNickname=[[UITextField alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 0, (self.view.width-60/2.34*self.scale)/2, viewTop.height)];
    textNickname.font=DefaultFont(self.scale);
    textNickname.textColor=blackTextColor;
    textNickname.placeholder=@"请输入昵称";
    textNickname.tag=10010;
    textNickname.text=self.nicheng;
    [textNickname setMaxLength:15];
    [viewTop addSubview:textNickname];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-78/2.34*self.scale, (90-48)/2/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imageview.image=[UIImage imageNamed:@"icon_cuo"];
    [viewTop addSubview:imageview];
    imageview.userInteractionEnabled=YES;
    UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delete:)];
    [imageview addGestureRecognizer:Tap];
    [viewTop addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [viewTop addSubview:[self getView:CGRectMake(0, viewTop.height-.5, self.view.width, .5)]];
}
#pragma mark---EVENT---
-(void)delete:(UITapGestureRecognizer *)Tap
{
    UITextField *text=(UITextField *)[self.view viewWithTag:10010];
    text.text=@"";
}
-(void)saves
{
   UITextField *text=(UITextField *)[self.view viewWithTag:10010];
    if([text.text isEqualToString:@""])
    {
        [self showMessage:@"昵称不能为空" getself:self];
        return;
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    analyticClass *analy=[analyticClass new];
    [self startProgress];
    [analy xiugaigerenziliao:ID getnickName:text.text getrealName:@"" getsex:@"" getaddress:@"" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            if(self.block)
            {
                self.block(text.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            UIAlertController *control=[UIAlertController alertControllerWithTitle:@"" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self.navigationController.topViewController presentViewController:control animated:YES completion:nil];

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
