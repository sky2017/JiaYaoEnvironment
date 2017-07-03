//
//  shouyeViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "shouyeViewController.h"
#import "liebiaoCollectionViewCell.h"
#import "gonggaoDataViewController.h"
#import "chanpinzhanshiViewController.h"
#import "LSPaoMaView.h"
#import "gonggaoDetailViewController.h"
#import "guanyuViewController.h"
#import "pingguViewController.h"
#import "jiancepingguViewController.h"
#import "SDCycleScrollView.h"
#import "zhixiaoDetailViewController.h"
#import "pingguViewController.h"
#import "chanpinDetailViewController.h"
@interface shouyeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,strong)NSMutableArray *Marrygonggao;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSMutableArray *Marrylunbo;

@end

@implementation shouyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSObject *duixiang = [[NSObject alloc]init];
    _Marrylunbo=[[NSMutableArray alloc]init];
    _Marrygonggao=[[NSMutableArray alloc]init];
    _MarryData=[[NSMutableArray alloc]init];
    [self setNavigation];
    [self jichupeizhi];
    [self getgonggao];
    [self getData];
    [self getlunbo];
    // Do any additional setup after loading the view.
}
-(void)getlunbo
{
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy lunbotu:@"首页TOP" Block:^(id models, NSString *code, NSString *msg) {
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
-(void)jichupeizhi
{
    analyticClass *analy=[analyticClass new];
    [analy jichupeizhiBlock:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
            NSDictionary *dict=[models mutableCopy];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[dict objectForKey:@"tel"] forKey:@"tel"];
            [defaults setObject:[dict objectForKey:@"companymail"] forKey:@"mail"];
             [defaults setObject:[dict objectForKey:@"companyaddress"] forKey:@"address"];
            [defaults synchronize];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)getData
{
    [self getgonggao];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
   [analy tuijianpingguBlock:^(id models, NSString *code, NSString *msg) {
       [self stopProgress];
       if([code isEqualToString:@"1"])
       {
           [self.MarryData removeAllObjects];
             [_tableView.header endRefreshing];
           NSArray *arry=[models mutableCopy];
           [self.MarryData addObjectsFromArray:arry];
           [_tableView reloadData];
           [_collectionView reloadData];
       }
       else
       {
           [_MarryData removeAllObjects];
           [_tableView reloadData];
             [_tableView.header endRefreshing];
           [self showMessage:msg getself:self];
       }
   }];
}
-(void)getgonggao
{
    analyticClass *analy=[analyticClass new];
    [analy shouyegonggaoBlock:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
               [_tableView.header endRefreshing];
            [_Marrygonggao removeAllObjects];
            NSLog(@"models===%@",models);
           NSArray *arry=[models mutableCopy];
            [_Marrygonggao addObjectsFromArray:arry];
            NSMutableArray *Marry=[[NSMutableArray alloc]init];
            for (int i=0; i<_Marrygonggao.count; i++) {
                [Marry addObject:[_Marrygonggao[i] objectForKey:@"name"]];
            }
            UIView *viewTop=(UIView *)[self.view viewWithTag:666];
            
                SDCycleScrollView *cycleScrollViewtop = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,viewTop.width, viewTop.height) delegate:self placeholderImage:nil];
                cycleScrollViewtop.scrollDirection = UICollectionViewScrollDirectionVertical;
            
                cycleScrollViewtop.onlyDisplayText = YES;
            cycleScrollViewtop.tag=10010;
            cycleScrollViewtop.titleLabelTextColor=blackTextColor;
            cycleScrollViewtop.titleLabelBackgroundColor=[UIColor whiteColor];
            cycleScrollViewtop.autoScrollTimeInterval = 3;
                cycleScrollViewtop.userInteractionEnabled=YES;
               cycleScrollViewtop.titlesGroup = [Marry copy];
                [viewTop addSubview:cycleScrollViewtop];
        }
        else
        {
               [_tableView.header endRefreshing];
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
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    //下拉获取最新数据
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.view addSubview:_tableView];
    [self setTableviewHeader];
}
-(void)setTableviewHeader
{
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    viewHeader.backgroundColor=[UIColor whiteColor];
    
 //轮播图
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 380/2.34*self.scale) delegate:self placeholderImage:[UIImage imageNamed:@"notpad1"]];
    _cycleScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate=self;
    _cycleScrollView.tag=10086;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    
    _cycleScrollView.currentPageDotColor=[UIColor yellowColor];
    _cycleScrollView.pageDotColor=[UIColor whiteColor];
    [viewHeader addSubview:_cycleScrollView];
//喇叭
    UIImageView *imagelaba=[[UIImageView alloc]initWithFrame:CGRectMake(30/2.34*self.scale,_cycleScrollView.bottom+(75-35)/2/2.34*self.scale, 35/2.34*self.scale, 35/2.34*self.scale)];
    imagelaba.image=[UIImage imageNamed:@"chengse_laba"];
    [viewHeader addSubview:imagelaba];
