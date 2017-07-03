//
//  myViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "myViewController.h"
#import "wodeTableViewCell.h"
#import "personalDataViewController.h"
#import "wodejianceViewController.h"
#import "shoucangChanpinViewController.h"
#import "guanyuViewController.h"
#import "gengduoshezhiViewController.h"
#import "LoginViewController.h"
#import "gonggaoDataViewController.h"
#import "changjianWentiViewController.h"
#import "yijianfankuiViewController.h"
#import "SharedViewController.h"
@interface myViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *Marry;
@property (nonatomic,strong)NSMutableArray *MarryImage;
@property (nonatomic,strong)NSDictionary *DictData;
@end

@implementation myViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _DictData=[[NSDictionary alloc]init];
    _Marry=[[NSMutableArray alloc]init];
    _MarryImage=[[NSMutableArray alloc]init];
    NSArray *arryTop=[[NSArray alloc]initWithObjects:@"我的检测",@"收藏产品",@"在线客服",@"推荐分享",@"关于佳垚", nil];
    NSArray *arryBottom=[[NSArray alloc]initWithObjects:@"公告信息",@"检测反馈",@"常见问题",@"更多设置", nil];
    [_Marry addObject:arryTop];
    [_Marry addObject:arryBottom];
    NSArray *arryTopImage=[[NSArray alloc]initWithObjects:@"icon_reds",@"icon_blue",@"icon_ting",@"icon_fenxiang",@"icon_green",nil];
    NSArray *arryBottomImage=[[NSArray alloc]initWithObjects:@"icon_lv",@"fk",@"wt",@"icon_light", nil];
    [_MarryImage addObject:arryTopImage];
    [_MarryImage addObject:arryBottomImage];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
      NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    UIButton *buttondenglu=(UIButton *)[self.view viewWithTag:101];
    UILabel *labelTel=(UILabel *)[self.view viewWithTag:102];
     UIImageView *imagetouxiang=(UIImageView *)[self.view viewWithTag:100];
    if([ID isEmptyString])
    {
        //跳到首页
        buttondenglu.hidden=NO;
        labelTel.hidden=YES;
        imagetouxiang.image=[UIImage imageNamed:@"icon_lvxiao"];
    }
    else
    {
        buttondenglu.hidden=YES;
        labelTel.hidden=NO;
        [self getData];
    }
}
-(void)getData
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy yonghuxinxi:ID Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            _DictData=[models mutableCopy];
            UIImageView *imagetouxiang=(UIImageView *)[self.view viewWithTag:100];
            [imagetouxiang setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"HeadImg"]]] placeholderImage:[UIImage imageNamed:@"icon_lvxiao"]];
            //昵称
            UIButton *buttonLogin=(UIButton *)[self.view viewWithTag:101];
            UILabel *labelNickname=(UILabel *)[self.view viewWithTag:102];
            NSString *showLabel=@"";
            NSString *nickName=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"UserName"]];
              NSString *realName=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"RealName"]];
            if([realName isEmptyString])
            {
            if([nickName isEmptyString])
            {
             NSString *tel=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"mobile"]];
                if([tel isEmptyString])
                {
                }
                else
                {
                    showLabel=tel;
                }
            }
            else
            {
                showLabel=nickName;
            }
            }
            else
            {
            showLabel=realName;
            }
            if([showLabel isEqualToString:@""])
            {
               buttonLogin.hidden=NO;
                  labelNickname.hidden=YES;
            }
            else
            {
                   buttonLogin.hidden=YES;
                labelNickname.hidden=NO;
                labelNickname.text=showLabel;
            }
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    self.NavImg.hidden=YES;
    [self setUI];
}
-(void)setUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
     _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[wodeTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [self setHeader];
}
-(void)setHeader
{
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 390/2.34*self.scale)];
    UIImageView *imageViewData=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewTop.width, viewTop.height)];
    imageViewData.image=[UIImage imageNamed:@"bgwode"];
    [viewTop addSubview:imageViewData];
    //头像
    UIImageView *imagetouxiang=[[UIImageView alloc]init];
    imagetouxiang.center=CGPointMake(viewTop.centerX, viewTop.centerY);
    imagetouxiang.bounds=CGRectMake(0, 0, 130/2.34*self.scale, 130/2.34*self.scale);
    imagetouxiang.tag=100;
    imagetouxiang.layer.cornerRadius=imagetouxiang.width/2;
    imagetouxiang.layer.masksToBounds=YES;
    imagetouxiang.image=[UIImage imageNamed:@"icon_lvxiao"];
    UITapGestureRecognizer *Taptouxiang=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(persnalData)];
    imagetouxiang.userInteractionEnabled=YES;
    [imagetouxiang addGestureRecognizer:Taptouxiang];
    [viewTop addSubview:imagetouxiang];
    UIButton *buttondenglu=[[UIButton alloc]init];
    buttondenglu.center=CGPointMake(viewTop.centerX, imagetouxiang.bottom+55/2.34*self.scale);
    buttondenglu.bounds=CGRectMake(0, 0, 180/2.34*self.scale, 50/2.34*self.scale);
    [buttondenglu setTitle:@"请登录" forState:UIControlStateNormal];
    buttondenglu.titleLabel.font=DefaultFont(self.scale);
    [buttondenglu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttondenglu.tag=101;
    buttondenglu.layer.cornerRadius=buttondenglu.height/2;
    buttondenglu.layer.masksToBounds=YES;
    buttondenglu.layer.borderWidth=1;
    buttondenglu.layer.borderColor=[UIColor whiteColor].CGColor;
    [buttondenglu addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttondenglu];

  //显示电话号码
    UILabel *labelTel=[[UILabel alloc]initWithFrame:CGRectMake(0,imagetouxiang.bottom+30/2.34*self.scale, self.view.width, 50/2.34*self.scale)];
    labelTel.textColor=[UIColor whiteColor];
    labelTel.font=DefaultFont(self.scale);
    labelTel.tag=102;
    labelTel.textAlignment=NSTextAlignmentCenter;
    labelTel.hidden=YES;
    [viewTop addSubview:labelTel];
    [_tableView setTableHeaderView:viewTop];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    if([ID isEmptyString])
    {
        //跳到首页
        buttondenglu.hidden=NO;
        labelTel.hidden=YES;
    }
    else
    {
        buttondenglu.hidden=YES;
        labelTel.hidden=NO;
    }
}
#pragma mark-----UITableView代理----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
    return 20/2.34*self.scale;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20/2.34*self.scale)];
        viewHeader.backgroundColor=Fbottomcolor;
        [viewHeader addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
        [viewHeader addSubview:[self getView:CGRectMake(0, viewHeader.height-.5, self.view.width, .5)]];
        return viewHeader;
    }
    UIView *view=[UIView new];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return [_Marry[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    wodeTableViewCell *wode=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    wode.labelRight.text=_Marry[indexPath.section][indexPath.row];
    wode.imageLeft.image=[UIImage imageNamed:_MarryImage[indexPath.section][indexPath.row]];
    if(indexPath.section==0)
    {
    if(indexPath.row==4)
    {
    wode.viewxian.hidden=YES;
    }
    else
        {
    wode.viewxian.hidden=NO;
        }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==4)
        {
            wode.viewxian.hidden=YES;
            [wode addSubview:[self getView:CGRectMake(0, 100/2.34*self.scale-.5, self.view.width, .5)]];
        }
        else
        {
         wode.viewxian.hidden=NO;
        }
    }
    return wode;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==0)
   {
   if(indexPath.row==0)
   {
       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
       NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
       if([ID isEmptyString])
       {
           //跳到首页
           LoginViewController *login=[LoginViewController new];
           login.hidesBottomBarWhenPushed=YES;
           [self.navigationController pushViewController:login animated:YES];
           return;
       }
       wodejianceViewController *jiance=[wodejianceViewController new];
       jiance.hidesBottomBarWhenPushed=YES;
       [self.navigationController pushViewController:jiance animated:YES];
   }
       if(indexPath.row==1)
       {
           NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
           NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
           if([ID isEmptyString])
           {
               //跳到首页
               LoginViewController *login=[LoginViewController new];
               login.hidesBottomBarWhenPushed=YES;
               [self.navigationController pushViewController:login animated:YES];
               return;
           }
           shoucangChanpinViewController*jiance=[shoucangChanpinViewController new];
           jiance.hidesBottomBarWhenPushed=YES;
           [self.navigationController pushViewController:jiance animated:YES];
       }
       if(indexPath.row==2)
       {
           NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
           NSString *tel= [defaults objectForKey:@"tel"];
           NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
       }
       if (indexPath.row==3) {
           SharedViewController *fenxiang = [SharedViewController new];
           fenxiang.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:fenxiang animated:YES];
       }
       if(indexPath.row==4)
       {
           guanyuViewController *guanyu=[guanyuViewController new];
           guanyu.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:guanyu animated:YES];
       }
       
   }
    else
    {
        if(indexPath.row==0)
        {
            gonggaoDataViewController*gonggao=[gonggaoDataViewController new];
            gonggao.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:gonggao animated:YES];
        }
    if(indexPath.row==1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
        if([ID isEmptyString])
        {
            //跳到首页
            LoginViewController *login=[LoginViewController new];
            login.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        yijianfankuiViewController *fankui=[yijianfankuiViewController new];
        fankui.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:fankui animated:YES];
            }
        if(indexPath.row==2)
        {
            
            changjianWentiViewController *wenti=[changjianWentiViewController new];
            wenti.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:wenti animated:YES];
        }
        if(indexPath.row==3)
        {
            gengduoshezhiViewController *gengguo=[gengduoshezhiViewController new];
            gengguo.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:gengguo animated:YES];

        }
    }
}
#pragma mark----EVENT---
-(void)persnalData
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    if([ID isEmptyString])
    {
        //跳到首页
        LoginViewController *login=[LoginViewController new];
        login.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
//个人资料
    personalDataViewController *person=[personalDataViewController new];
    person.imageUrl=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"HeadImg"]];
    person.UserName=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"UserName"]];
    person.sex=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"Sex"]];
    person.mobile=[NSString stringWithFormat:@"%@",[_DictData objectForKey:@"mobile"]];
    person.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)denglu
{
    LoginViewController*login=[LoginViewController new];
    login.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];
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
