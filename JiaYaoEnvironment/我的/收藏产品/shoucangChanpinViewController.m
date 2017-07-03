//
//  shoucangChanpinViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "shoucangChanpinViewController.h"
#import "chanpinzhanshiTableViewCell.h"
#import "chanpinDetailViewController.h"
#import "LoginViewController.h"
@interface shoucangChanpinViewController ()<UITableViewDelegate,UITableViewDataSource,ShopingCarCellDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *MarryData;
@property (nonatomic,assign)NSInteger reminderPage;
@property (nonatomic,strong)NSMutableArray *deleteArray;
@property (nonatomic,strong)UIButton *selectAllBtn;
@property (nonatomic,strong)UIView *baseView;
@property (nonatomic,strong)UIButton *deleteBtn;
@end

@implementation shoucangChanpinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reminderPage=1;
     _MarryData=[[NSMutableArray alloc]init];
    _deleteArray = [[NSMutableArray alloc]init];
      [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
    _reminderPage=1;
     UIView *imagedefault=(UIView *)[self.view viewWithTag:9999];
    
    //选择按钮
    
    UIImageView *imgview = [(UIImageView *)self.view viewWithTag:888];
    
//    UIButton *selectedBtn = (UIButton *)[self.view viewWithTag:888];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy wodeshoucang:ID getmark:@"product" getpageindex:@"1" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
//        NSLog(@"=========%@",code);
//        NSLog(@"---------%@",models);

        if([code isEqualToString:@"1"])
        {
            imgview.hidden=NO;
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
            imgview.hidden=YES;
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
    [analy wodeshoucang:ID getmark:@"product" getpageindex:page Block:^(id models, NSString *code, NSString *msg) {
        
        NSLog(@"1");
        [self stopProgress];
        
        if([code isEqualToString:@"1"])
        {
            NSLog(@"%@",_MarryData);
            [_tableView.footer endRefreshing];
            NSMutableArray *dict=[models mutableCopy];
            NSLog(@"%@",dict);
            
//            NSLog(@"%@",array);
//            NSArray *arry=[dict objectForKey:@"arry"];
            [_MarryData addObjectsFromArray:dict];
            if(dict.count<FenYe)
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
    self.NavTitle.text=@"收藏产品";
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    //清空
    /*
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    selectedBtn.frame = CGRectMake(self.view.width-78/2.34*self.scale, self.NavTitle.top+(self.NavTitle.height-39/2.34*self.scale)/2, self.NavTitle.height, self.NavTitle.height);
//    selectedBtn.hidden = YES;
    selectedBtn.tag=888;
//    [selectedBtn setImage:[UIImage imageNamed:@"laji_tong"] forState:UIControlStateNormal];
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
//    
//    self.navigationItem.rightBarButtonItem =selectItem;
    [self.NavImg addSubview:selectedBtn];
    
    //        全选按钮
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.selectAllBtn.frame =CGRectMake(0, self.NavTitle.top, self.NavTitle.height, self.NavTitle.height);
    [self.selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    
    [self.selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_selectAllBtn];
//    
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.selectAllBtn.hidden = YES;
    [self.NavImg addSubview:self.selectAllBtn];
    */
    
    UIImageView *imagesearch=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-78/2.34*self.scale, self.NavTitle.top+(self.NavTitle.height-39/2.34*self.scale)/2, 39/2.34*self.scale, 39/2.34*self.scale)];
    imagesearch.hidden=YES;
    imagesearch.tag=888;
    imagesearch.image=[UIImage imageNamed:@"laji_tong"];
    imagesearch.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapchaxun=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qingchu)];
    [imagesearch addGestureRecognizer:tapchaxun];
    [self.NavImg addSubview:imagesearch];

    [self setUI];
}
/*

//选择按钮点击响应事件
- (void)selectedBtn:(UIButton *)button {
    
    self.deleteBtn.enabled = YES;
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
//        self.selectAllBtn.hidden = NO;
        self.baseView.hidden = NO;
        self.deleteBtn.hidden = NO;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
//        self.deleteBtn.hidden = YES;
        self.baseView.hidden = YES;
        self.selectAllBtn.hidden = YES;
        [button setTitle:@"选择" forState:UIControlStateNormal];
    }
    
}

//全选
- (void)selectAllBtnClick:(UIButton *)button {
    
    //    [self.tableView reloadData];
    
    for (int i = 0; i < self.MarryData.count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [self.deleteArray addObjectsFromArray:self.MarryData];
        
    }
    
    NSLog(@"self.deleteArr:%@", self.deleteArray);
    
}

- (void)deleteClick:(UIButton *) button {
    
    if (self.tableView.editing) {
        
        //删除
        
        [self.MarryData removeObjectsInArray:self.deleteArray];
        
        [self.tableView reloadData];
        
    }
    
    else return;
    
}
*/