//公告
    UIView *labelgonggao=[[UIView alloc]initWithFrame:CGRectMake(imagelaba.right+20/2.34*self.scale, _cycleScrollView.bottom, self.view.width-imagelaba.right-50/2.34*self.scale-80/2.34*self.scale, 75/2.34*self.scale)];
    labelgonggao.tag=666;
    labelgonggao.backgroundColor=[UIColor whiteColor];
    [viewHeader addSubview:labelgonggao];
    
    UIImageView *imageRight=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-71/2.34*self.scale,  _cycleScrollView.bottom+(75-41)/2/2.34*self.scale,41/2.34*self.scale, 41/2.34*self.scale)];
    
    imageRight.image=[UIImage imageNamed:@"hui_dian"];
    imageRight.userInteractionEnabled=YES;
    UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gonggao:)];
    [imageRight addGestureRecognizer:Tap];
    [viewHeader addSubview:imageRight];
//图片+文字
    UIView *viewshowData=[[UIView alloc]initWithFrame:CGRectMake(0, labelgonggao.bottom+30/2.34*self.scale, self.view.width, 160/2.34*self.scale)];
    [viewHeader addSubview:viewshowData];
    NSArray *arryImage=[[NSArray alloc]initWithObjects:@"blue_tubiao",@"yuan_red",@"lvse_tu",@"icon_ting", nil];
    NSArray *arryTitle=[[NSArray alloc]initWithObjects:@"预约检测",@"产品展示",@"公司简介",@"在线客服", nil];
    CGFloat paddingH=20/2.34*self.scale;
    CGFloat paddingW=(self.view.width-100/2.34*self.scale-520/2.34*self.scale)/3;
   
    CGFloat buttonWidth=130/2.34*self.scale;
    CGFloat buttonHeight=150/2.34*self.scale;
    CGFloat buttonWidthImage=90/2.34*self.scale;
    for (int i=0; i<arryTitle.count; i++) {
        UIView *viewsmall=[[UIView alloc]initWithFrame:CGRectMake(50/2.34*self.scale+(buttonWidth+paddingW)*(i%4),(buttonHeight+paddingH)*(i/4), buttonWidth, buttonHeight)];
        UIImageView *imageViewT=[[UIImageView alloc]initWithFrame:CGRectMake(15/2.34*self.scale, 0, buttonWidthImage, buttonWidthImage)];
        imageViewT.image=[UIImage imageNamed:arryImage[i]];
        [viewsmall addSubview:imageViewT];
        viewsmall.tag=100+i;
        //label
        UILabel *labelT=[[UILabel alloc]initWithFrame:CGRectMake(0, imageViewT.bottom, buttonWidth, viewsmall.height-imageViewT.bottom)];
        labelT.text=arryTitle[i];
        labelT.textColor=black153Color;
        labelT.font=DefaultFont(self.scale);
        labelT.textAlignment=NSTextAlignmentCenter;
        [viewsmall addSubview:labelT];
        [viewshowData addSubview:viewsmall];
        UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseData:)];
        [viewsmall addGestureRecognizer:Tap];
    }
    
    [viewHeader addSubview:[self getView:CGRectMake(30/2.34*self.scale, labelgonggao.bottom, self.view.width-60/2.34*self.scale, .5)]];
    UIView *viewBottomhuise=[[UIView alloc]initWithFrame:CGRectMake(0, viewshowData.bottom, self.view.width, 20/2.34*self.scale)];
    viewBottomhuise.backgroundColor=Fbottomcolor;
    [viewHeader addSubview:viewBottomhuise];
    [viewBottomhuise addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [viewBottomhuise addSubview:[self getView:CGRectMake(0, viewBottomhuise.height-.5, self.view.width, .5)]];
    viewHeader.height=viewBottomhuise.bottom;
    [_tableView setTableHeaderView:viewHeader];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(cycleScrollView.tag==10010)
    {
            gonggaoDetailViewController *gonggao=[gonggaoDetailViewController new];
            gonggao.hidesBottomBarWhenPushed=YES;
            gonggao.noticeId=[NSString stringWithFormat:@"%@",[self.Marrygonggao[index] objectForKey:@"id"]];
            [self.navigationController pushViewController:gonggao animated:YES];
    }
    else
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
    return (self.MarryData.count/2+1)*230/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+2);
    }
    else
    {
    return self.MarryData.count/2*260/2.34*self.scale+25/2.34*self.scale*(self.MarryData.count/2+1);
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
}
#pragma mark----点击事件---
-(void)chooseData:(UITapGestureRecognizer *)Tap
{
    UIView *view=Tap.view;
    if(view.tag==100)
    {
        jiancepingguViewController *jiance=[jiancepingguViewController new];
        jiance.type=@"1";
        jiance.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:jiance animated:YES];
    }
    if(view.tag==101)
    {
        chanpinzhanshiViewController *chanpin=[chanpinzhanshiViewController new];
        chanpin.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:chanpin animated:YES];
    }
    if(view.tag==102)
    {
        guanyuViewController *guanyu=[guanyuViewController new];
        guanyu.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:guanyu animated:YES];
    }
    if(view.tag==103)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
       NSString *tel= [defaults objectForKey:@"tel"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
-(void)gonggao:(UITapGestureRecognizer *)Tap
{
    gonggaoDataViewController *gonggao=[gonggaoDataViewController new];
    gonggao.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:gonggao animated:YES];
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
