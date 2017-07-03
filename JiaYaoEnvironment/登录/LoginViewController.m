//
//  LoginViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "zhuceViewController.h"
#import "FindpasswordViewController.h"
#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
     [self setJiazai];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"登录";
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
    self.view.backgroundColor=Fbottomcolor;
    //图标
    UIImageView *imageTubiao=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-282/2.34*self.scale)/2, 64+70/2.34*self.scale, 282/2.34*self.scale, 282/2.34*self.scale)];
    imageTubiao.image=[UIImage imageNamed:@"logo_freen"];
    [self.view addSubview:imageTubiao];
    //手机号密码
    UIView *viewdenglu=[[UIView alloc]initWithFrame:CGRectMake(40/2.34*self.scale, imageTubiao.bottom+30/2.34*self.scale, self.view.width-80/2.34*self.scale, 200/2.34*self.scale)];
    viewdenglu.layer.borderColor=black204Color.CGColor;
    viewdenglu.layer.borderWidth=1;
    viewdenglu.layer.cornerRadius=5;
    viewdenglu.layer.masksToBounds=YES;
    viewdenglu.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewdenglu];
    
    UIImageView *imageshouji=[[UIImageView alloc]initWithFrame:CGRectMake(20/2.34*self.scale,(100-48)/2/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imageshouji.image=[UIImage imageNamed:@"icon_phone"];
    [viewdenglu addSubview:imageshouji];
    
    UITextField *textshouji=[[UITextField alloc]initWithFrame:CGRectMake(imageshouji.right+20/2.34*self.scale,0, self.view.width-imageshouji.right-60/2.34*self.scale, 100/2.34*self.scale)];
    textshouji.font=DefaultFont(self.scale);
    textshouji.textColor=blackTextColor;
    textshouji.placeholder=@"请输入你的手机号";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *mobile=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"mobile"]];
    if(![mobile isEmptyString])
    {
        textshouji.text=mobile;
    }
    textshouji.keyboardType=UIKeyboardTypeNumberPad;
    [textshouji setMaxLength:11];
    textshouji.tag=100;
    [viewdenglu addSubview:textshouji];
    [viewdenglu addSubview:[self getView:CGRectMake(20/2.34*self.scale, textshouji.bottom-1, viewdenglu.width-40/2.34*self.scale, 1)]];

    
    UIImageView *imagemima=[[UIImageView alloc]initWithFrame:CGRectMake(20/2.34*self.scale, textshouji.bottom+(100-48)/2/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imagemima.image=[UIImage imageNamed:@"icon_key"];
    [viewdenglu addSubview:imagemima];
    
    UITextField *textmima=[[UITextField alloc]initWithFrame:CGRectMake(imageshouji.right+20/2.34*self.scale, textshouji.bottom, self.view.width-imageshouji.right-60/2.34*self.scale-48/2.34*self.scale, 100/2.34*self.scale)];
    textmima.font=DefaultFont(self.scale);
    textmima.textColor=blackTextColor;
    [textmima setMaxLength:20];
    textmima.placeholder=@"请输入登录密码";
    textmima.secureTextEntry=YES;
    textmima.tag=101;
    [viewdenglu addSubview:textmima];

    UIButton *buttontuijian=[[UIButton alloc]initWithFrame:CGRectMake(40/2.34*self.scale, viewdenglu.bottom+35/2.34*self.scale, self.view.width-80/2.34*self.scale, 80/2.34*self.scale)];
    buttontuijian.backgroundColor=Fmatchcolor;
    buttontuijian.layer.cornerRadius=5;
    buttontuijian.layer.masksToBounds=YES;
    [buttontuijian setTitle:@"登录" forState:UIControlStateNormal];
    [buttontuijian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttontuijian.adjustsImageWhenHighlighted=NO;
    buttontuijian .titleLabel.font=Big14Font(self.scale);
    [buttontuijian addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttontuijian];

    
    
    UIButton *buttonzhaohui=[[UIButton alloc]initWithFrame:CGRectMake(50/2.34*self.scale, buttontuijian.bottom+20/2.34*self.scale, self.view.width/2-50/2.34*self.scale, 45/2.34*self.scale)];
    [buttonzhaohui setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [buttonzhaohui setTitleColor:black153Color forState:UIControlStateNormal];
    buttonzhaohui .titleLabel.font=SmallFont(self.scale);
    [buttonzhaohui addTarget:self action:@selector(zhaohuimima) forControlEvents:UIControlEventTouchUpInside];
    buttonzhaohui.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:buttonzhaohui];
    
    UIButton *buttonzhuce=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2, buttontuijian.bottom+20/2.34*self.scale, self.view.width/2-50/2.34*self.scale, 45/2.34*self.scale)];
    [buttonzhuce setTitleColor:Fmaincolor forState:UIControlStateNormal];
    buttonzhuce .titleLabel.font=SmallFont(self.scale);
    buttonzhuce.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
       [buttonzhuce setAttributedTitle:[[NSString stringWithFormat:@"<huise>%@</huise><main>%@</main>",@"没有账号?",@"注册"] attributedStringWithStyleBook:[self Style]] forState:UIControlStateNormal];
    [buttonzhuce addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonzhuce];
}
#pragma mark----EVENT---
-(void)zhaohuimima
{
    FindpasswordViewController*find=[FindpasswordViewController new];
     [self.navigationController pushViewController:find animated:YES];
}
-(void)zhuce
{
    zhuceViewController *zhuce=[zhuceViewController new];
    [self.navigationController pushViewController:zhuce animated:YES];
}
-(void)login
{
    UITextField *textiphone=(UITextField *)[self.view viewWithTag:100];
    UITextField *textmima=(UITextField *)[self.view viewWithTag:101];
    if([textiphone.text isEqualToString:@""])
    {
        [self showMessage:@"手机号不能为空" getself:self];
        return;
    }
    if([textmima.text isEqualToString:@""])
    {
        [self showMessage:@"密码不能为空" getself:self];
        return;
    }
    if(![textiphone.text isValidateMobile])
    {
        [self showMessage:@"手机号输入有误" getself:self];
        return;
    }
    if(![textmima.text isValidatePassword])
    {
        [self showMessage:@"密码格式有误" getself:self];
        return;
    }
    [self.ActivityIndicatorV startAnimating];
  analyticClass *analy=[analyticClass new];
    [analy yonghudenglu:textiphone.text getpwd:textmima.text Block:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
             [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [self startTextProgress:@"登录成功" sendImage:[UIImage imageNamed:@"icon_yuan"]];
            DELAYEXECUTE(2, [self stops]);
          NSDictionary *dictData=[models mutableCopy];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"UserID"]] forKey:@"id"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"UserName"]] forKey:@"UserName"];
            [defaults setObject:textmima.text forKey:@"passwd"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"Address"]] forKey:@"Address"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"user_avatar.png"]] forKey:@"user_avatar.png"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"RealName"]] forKey:@"RealName"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"RegTime"]] forKey:@"RegTime"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"Sex"]] forKey:@"Sex"];
  [defaults setObject:[NSString stringWithFormat:@"%@",[dictData objectForKey:@"mobile"]] forKey:@"mobile"];
            [defaults synchronize];
            
        }
        else
        {
            [self startTextProgress:msg sendImage:[UIImage imageNamed:@"icon_ereeo"]];
            DELAYEXECUTE(2, [self stops]);
        }
    }];
}
-(void)stops
{
    [self stopTextProgress];
}
-(void)leftJump
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark----加载旋转---
-(void)setJiazai
{
    [self.view addSubview:self.ActivityIndicatorV];
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
