//
//  chanpinzhanshiViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "chanpinzhanshiViewController.h"
#import "chanpinzhanshiTableViewCell.h"
#import "pinpaixuanzeDataTableViewCell.h"
#import "chanpinsousuoViewController.h"
#import "chanpinDetailViewController.h"
#import "LoginViewController.h"
#import "WJDropdownMenu.h"
@interface chanpinzhanshiViewController ()<UITableViewDataSource,UITableViewDelegate,ShopingCarCellDelegate,WJMenuDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *tableViewchaxun;
@property (nonatomic,strong)NSMutableArray *Marrypinpai;
@property (nonatomic,strong)NSArray *Marrytshunxu;
@property (nonatomic,strong)NSMutableArray *MarryFenlei;
@property (nonatomic,strong)NSMutableArray *MarryFenleierji;
@property (nonatomic,strong)NSMutableArray *MarryFenleisanji;
@property (nonatomic,assign)NSInteger reminderpinpaiTag;
@property (nonatomic,assign)NSInteger remindershunxuTag;
@property (nonatomic,assign)NSInteger reminderfenleiTag;
@property (nonatomic,assign)NSInteger reminderbuttonTag;
@property (nonatomic,copy)NSString *reminderpinpaiID;
@property (nonatomic,copy)NSString *reminderfenleiID;
@property (nonatomic,copy)NSString *remindershunxu;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,assign)NSInteger reminderPage;
@property (nonatomic,strong)WJDropdownMenu *menu;
@property (nonatomic,strong)NSArray *topliebiao;
@property (nonatomic,strong)NSArray *secondMenu;

@property (nonatomic,strong)UICollectionView *brandCollectionView;


@end

@implementation chanpinzhanshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reminderPage=1;
    _reminderpinpaiTag = 0;
    _remindershunxuTag = 0;
    _reminderfenleiTag = 0;
    _reminderpinpaiID=@"";
    _reminderfenleiID = @"";
    _remindershunxu=@"";
    _reminderbuttonTag=200;
    _MarryData=[[NSMutableArray alloc]init];
    _MarryFenleierji = [[NSMutableArray alloc]init];
    _MarryFenleisanji = [[NSMutableArray alloc]init];
    _MarryFenlei = [[NSMutableArray alloc]init];
    _Marrypinpai=[[NSMutableArray alloc]init];
    _Marrytshunxu=[[NSMutableArray alloc]initWithObjects:@"综合排序",@"价格由高到低",@"价格由低到高", nil];
    [self setNavigation];
    [self getData];
    [self getfenlei];
    [self getpinpai];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self getData];
}

-(void)getData
{
    _reminderPage=1;
      UIView *imagedefault=(UIView *)[self.view viewWithTag:9999];
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy shangpinliebiao:_reminderfenleiID getkeywords:@"" getprice:_remindershunxu getsale:@"" getbrandId:_reminderpinpaiID getuserId:ID getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
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
            [self showMessage:msg getself:self];        }
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
    [analy shangpinliebiao:_reminderfenleiID getkeywords:@"" getprice:_remindershunxu getsale:@"" getbrandId:_reminderpinpaiID getuserId:ID getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [_tableView.footer endRefreshing];

            NSArray *arry = [models mutableCopy];
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
-(void)getpinpai
{
    analyticClass *analy=[analyticClass new];
    [analy chanpinpinpaiBlock:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
            NSArray *arry=[models mutableCopy];
            [_Marrypinpai addObjectsFromArray:arry];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"不限",@"name",@"0",@"id", nil];
            
            [_Marrypinpai insertObject:dict atIndex:0];
            
            [_tableViewchaxun reloadData];
            [self getliebiaoData];
            
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
- (void)getfenlei{
    analyticClass *analy = [analyticClass new];
    [analy chanpinfenleiBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"1"]) {
            NSArray *yijiarry = [models mutableCopy];
            
            NSDictionary *dict0 = [yijiarry objectAtIndex:0];
            
            NSArray *erjiarry = [dict0 valueForKey:@"nextCategory"];
            
            NSArray *sanjiarry = [[dict0 valueForKey:@"nextCategory"]valueForKey:@"nextCategory"];
            NSLog(@"%@",models);
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"",@"",@"", nil];
            
            [_MarryFenlei addObjectsFromArray:yijiarry];
            [_MarryFenleierji addObjectsFromArray:erjiarry];
            [_MarryFenleisanji addObjectsFromArray:sanjiarry];
            NSLog(@"字典%@",dict0);
            NSLog(@"一级列表内容%@",yijiarry);
            NSLog(@"二级列表内容%@",erjiarry);
            NSLog(@"三级列表的内容%@",sanjiarry);
            

            [_tableViewchaxun reloadData];
            
            
            [self getliebiaoData];
           
        }
        else{
            [self showMessage:msg getself:self];
        }
    }];
    
}

