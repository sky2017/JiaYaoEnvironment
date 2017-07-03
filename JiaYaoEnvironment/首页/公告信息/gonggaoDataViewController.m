//
//  gonggaoDataViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "gonggaoDataViewController.h"
#import "gonggaoTableViewCell.h"
#import "gonggaoDetailViewController.h"
@interface gonggaoDataViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,assign)NSInteger reminderPage;
@end

@implementation gonggaoDataViewController

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
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy gengduoguanggaopageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
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

    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy gengduoguanggaopageindex:page Block:^(id models, NSString *code, NSString *msg) {
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
    self.NavTitle.text=@"公告信息";
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
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[gonggaoTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    imageDefault.image=[UIImage imageNamed:@"z3"];
    [viewDefault addSubview:imageDefault];
    UILabel *labelText=[[UILabel alloc]initWithFrame:CGRectMake(0, imageDefault.bottom+20/2.34*self.scale, viewDefault.width, 40/2.34*self.scale)];
    labelText.textAlignment=NSTextAlignmentCenter;
    labelText.font=DefaultFont(self.scale);
    labelText.textColor=black153Color;
    labelText.text=@"暂无公告信息";
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
    return 120/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    gonggaoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.labelLeft.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"name"]];
//    cell.labelLeft.textAlignment = NSTextAlignmentCenter;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",[_MarryData [indexPath.row] objectForKey:@"add_time"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    gonggaoDetailViewController *gonggao=[gonggaoDetailViewController new];
    gonggao.noticeId=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:gonggao animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---EVENT----
-(void)leftJump
{
    [self.navigationController popViewControllerAnimated:YES];
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
