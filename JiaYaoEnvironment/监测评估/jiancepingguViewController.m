//
//  jiancepingguViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "jiancepingguViewController.h"
#import "liebiaoCollectionViewCell.h"
#import "pingguViewController.h"
#import "SDCycleScrollView.h"
#import "zhixiaoDetailViewController.h"
#import "pingguViewController.h"
#import "chanpinDetailViewController.h"
@interface jiancepingguViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSMutableArray *Marrylunbo;
@property (nonatomic,assign)NSInteger reminderPage;
@end

@implementation jiancepingguViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       _reminderPage=1;
       _Marrylunbo=[[NSMutableArray alloc]init];
      _MarryData=[[NSMutableArray alloc]init];
    [self setNavigation];
    [self getData];
     [self getlunbo];
    // Do any additional setup after loading the view.
}
-(void)getlunbo
{
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy lunbotu:@"检测评估" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            NSMutableArray *Marry=[[NSMutableArray alloc]init];
            NSArray *arry=[models mutableCopy];
            [_Marrylunbo addObjectsFromArray:arry];
            for (int i=0; i<_Marrylunbo.count; i++) {
                [Marry addObject:[NSString stringWithFormat:@"%@",[_Marrylunbo[i] objectForKey:@"img_url"]]];
            }
            _cycleScrollView.imageURLStringsGroup = Marry;
        }
        else{
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)getData
{
    _reminderPage=1;
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy huanjingpinggu:@"2" getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
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
                // imagedefault.hidden=NO;
                [_tableView reloadData];
                return ;
            }
            // imagedefault.hidden=YES;
            [_tableView reloadData];
        }
        else
        {
            //imagedefault.hidden=NO;
            _tableView.footer.hidden=YES;
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
    [analy huanjingpinggu:@"2" getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
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
    self.NavTitle.text=@"检测评估";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    if([self.type isEqualToString:@"1"])
    {
        buttonL.hidden=NO;;
    }
    else
    {
        buttonL.hidden=YES;
    }
    [self setUI];
}
-(void)setUI
{
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-49-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    if([self.type isEqualToString:@"1"])
    {
        _tableView.height=self.view.height-64;
    }
    else
    {
        _tableView.height=self.view.height-49-64;
    }
    //下拉获取最新数据
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //上拉获取旧数据
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getDatamore)];
    [self.view addSubview:_tableView];
    [self setTableviewHeader];

}
-(void)setTableviewHeader
{
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    viewHeader.backgroundColor=[UIColor whiteColor];
    //轮播图
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 375/2.34*self.scale) delegate:self placeholderImage:[UIImage imageNamed:@"notpad1"]];
    _cycleScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.delegate=self;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.currentPageDotColor=[UIColor yellowColor];
    _cycleScrollView.pageDotColor=[UIColor whiteColor];
    [viewHeader addSubview:_cycleScrollView];
    viewHeader.height=_cycleScrollView.bottom;
    [_tableView setTableHeaderView:viewHeader];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *isopen=[NSString stringWithFormat:@"%@",[_Marrylunbo[index]objectForKey:@"isopen"]];
    if([isopen isEqualToString:@"0"])
    {
        //外部链接
        NSString *link_url=[NSString stringWithFormat:@"%@",[_Marrylunbo[index]objectForKey:@"link_url"]];
        NSURL *url=[[NSURL alloc]initWithString:link_url];
        [[UIApplication sharedApplication] openURL:url];
    }
    if([isopen isEqualToString:@"1"])
    {
        //知晓环境
        zhixiaoDetailViewController *detail=[zhixiaoDetailViewController new];
        detail.ID=[NSString stringWithFormat:@"%@",[_Marrylunbo[index] objectForKey:@"link_url"]];
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    if([isopen isEqualToString:@"2"])
    {
        //检测评估
        pingguViewController *pinggu=[pingguViewController new];
        pinggu.ID=[NSString stringWithFormat:@"%@",[_Marrylunbo[index] objectForKey:@"link_url"]];
        pinggu.Title=[NSString stringWithFormat:@"%@",[_Marrylunbo[index] objectForKey:@"name"]];
        pinggu.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pinggu animated:YES];
    }
    if([isopen isEqualToString:@"3"])
    {
        //产品详情
        chanpinDetailViewController *detail=[chanpinDetailViewController new];
        detail.chanpinid=[NSString stringWithFormat:@"%@",[_Marrylunbo[index] objectForKey:@"link_url"]];
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }

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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.MarryData.count%2>0)
    {
        return (self.MarryData.count/2+1)*310/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+2);
    }
    else
    {
        return self.MarryData.count/2*340/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+1);
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setSectionInset:UIEdgeInsetsMake(25/2.34*self.scale,20/2.34*self.scale, 25/2.34*self.scale, 20/2.34*self.scale)];//设置每个区的上左下右的距离周边(其他区边,屏幕边等.)的距离
    [layout setItemSize:CGSizeMake((self.view.width-60/2.34*self.scale)/2, 230/2.34*self.scale)];//必须设置小cell的长和宽
    CGFloat HeightColl=0.00;
    if(self.MarryData.count%2>0)
    {
        HeightColl=(self.MarryData.count/2+1)*230/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+2);
    }
    else
    {
        HeightColl=self.MarryData.count/2*230/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+1);
    }
    
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,HeightColl) collectionViewLayout:layout];
    [cell addSubview:_collectionView];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.scrollEnabled=NO;
    [_collectionView registerClass:[liebiaoCollectionViewCell class] forCellWithReuseIdentifier:@"cellz"];
    [cell addSubview:_collectionView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark---UICollectionView代理---
//下面两个是将cell之间的间隔都设为0.
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25/2.34*self.scale;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.MarryData.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    liebiaoCollectionViewCell *collcell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellz" forIndexPath:indexPath];
    collcell.backgroundColor=[UIColor whiteColor];
    [collcell.imageAll setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"img_url"]]] placeholderImage:[UIImage imageNamed:@"notpad3"]];
    collcell.labelB.text=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"name"]];
    return collcell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    pingguViewController *pinggu=[pingguViewController new];
    pinggu.ID=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
    pinggu.Title=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"name"]];
    pinggu.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pinggu animated:YES];
    NSLog(@"%lu",indexPath.row);
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