-(void)getliebiaoData{
    
    NSArray *threeArrOne = [NSArray arrayWithObjects:@"综合排序",@"价格由高到低",@"价格由低到高", nil];
    _Marrytshunxu = [NSArray arrayWithObject:threeArrOne];
    

    NSArray *secondMenu = [[NSArray arrayWithObject:_Marrypinpai] valueForKey:@"name"];

    NSArray *firstarray = [[NSArray arrayWithObject:_MarryFenleierji ]valueForKey:@"name"][0];
    
    NSArray *secondarray = [[NSArray arrayWithObject:_MarryFenleisanji]valueForKey:@"name"][0];
    
    NSArray *firstmmm = [NSArray arrayWithObjects:firstarray,secondarray, nil];
    NSLog(@"--------------------------%@",firstmmm);
    if (_Marrypinpai.count>0&& _MarryFenlei.count>0) {
        [_menu createThreeMenuTitleArray:_topliebiao FirstArr:firstmmm SecondArr:secondMenu threeArr:_Marrytshunxu];
    }
    
}



-(void)setNavigation
{
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0, self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    self.NavTitle.text=@"产品展示";
    //搜索
    UIImageView *imagesearch=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-78/2.34*self.scale, self.NavTitle.top+(self.NavTitle.height-39/2.34*self.scale)/2, 39/2.34*self.scale, 39/2.34*self.scale)];
    imagesearch.image=[UIImage imageNamed:@"icon_sarch"];
    imagesearch.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapchaxun=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapchaxun)];
    [imagesearch addGestureRecognizer:tapchaxun];
    [self.NavImg addSubview:imagesearch];
    [self setUI];
}
-(void)setUI
{

    _menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 90/2.34*self.scale)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _topliebiao = @[@"商品分类",@"品牌选择",@"综合排序"];

    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_menu.bottom, self.view.width, self.view.height-_menu.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tag=10010;
     _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[chanpinzhanshiTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    imageDefault.image=[UIImage imageNamed:@"z2"];
    [viewDefault addSubview:imageDefault];
    UILabel *labelText=[[UILabel alloc]initWithFrame:CGRectMake(0, imageDefault.bottom+20/2.34*self.scale, viewDefault.width, 40/2.34*self.scale)];
    labelText.textAlignment=NSTextAlignmentCenter;
    labelText.font=DefaultFont(self.scale);
    labelText.textColor=black153Color;
    labelText.text=@"暂无产品信息";
    [viewDefault addSubview:labelText];
    
    _tableViewchaxun=[[UITableView alloc]initWithFrame:CGRectMake(0,_menu.bottom, self.view.width, self.view.height-_menu.bottom) style:UITableViewStyleGrouped];
    _tableViewchaxun.delegate=self;
    _tableViewchaxun.dataSource=self;
    _tableViewchaxun.hidden=YES;
    _tableViewchaxun.backgroundColor=Fbottomcolor;
    _tableViewchaxun.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableViewchaxun registerClass:[pinpaixuanzeDataTableViewCell class] forCellReuseIdentifier:@"chaxuncell"];
    //下拉获取最新数据
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getData)];
    //上拉获取旧数据
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getDatamore)];
    [self.view addSubview:_tableViewchaxun];
    
    
    
    _menu.delegate = self;         //  设置代理
    
    [self.view addSubview:_menu];
    
    // 设置属性(可不设置)
    _menu.caverAnimationTime = 0.2;//  增加了遮盖层动画时间设置   不设置默认是  0.15
    _menu.menuTitleFont = 12;      //  设置menuTitle字体大小    不设置默认是  11
    _menu.tableTitleFont = 11;     //  设置tableTitle字体大小   不设置默认是  10
    _menu.cellHeight = 50;         //  设置tableViewcell高度   不设置默认是   30
    _menu.menuArrowStyle = menuArrowStyleHollow;
    _menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    
}
-(void)dianjicell:(UITapGestureRecognizer *)Tap
{
    _tableViewchaxun.hidden=YES;
}
#pragma mark-----UITableView代理----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView.tag==10010)
    {
        return 0.01;
    }
    else
    {
        if(_reminderbuttonTag==200)
        {
            return self.view.height-64-90/2.34*self.scale-_MarryFenlei.count*90/2.34*self.scale;
        }
        if (_reminderbuttonTag==201) {
            return self.view.height-64-90/2.34*self.scale-_Marrypinpai.count*90/2.34*self.scale;
        }
        else
        {
            return self.view.height-64-90/2.34*self.scale-_Marrytshunxu.count*90/2.34*self.scale;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView.tag==10010)
    {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    else
    {
        
        if(_reminderbuttonTag==200)
        {
            UIView *viewFotter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-90/2.34*self.scale-_MarryFenlei.count*90/2.34*self.scale)];
            UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianjicell:)];
            [viewFotter addGestureRecognizer:Tap];
            return viewFotter;
        }
        if (_reminderbuttonTag ==201) {
            UIView *viewFotter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-90/2.34*self.scale-_Marrypinpai.count*90/2.34*self.scale)];
            UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianjicell:)];
            [viewFotter addGestureRecognizer:Tap];
            return viewFotter;
        }
        else
        {
            UIView *viewFotter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-90/2.34*self.scale-_Marrytshunxu.count*90/2.34*self.scale)];
            UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dianjicell:)];
            [viewFotter addGestureRecognizer:Tap];
            return viewFotter;
        }

    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==10010)
    {
    return _MarryData.count;
    }
    else
    {
        if(_reminderbuttonTag==200)
        {
#pragma mark --------------------
                 return _MarryFenlei.count;
        }if (_reminderbuttonTag==201) {
            return _Marrypinpai.count;
        }
        else
        {
            return _Marrytshunxu.count;
        }
 
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==10010)
    {
    return 255/2.34*self.scale;
    }
    else
    {
    return 90/2.34*self.scale;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==10010)
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

        cell.buttonshoucang.selected = [[_MarryData[indexPath.row] objectForKey:@"isCollect"]intValue];
        
        
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

    
    else
    {
        pinpaixuanzeDataTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"chaxuncell"];
        if (_reminderbuttonTag==200) {
            NSLog(@"------------%@",_MarryFenlei);
            cell.labelLeft.text=[NSString stringWithFormat:@"%@",[_MarryFenlei[indexPath.row] objectForKey:@"name"]];
            if(indexPath.row==_reminderfenleiTag)
            {
                cell.imageRight.hidden=NO;;
                cell.labelLeft.textColor=textColorred;
            }
            else
            {
                cell.labelLeft.textColor=black102color;
                cell.imageRight.hidden=YES;
            }
        }
        if(_reminderbuttonTag==201)
            {
                cell.labelLeft.text=[NSString stringWithFormat:@"%@",[_Marrypinpai[indexPath.row] objectForKey:@"name"]];
                if(indexPath.row==_reminderpinpaiTag)
                {
                    cell.imageRight.hidden=NO;;
                    cell.labelLeft.textColor=textColorred;
                }
                else
                {
                    cell.labelLeft.textColor=black102color;
                    cell.imageRight.hidden=YES;
                }
            }
        if (_reminderbuttonTag==202) {
            cell.labelLeft.text=[NSString stringWithFormat:@"%@",_Marrytshunxu[indexPath.row]];
            if(indexPath.row==_remindershunxuTag)
            {
                cell.imageRight.hidden=NO;;
                cell.labelLeft.textColor=textColorred;
            }
            else
            {
                cell.labelLeft.textColor=black102color;
                cell.imageRight.hidden=YES;
            }

        }
                   return cell;
    }
    
}

