//
//  gengduoshezhiViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "gengduoshezhiViewController.h"
#import "personalTableViewCell.h"
#import "updateLoginmimaViewController.h"
#import "yonghuxieyiViewController.h"
#import "changjianWentiViewController.h"
#import "yijianfankuiViewController.h"
#import "LoginViewController.h"
#import "zhuceyonghuxieyiDataViewController.h"
@interface gengduoshezhiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arryLeft;
@end

@implementation gengduoshezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arryTop=[[NSArray alloc]initWithObjects:@"登录密码", nil];
    NSArray *arryBottom=[[NSArray alloc]initWithObjects:@"用户协议",@"清除缓存", nil];
    _arryLeft=[[NSMutableArray alloc]initWithObjects:arryTop,arryBottom, nil];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"更多设置";
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64-300/2.34*self.scale) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[personalTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    [self setFotterView];
}
-(void)setFotterView
{
    UIView *viewFotter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 110/2.34*self.scale)];
    viewFotter.backgroundColor=Fbottomcolor;
    UIButton *buttontuijian=[[UIButton alloc]initWithFrame:CGRectMake(0, 20/2.34*self.scale, self.view.width, 90/2.34*self.scale)];
    buttontuijian.backgroundColor=[UIColor whiteColor];
    [buttontuijian setTitle:@"退出登录" forState:UIControlStateNormal];
    [buttontuijian setTitleColor:Fmaincolor forState:UIControlStateNormal];
    buttontuijian.adjustsImageWhenHighlighted=NO;
    buttontuijian .titleLabel.font=Big14Font(self.scale);
    [buttontuijian addTarget:self action:@selector(tuichuLogin) forControlEvents:UIControlEventTouchUpInside];
    [viewFotter addSubview:buttontuijian];
      [buttontuijian addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [buttontuijian addSubview:[self getView:CGRectMake(0,90/2.34*self.scale-.5, self.view.width, .5)]];
    [_tableView setTableFooterView:viewFotter];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    if([ID isEmptyString])
    {
        buttontuijian.hidden=YES;
    }

}
#pragma mark-----UITableView代理----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20/2.34*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20/2.34*self.scale)];
    viewHeader.backgroundColor=Fbottomcolor;
    if(section==1)
    {
        [viewHeader addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    }
    [viewHeader addSubview:[self getView:CGRectMake(0, viewHeader.height-.5, self.view.width, .5)]];
    return viewHeader;
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
   return [_arryLeft[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    personalTableViewCell *tableViewcell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    tableViewcell.labelRight.text=self.arryLeft[indexPath.section][indexPath.row];
    if(indexPath.section==1)
    {
        tableViewcell.labelRightData.hidden=YES;
        if(indexPath.row==1)
        {
         tableViewcell.labelRightData.hidden=NO;
            CacheManager *manager=[CacheManager defaultCacheManager];
            double f=[manager GetCacheSize];
            tableViewcell.labelRightData.text=[NSString stringWithFormat:@"%.2fM",f];
        }
        if(indexPath.row==3)
        {
            tableViewcell.viewxian.hidden=YES;
            [tableViewcell addSubview:[self getView:CGRectMake(0, 90/2.34*self.scale-.5, self.view.width, .5)]];
        }
    }
    if(indexPath.section==0)
    {
    tableViewcell.labelRightData.text=@"修改";
        tableViewcell.viewxian.hidden=YES;
        [tableViewcell addSubview:[self getView:CGRectMake(0, 90/2.34*self.scale-.5, self.view.width, .5)]];
    }
    return tableViewcell;
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
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        updateLoginmimaViewController *update=[updateLoginmimaViewController new];
        [self.navigationController pushViewController:update animated:YES];
    }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            zhuceyonghuxieyiDataViewController *update=[zhuceyonghuxieyiDataViewController new];
            [self.navigationController pushViewController:update animated:YES];
        }
        if(indexPath.row==1)
        {
            UIAlertController *control=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清除所有缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
                
            }]];
            [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CacheManager *manager=[CacheManager defaultCacheManager];
                [manager clearCache:^(BOOL success) {
                    [_tableView reloadData];
                }];
            }]];
            [self presentViewController:control animated:YES completion:nil];
        }
        if(indexPath.row==2)
        {
            changjianWentiViewController *wenti=[changjianWentiViewController new];
             [self.navigationController pushViewController:wenti animated:YES];
        }
        if(indexPath.row==3)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
            if([ID isEmptyString])
            {
                //跳到首页
                LoginViewController *login=[LoginViewController new];
                [self.navigationController pushViewController:login animated:YES];
                return;
            }
            yijianfankuiViewController *fankui=[yijianfankuiViewController new];
            [self.navigationController pushViewController:fankui animated:YES];
        }
    }
}
#pragma mark---EVENT---
-(void)tuichuLogin
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