-(void)setUI
{
    // UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64,self.view.width, self.view.height-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.editing = NO;
    _tableView.tag=10010;
    _tableView.backgroundColor=Fbottomcolor;
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    imageDefault.image=[UIImage imageNamed:@"z1"];
    [viewDefault addSubview:imageDefault];
    UILabel *labelText=[[UILabel alloc]initWithFrame:CGRectMake(0, imageDefault.bottom+20/2.34*self.scale, viewDefault.width, 40/2.34*self.scale)];
    labelText.textAlignment=NSTextAlignmentCenter;
    labelText.font=DefaultFont(self.scale);
    labelText.textColor=black153Color;
    labelText.text=@"您还没有收藏的产品";
    
    /*
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 60, self.view.frame.size.width, 60)];
    
    self.baseView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.baseView];
    
    
    //删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    [self.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.enabled = NO;
//    self.deleteBtn.hidden = YES;
    self.baseView.hidden = YES;
    [self.baseView addSubview:self.deleteBtn];
    */
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
    [cell.buttonshoucang setImage:[UIImage imageNamed:@"icon_lvxin"] forState:UIControlStateNormal];
    [cell.buttonshoucang setImage:[UIImage imageNamed:@"icon_lvkongxin"] forState:UIControlStateSelected];
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

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.deleteArray addObject:[self.MarryData objectAtIndex:indexPath.row]];
    
}
//取消选中时 将存放在self.deleteArr中的数据移除

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.deleteArray removeObject:[self.MarryData objectAtIndex:indexPath.row]];
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//        chanpinDetailViewController *detail=[chanpinDetailViewController new];
//    detail.chanpinid=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
//        [self.navigationController pushViewController:detail animated:YES];
//  }


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选择你要对表进行处理的方式  默认是删除方式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
    [self startProgress];
    NSString *outerId=[NSString stringWithFormat:@"%@",[_MarryData[indexPath.row] objectForKey:@"id"]];
    analyticClass *analy=[analyticClass new];
    [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
         [self stopProgress];
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
-(void)seeItem:(NSIndexPath*)path
{
    NSLog(@"%lu",path.row);
}
-(void)shoucangItem:(NSIndexPath*)path
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
    [self startProgress];
    NSString *outerId=[NSString stringWithFormat:@"%@",[_MarryData[path.row] objectForKey:@"id"]];
    
    analyticClass *analy=[analyticClass new];
    [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        
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

//- (void)start:(NSString *)msg{
//    
//    [self showMessage:msg getself:self];
//}

#pragma mark---EVENT--
-(void)qingchu
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
    UIAlertController *control=[UIAlertController alertControllerWithTitle:@"警告" message:@"确定清除产品收藏记录?" preferredStyle:UIAlertControllerStyleAlert];
    [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        [self startProgress];
        analyticClass *analy=[analyticClass new];
        [analy qingkongshoucang:ID getmark:@"product" Block:^(id models, NSString *code, NSString *msg) {
            if([code isEqualToString:@"1"])
            {
                [self getData];
            }
            else
            {
                [self showMessage:msg getself:self];
            }
        }];
    }]];
    [self.navigationController presentViewController:control animated:YES completion:nil];

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