#pragma mark-----------选择cell处理分类---------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==10010)
    {
        chanpinDetailViewController *detail=[chanpinDetailViewController new];
        detail.chanpinid=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
        [self.navigationController pushViewController:detail animated:YES];
    }
    /*
    else
    {
         UIButton *buttonLeft=(UIButton *)[self.view viewWithTag:_reminderbuttonTag];
        if (_reminderbuttonTag==200) {
            _reminderpinpaiTag=indexPath.row;
            _reminderfenleiID=[self.MarryFenlei[indexPath.row] objectForKey:@"id"];
            [buttonLeft setTitle:[NSString stringWithFormat:@"%@",[self.MarryFenlei[indexPath.row] objectForKey:@"name"]] forState:UIControlStateNormal];
        }
    if(_reminderbuttonTag==201)
    {
        _reminderpinpaiTag=indexPath.row;
        _reminderpinpaiID=[self.Marrypinpai[indexPath.row] objectForKey:@"id"];
        [buttonLeft setTitle:[NSString stringWithFormat:@"%@",[self.Marrypinpai[indexPath.row] objectForKey:@"name"]] forState:UIControlStateNormal];
    }
        
    if(_reminderbuttonTag==202)
    {
   _remindershunxuTag=indexPath.row;
        NSString *stringData=[NSString stringWithFormat:@"%@",_Marrytshunxu[indexPath.row]];
        if([stringData isEqualToString:@"综合顺序"])
        {
        _remindershunxu=@"complex";
        }
        if([stringData isEqualToString:@"价格由高到低"])
        {
            _remindershunxu=@"desc";
        }
        if([stringData isEqualToString:@"价格由低到高"])
        {
            _remindershunxu=@"asc";
        }
           [buttonLeft setTitle:[NSString stringWithFormat:@"%@",stringData] forState:UIControlStateNormal];
    }
        [buttonLeft setImage:[UIImage imageNamed:@"icon_hui"] forState:UIControlStateNormal];
        [buttonLeft setImage:[UIImage imageNamed:@"chengse_xia"] forState:UIControlStateSelected];
        [buttonLeft TiaoZhengButtonWithOffsit:5 TextImageSite:UIButtonTextLeft];

         _tableViewchaxun.hidden=YES;
        [self getData];
    }
     */
}
-(void)seeItem:(NSIndexPath*)path
{
    NSLog(@"%lu",path.row);
}
-(void)shoucangItem:(NSIndexPath*)path
{
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
        //在这里直接判断是否登陆了
        if([ID isEmptyString])
        {
            //跳到首页
            LoginViewController *login=[LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
    [self startProgress];
    NSString *outerId=[NSString stringWithFormat:@"%@",[_MarryData[path.row] objectForKey:@"id"]];
    analyticClass *analy=[analyticClass new];
    
    [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
        if([code isEqualToString:@"1"])
        {
            [self getData];

        }
        else
        {
            
        }
    }];
}


#pragma mark---EVENT----
-(void)tapchaxun
{
    chanpinsousuoViewController *chaxun=[chanpinsousuoViewController new];[self.navigationController pushViewController:chaxun animated:YES];
}
#pragma mark -------点击查询详情-----
-(void)pinpai:(UIButton *)button
{
    
    if(button.tag==_reminderbuttonTag)
    {
        _tableViewchaxun.hidden=NO;
       // button.selected=!button.selected;
        button.selected=YES;
        _reminderbuttonTag=button.tag;
        [_tableViewchaxun reloadData];
        return;
    }
    
    _tableViewchaxun.hidden=NO;
    UIButton *buttonbefore=(UIButton *)[self.view viewWithTag:_reminderbuttonTag];
    buttonbefore.selected=NO;
    button.selected=YES;
    _reminderbuttonTag=button.tag;
    [_tableViewchaxun reloadData];
}
-(void)leftJump
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 代理方法返回点击时对应的index
- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex andSecondIndex:(NSInteger)secondIndex{
    //NSLog(@"菜单数:%ld          一级菜单数:%ld      二级子菜单数:%ld(long)",MenuTitleIndex,firstIndex,secondIndex);
    
    if (MenuTitleIndex == 0) {
        if (secondIndex == 0) {
            
            NSArray *array =self.MarryFenleierji[firstIndex];
            NSLog(@"%@",array);
            _reminderfenleiID = [self.MarryFenleierji[firstIndex]objectForKey:@"id"];
        }else{
            NSArray *array = [self.MarryFenleierji[firstIndex]objectForKey:@"nextCategory"][secondIndex];
            NSLog(@"数据%@",array);
        _reminderfenleiID = [[self.MarryFenleierji[firstIndex]objectForKey:@"nextCategory"][secondIndex]objectForKey:@"id"];
        }
    }
    [self getData];
    if (MenuTitleIndex == 1) {
        _reminderpinpaiID=[self.Marrypinpai[firstIndex] objectForKey:@"id"];
    }
    [self getData];
    if (MenuTitleIndex == 2) {
        
        if (firstIndex == 0) {
            _remindershunxu=@"complex";
        }
        if (firstIndex == 1 ) {
            _remindershunxu=@"desc";
        }
        if (firstIndex == 2) {
            _remindershunxu=@"asc";
        }
        
    }
    [self getData];
    
}

#pragma mark -- 代理方法返回点击时对应的内容
- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent andSecondContent:(NSString *)secondContent{
    //NSLog(@"菜单title:%@       一级菜单:%@         二级子菜单:%@",MenuTitle,firstContent,secondContent);
    
    if ([firstContent isEqualToString:[_topliebiao objectAtIndex:0]]) {
        
    }
    [self getData];
    if ([firstContent isEqualToString:[_topliebiao objectAtIndex:1]]) {
        
    }
    [self getData];
    if ([firstContent isEqualToString:[_topliebiao objectAtIndex:2]])
    {
        
     }
    [self getData];

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
