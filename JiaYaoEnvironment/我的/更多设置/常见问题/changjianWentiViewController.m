//
//  changjianWentiViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "changjianWentiViewController.h"
#import "changjianwentiDetailTableViewCell.h"
#import "changjianwentiDetailViewController.h"
@interface changjianWentiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@end

@implementation changjianWentiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _MarryData=[[NSMutableArray alloc]init];
    [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
     UIView *imagedefault=(UIView *)[self.view viewWithTag:9999];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy changjianwentiBlock:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [_MarryData removeAllObjects];
            NSArray *arry=[models mutableCopy];
            [_MarryData addObjectsFromArray:arry];
            [_tableView reloadData];
          if(arry.count==0)
          {
           imagedefault.hidden=NO;
          }
            else
            {
            imagedefault.hidden=YES;
            }
        }
        else
        {
            imagedefault.hidden=NO;
            [_MarryData removeAllObjects];
            [_tableView reloadData];
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    self.NavTitle.text=@"常见问题";
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[changjianwentiDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    //默认图
    UIView *viewDefault=[[UIView alloc]init];
    viewDefault.bounds=CGRectMake(0, 0, 300/2.34*self.scale, 300/2.34*self.scale);
    viewDefault.center=CGPointMake(self.view.width/2, self.view.height/2-80/2.34*self.scale);
    viewDefault.tag=9999;
    viewDefault.hidden=YES;
    [self.view addSubview:viewDefault];
    UIImageView *imageDefault=[[UIImageView alloc]init];
    imageDefault.frame=CGRectMake((viewDefault.width-150/2.34*self.scale)/2, 0, 150/2.34*self.scale, 150/2.34*self.scale);
    imageDefault.image=[UIImage imageNamed:@"light_logo"];
    [viewDefault addSubview:imageDefault];
    UILabel *labelText=[[UILabel alloc]initWithFrame:CGRectMake(0, imageDefault.bottom+20/2.34*self.scale, viewDefault.width, 40/2.34*self.scale)];
    labelText.textAlignment=NSTextAlignmentCenter;
    labelText.font=DefaultFont(self.scale);
    labelText.textColor=black153Color;
    labelText.text=@"暂无数据";
    [viewDefault addSubview:labelText];

}
#pragma mark-----UITableView代理----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MarryData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    changjianwentiDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.labelRight.text=[NSString stringWithFormat:@"%@",[self.MarryData[indexPath.row] objectForKey:@"name"]];
    if(indexPath.row==self.MarryData.count-1)
    {
        cell.viewxian.hidden=YES;
        [cell addSubview:[self getView:CGRectMake(0, 90/2.34*self.scale-.5, self.view.width, .5)]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    changjianwentiDetailViewController *detail=[changjianwentiDetailViewController new];
    detail.detailID=[NSString stringWithFormat:@"%@",[self.MarryData[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:detail animated:YES];
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
