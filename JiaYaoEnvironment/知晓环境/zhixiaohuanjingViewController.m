//
//  zhixiaohuanjingViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "zhixiaohuanjingViewController.h"
#import "zhixiaoHuanjingTableViewCell.h"
#import "zhixiaoDetailViewController.h"
@interface zhixiaohuanjingViewController ()<UITableViewDelegate,UITableViewDataSource,ZhixiaoCarCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,assign)NSInteger reminderPage;
@end

@implementation zhixiaohuanjingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _reminderPage=1;
    _MarryData=[[NSMutableArray alloc]init];
    [self getData];
    [self setNavigation];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}
-(void)getData
{
     _reminderPage=1;
       NSLog(@"%lu",_reminderPage);
     UIView *imagedefault=(UIView *)[self.view viewWithTag:9999];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy huanjingpinggu:@"1" getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
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
            imagedefault.hidden=NO;
            [_MarryData removeAllObjects];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
            _tableView.footer.hidden=YES;
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
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy huanjingpinggu:@"1" getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [_tableView.footer endRefreshing];
            NSArray *arry=[models mutableCopy];
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
    self.NavTitle.text=@"知晓环境";
    [self setUI];
}
-(void)setUI
{
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
     _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[zhixiaoHuanjingTableViewCell class] forCellReuseIdentifier:@"cell"];
    //下拉获取最新数据
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //上拉获取旧数据
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getDatamore)];
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
    return _MarryData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zhixiaoHuanjingTableViewCell *zhixian=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    zhixian.indexPath=indexPath;
    [zhixian.imageLeft setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"img_url"]]] placeholderImage:[UIImage imageNamed:@"notpad3"]];
    zhixian.seeNum=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"click"]];
    zhixian.labelTitle.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"name"]];
    zhixian.labelTimer.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"add_time"]];
    [zhixian.buttonsee setTitle:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"click"]] forState:UIControlStateNormal];
    zhixian.delegate=self;
    [zhixian.buttonsee TiaoZhengButtonWithOffsit:3 TextImageSite:UIButtonTextRight];
    return zhixian;
}
-(void)seeItem:(NSIndexPath*)path
{
    NSLog(@"%lu",path.row);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    zhixiaoDetailViewController *detail=[zhixiaoDetailViewController new];
    detail.ID=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row]objectForKey:@"id"]];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
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
