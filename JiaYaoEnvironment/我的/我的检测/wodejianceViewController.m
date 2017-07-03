//
//  wodejianceViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "wodejianceViewController.h"
#import "wodejianceTableViewCell.h"
#import "jianceDetailViewController.h"
#import "jiancepingguViewController.h"
@interface wodejianceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,assign)NSInteger reminderPage;
@end

@implementation wodejianceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _reminderPage=1;
      _MarryData=[[NSMutableArray alloc]init];
    [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    _reminderPage=1;
    UIView *imagedefault=(UIView *)[self.view viewWithTag:9999];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy wodejiance:ID getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [_tableView.header endRefreshing];
            [_MarryData removeAllObjects];
            NSArray *arry=[models mutableCopy];
            [_MarryData addObjectsFromArray:arry];
            if(arry.count<FenYe)
            {
                _tableView.footer.hidden=YES;
            }
            else
            {
                _tableView.footer.hidden=NO;
            }
            if(arry.count==0)
            {
                 imagedefault.hidden=NO;
                [_tableView reloadData];
                return ;
            }
             imagedefault.hidden=YES;
            [_tableView reloadData];
        }
        else
        {
            _tableView.footer.hidden=YES;
            imagedefault.hidden=NO;
            [_MarryData removeAllObjects];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)getDatamore
{
    _reminderPage++;
    if(_MarryData.count==0)
    {
        _reminderPage=1;
    }
    NSString *page=[NSString stringWithFormat:@"%lu",_reminderPage];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy wodejiance:ID getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [_tableView.footer endRefreshing];
            NSDictionary *dict=[models mutableCopy];
            NSArray *arry=[dict objectForKey:@"arry"];
            [_MarryData addObjectsFromArray:arry];
            if(arry.count<FenYe)
            {
                _tableView.footer.hidden=YES;
            }
            [_tableView reloadData];

        }
        else
        {
            _reminderPage--;
            _tableView.footer.hidden=YES;
            [_tableView.footer endRefreshing];
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    self.NavTitle.text=@"我的检测";
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
    [_tableView registerClass:[wodejianceTableViewCell class] forCellReuseIdentifier:@"cell"];
    //下拉获取最新数据
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //上拉获取旧数据
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getDatamore)];
    [self.view addSubview:_tableView];
    //默认图
    UIView *viewDefault=[[UIView alloc]init];
    viewDefault.bounds=CGRectMake(0, 0, 400/2.34*self.scale, 400/2.34*self.scale);
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
    labelText.text=@"暂无检测报告";
    [viewDefault addSubview:labelText];
    UIButton *buttonlijiyuyue=[[UIButton alloc]initWithFrame:CGRectMake(0, labelText.bottom+50/2.34*self.scale, viewDefault.width, 75/2.34*self.scale)];
    buttonlijiyuyue.layer.cornerRadius=75/2.34*self.scale/2;
    buttonlijiyuyue.layer.masksToBounds=YES;
    buttonlijiyuyue.layer.borderWidth=.5;
    buttonlijiyuyue.layer.borderColor=Fmatchcolor.CGColor;
    [buttonlijiyuyue setTitle:@"立即预约" forState:UIControlStateNormal];
    buttonlijiyuyue.titleLabel.font=Big14Font(self.scale);
    [buttonlijiyuyue setTitleColor:Fmatchcolor forState:UIControlStateNormal];
    [buttonlijiyuyue addTarget:self action:@selector(lijiyuyue) forControlEvents:UIControlEventTouchUpInside];
    [viewDefault addSubview:buttonlijiyuyue];
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
    
    wodejianceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.labelRight.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"detecName"]];
    cell.labelRightData.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"add_time"]];
    if(indexPath.row==_MarryData.count-1)
    {
        cell.viewxian.hidden=YES;
        [cell addSubview:[self getView:CGRectMake(0, 90/2.34*self.scale-.5, self.view.width, .5)]];
    }
    else
    {
     cell.viewxian.hidden=NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jianceDetailViewController *jiance=[jianceDetailViewController new];
    jiance.detailID=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:jiance animated:YES];
}

#pragma mark---EVENT----
-(void)lijiyuyue
{
  //评估检测
    jiancepingguViewController *jiance=[jiancepingguViewController new];
    jiance.type=@"1";
    jiance.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:jiance animated:YES];
    
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
