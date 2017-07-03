//
//  FindpasswordViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FindpasswordViewController.h"
#import "JKCountDownButton.h"
#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))
@interface FindpasswordViewController ()
@property (nonatomic,copy)NSString *reminderCode;
@property (nonatomic,copy)NSString *reminderBefreshouji;
@end

@implementation FindpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"找回密码";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    //取消
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-100/2.34*self.scale, buttonL.top, 80/2.34*self.scale, self.NavTitle.height)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=DefaultFont(self.scale);
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:button];
    [self setUI];
    
}
-(void)setUI
{UIView *viewbaise=[[UIView alloc]initWithFrame:CGRectMake(0, 64+20/2.34*self.scale, self.view.width, 324/2.34*self.scale)];
    viewbaise.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewbaise];
    UIImageView *imageshouji=[[UIImageView alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 64+50/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imageshouji.image=[UIImage imageNamed:@"icon_phone"];
    [self.view addSubview:imageshouji];
    self.view.backgroundColor=Fbottomcolor;
    UITextField *textshouji=[[UITextField alloc]initWithFrame:CGRectMake(imageshouji.right+30/2.34*self.scale, imageshouji.top, self.view.width-imageshouji.right-60/2.34*self.scale, 48/2.34*self.scale)];
    textshouji.font=DefaultFont(self.scale);
    textshouji.textColor=blackTextColor;
    textshouji.keyboardType=UIKeyboardTypeNumberPad;
    [textshouji setMaxLength:11];
    textshouji.placeholder=@"请输入你的手机号";
    textshouji.tag=80;
    [self.view addSubview:textshouji];
    
    [self.view addSubview:[self getView:CGRectMake(0, textshouji.bottom+30/2.34*self.scale-.5, self.view.width, .5)]];
    
    UIImageView *imageyanzhengma=[[UIImageView alloc]initWithFrame:CGRectMake(30/2.34*self.scale, textshouji.bottom+60/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imageyanzhengma.image=[UIImage imageNamed:@"icon_keylight"];
    [self.view addSubview:imageyanzhengma];
    
    UITextField *textyanzhengma=[[UITextField alloc]initWithFrame:CGRectMake(imageshouji.right+30/2.34*self.scale, textshouji.bottom+60/2.34*self.scale, self.view.width-imageshouji.right-60/2.34*self.scale-190/2.34*self.scale, 48/2.34*self.scale)];
    textyanzhengma.font=DefaultFont(self.scale);
    textyanzhengma.textColor=blackTextColor;
    textyanzhengma.placeholder=@"请输入验证码";
    textyanzhengma.tag=81;
    [textyanzhengma setMaxLength:6];
    textyanzhengma.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:textyanzhengma];
    
    [self.view addSubview:[self getView:CGRectMake(0, imageyanzhengma.bottom+30/2.34*self.scale-.5, self.view.width, .5)]];
    
    JKCountDownButton *countDownCode=[JKCountDownButton buttonWithType:UIButtonTypeCustom];
    countDownCode.frame =CGRectMake(self.view.width-220/2.34*self.scale, textyanzhengma.top-4/2.34*self.scale, 190/2.34*self.scale, 56/2.34*self.scale);
    [countDownCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [countDownCode setTitleColor:black153Color  forState:UIControlStateNormal];
    countDownCode.layer.cornerRadius=3;
    countDownCode.layer.masksToBounds=YES;
    countDownCode.layer.borderWidth=1;
    countDownCode.layer.borderColor=black204Color.CGColor;
    countDownCode.titleLabel.font=DefaultFont(self.scale);
    countDownCode.backgroundColor = Fbottomcolor;
    [self.view addSubview:countDownCode];

    
    [countDownCode addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        //手机号
        if([textshouji.text isEqualToString:@""])
        {
            [self showMessage:@"手机号不能为空" getself:self];
            return ;
        }
        if(![textshouji.text isValidateMobile])
        {
            [self showMessage:@"手机号输入有误" getself:self];
            return;
        }
        analyticClass *analy=[analyticClass new];
        [analy huoquyanzhengma:textshouji.text getmark:@"getpassword" Block:^(id models, NSString *code, NSString *msg) {
            if([code isEqualToString:@"1"])
            {
                NSDictionary *dictData=[models mutableCopy];
                _reminderCode=[NSString stringWithFormat:@"%@",[dictData objectForKey:@"code"]];
                
                _reminderBefreshouji=textshouji.text;
                sender.enabled = NO;
                
                [sender startWithSecond:60];
                
                [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    countDownButton.titleLabel.font=[UIFont systemFontOfSize:12*self.scale];
                    NSString *title = [NSString stringWithFormat:@"%ds%@",second,@"后重发"];
                    sender.backgroundColor=Fmatchcolor;
                    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    sender.layer.borderColor=Fmatchcolor.CGColor;
                    return title;
                }];
                [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.titleLabel.font=[UIFont systemFontOfSize:10];
                    countDownButton.enabled = YES;
                    countDownButton.backgroundColor=Fbottomcolor;
                    [countDownButton setTitleColor:black153Color forState:UIControlStateNormal];
                    countDownButton.layer.borderColor=black204Color.CGColor;
                    return @"重新获取验证码";
                }];
                
            }
            else
            {
                [self showMessage:msg getself:self];
            }
        }];
        
    }];
    [self.view addSubview:[self getView:CGRectMake(0, 64+20/2.34*self.scale, self.view.width, .5)]];
    [self.view addSubview:[self getView:CGRectMake(0, viewbaise.bottom-.5, self.view.width, .5)]];
    UIImageView *imagemima=[[UIImageView alloc]initWithFrame:CGRectMake(30/2.34*self.scale, textyanzhengma.bottom+60/2.34*self.scale, 48/2.34*self.scale, 48/2.34*self.scale)];
    imagemima.image=[UIImage imageNamed:@"icon_key"];
    [self.view addSubview:imagemima];
    
    UITextField *textmima=[[UITextField alloc]initWithFrame:CGRectMake(imageshouji.right+30/2.34*self.scale, textyanzhengma.bottom+60/2.34*self.scale, self.view.width-imageshouji.right-60/2.34*self.scale-48/2.34*self.scale, 48/2.34*self.scale)];
    textmima.font=DefaultFont(self.scale);
    textmima.textColor=blackTextColor;
    textmima.placeholder=@"输入新密码(密码长度应为6-20字符)";
    textmima.secureTextEntry=YES;
    [textmima setMaxLength:20];
    textmima.tag=82;
    [self.view addSubview:textmima];
    UIButton *buttonshow=[[UIButton alloc]initWithFrame:CGRectMake(textmima.right, textmima.top, 48/2.34*self.scale, 48/2.34*self.scale)];
    [buttonshow setImage:[UIImage imageNamed:@"icon_eyeselected"] forState:UIControlStateNormal];
    [buttonshow setImage:[UIImage imageNamed:@"icon_eyesf"] forState:UIControlStateSelected];
    [buttonshow addTarget:self action:@selector(showeyes:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonshow];
    
    UIButton *buttontuijian=[[UIButton alloc]initWithFrame:CGRectMake(40/2.34*self.scale, viewbaise.bottom+40/2.34*self.scale, self.view.width-80/2.34*self.scale, 80/2.34*self.scale)];
    buttontuijian.backgroundColor=Fmatchcolor;
    buttontuijian.layer.cornerRadius=5;
    buttontuijian.layer.masksToBounds=YES;
    [buttontuijian setTitle:@"保存" forState:UIControlStateNormal];
    [buttontuijian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttontuijian.adjustsImageWhenHighlighted=NO;
    buttontuijian .titleLabel.font=Big14Font(self.scale);
    [buttontuijian addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttontuijian];

}
#pragma mark---EVENT--
-(void)showeyes:(UIButton *)button
{
    UITextField *textmima=(UITextField *)[self.view viewWithTag:82];
    button.selected=!button.selected;
    if(button.selected)
    {
        textmima.secureTextEntry=NO;
    }
    else
    {
        textmima.secureTextEntry=YES;
    }

}
-(void)save
{
    UITextField *textshouji=(UITextField *)[self.view viewWithTag:80];
    UITextField *textyanzhengma=(UITextField *)[self.view viewWithTag:81];
    UITextField *textmima=(UITextField *)[self.view viewWithTag:82];
    if([textshouji.text isEqualToString:@""])
    {
        [self showMessage:@"手机号不能为空" getself:self];
        return;
    }
    if([textmima.text isEqualToString:@""])
    {
        [self showMessage:@"密码不能为空" getself:self];
        return;
    }
    if([textyanzhengma.text isEqualToString:@""])
    {
        [self showMessage:@"验证码不能为空" getself:self];
        return;
    }
    if(![textshouji.text isValidateMobile])
    {
        [self showMessage:@"手机号格式有误" getself:self];
        return;
    }
    if(![textmima.text isValidatePassword])
    {
        [self showMessage:@"密码格式有误" getself:self];
        return;
    }
    if(![textyanzhengma.text isEqualToString:_reminderCode])
    {
        [self showMessage:@"验证码输入有误" getself:self];
        return;
    }
    if(![textshouji.text isEqualToString:_reminderBefreshouji])
    {
        [self showMessage:@"当前手机号与所发验证码手机号不一致" getself:self];
        return;
    }
   [self.ActivityIndicatorV startAnimating];
      analyticClass *analy=[analyticClass new];
    [analy zhaohuimima:textshouji.text getpwd:textmima.text Block:^(id models, NSString *code, NSString *msg) {
         [self.ActivityIndicatorV stopAnimating];
        if([code isEqualToString:@"1"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self startTextProgress:@"修改成功" sendImage:[UIImage imageNamed:@"zhengque"]];
            DELAYEXECUTE(2, [self stops]);
        }
        else
        {
            [self startTextProgress:msg sendImage:[UIImage imageNamed:@"cuowu"]];
            DELAYEXECUTE(2, [self stops]);
        }

    }];
}
-(void)stops
{
    [self stopTextProgress];
}
-(void)denglu
{
 [self.navigationController popViewControllerAnimated:YES];
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
