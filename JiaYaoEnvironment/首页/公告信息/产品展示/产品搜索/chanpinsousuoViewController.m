//
//  chanpinsousuoViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "chanpinsousuoViewController.h"
#import "chanpinzhanshiTableViewCell.h"
#import "chanpinDetailViewController.h"
@interface chanpinsousuoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ShopingCarCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,copy)NSString *keyword;
@property (nonatomic,assign)NSInteger reminderPage;
@end

@implementation chanpinsousuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyword=@"";
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
    [analy shangpinliebiao:@"" getkeywords:_keyword getprice:@"" getsale:@"" getbrandId:@"" getuserId:ID getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
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
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
     NSString *page=[NSString stringWithFormat:@"%lu",_reminderPage];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy shangpinliebiao:@"" getkeywords:_keyword getprice:@"" getsale:@"" getbrandId:@"" getuserId:ID getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
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
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(30/2.25*self.scale, self.NavTitle.top+20/2.34*self.scale, 580/2.34*self.scale, 60/2.34*self.scale)];
    viewTop.layer.cornerRadius=3;
    viewTop.layer.masksToBounds=YES;
    viewTop.backgroundColor=[UIColor whiteColor];
    [self.NavImg addSubview:viewTop];
    //图片
    UIImageView *imagesearch=[[UIImageView alloc]initWithFrame:CGRectMake(20/2.34*self.scale, 14/2.34*self.scale, 32/2.34*self.scale, 32/2.34*self.scale)];
    imagesearch.image=[UIImage imageNamed:@"sousuo_xiao"];
    [viewTop addSubview:imagesearch];
    UITextField *textFiled=[[UITextField alloc]initWithFrame:CGRectMake(imagesearch.right+20/2.34*self.scale, 0, self.view.width-imagesearch.right-20/2.34*self.scale, viewTop.height)];
    textFiled.textColor=blackTextColor;
    textFiled.font=DefaultFont(self.scale);
    textFiled.placeholder=@"请输入搜索名称";
    textFiled.delegate=self;
    textFiled.returnKeyType=UIReturnKeySearch;
    [viewTop addSubview:textFiled];
    //取消
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(viewTop.right, viewTop.top, self.view.width-viewTop.right-20/2.34*self.scale, viewTop.height)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=Big14Font(self.scale);
    [button addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:button];

    [self setUI];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    _keyword=textField.text;
      UILabel *label=(UILabel *)[self.view viewWithTag:666];
    if([textField.text isEqualToString:@""])
    {
      label.text=@"已获得全部信息";
    }
    else
    {
    label.text=[NSString stringWithFormat:@"%@%@%@",@"找到\"",textField.text,@"\"相关信息"];
    }
    [self getData];
    return YES;
}
-(void)setUI
{
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0,64, self.view.width, 110/2.34*self.scale)];
    viewTop.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewTop];
    UILabel *labelData=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 90/2.34*self.scale)];
    labelData.textColor=black102color;
    labelData.text=@"已获得全部数据";
    labelData.tag=666;
    labelData.textAlignment=NSTextAlignmentCenter;
    labelData.font=DefaultFont(self.scale);
    [viewTop addSubview:labelData];
    UIView *viewhuise=[[UIView alloc]initWithFrame:CGRectMake(0,labelData.bottom, self.view.width, 20/2.34*self.scale)];
    viewhuise.backgroundColor=Fbottomcolor;
    [viewTop addSubview:viewhuise];
    [viewhuise addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [self.view bringSubviewToFront:self.NavImg];
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,viewTop.bottom, self.view.width, self.view.height-viewTop.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tag=10010;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[chanpinzhanshiTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    labelText.text=@"暂无产品";
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
        return 255/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chanpinzhanshiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.imageLeft setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"img_url"]]] placeholderImage:[UIImage imageNamed:@"notpad2"]];
    cell.labelTop.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"name"]];
    cell.delegate=self;
    cell.indexPath=indexPath;
    cell.labelMoney.text=[NSString stringWithFormat:@"%@%@",@"￥",[_MarryData[indexPath.row] objectForKey:@"productPrice"]];
    cell.seeNum=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"click"]];
    cell.shocangNum=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"collectCount"]];
    [cell.buttonsee setTitle:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"click"]] forState:UIControlStateNormal];
    [cell.buttonsee TiaoZhengButtonWithOffsit:3 TextImageSite:UIButtonTextRight];
    [cell.buttonshoucang setTitle:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"collectCount"]] forState:UIControlStateNormal];
//    cell.buttonshoucang setTitle:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] forState:UIControlStateSelected];
    [cell.buttonshoucang setTitle:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"collectCount"]] forState:UIControlStateSelected];
    [cell.buttonshoucang TiaoZhengButtonWithOffsit:3 TextImageSite:UIButtonTextRight];
    if(indexPath.row==self.MarryData.count-1)
    {
        cell.viewxian.hidden=YES;
        [cell addSubview:[self getView:CGRectMake(0, 255/2.34*self.scale-.5, self.view.width, .5)]];
    }
    else
    {
        cell.viewxian.hidden=NO;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chanpinDetailViewController *detail=[chanpinDetailViewController new];
    detail.chanpinid=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)seeItem:(NSIndexPath*)path
{
    NSLog(@"%lu",path.row);
}
-(void)shoucangItem:(NSIndexPath*)path
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    NSString *outerId=[NSString stringWithFormat:@"%@",[_MarryData[path.row] objectForKey:@"id"]];
    analyticClass *analy=[analyticClass new];
    [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
            [self showMessage:msg getself:self];
            
            [self getData];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];

}
#pragma mark---EVENT---
-(void)cancle
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
