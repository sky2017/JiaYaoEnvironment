//
//  WJDropdownMenu.m
//  WJDropDownMenu
//
//  Created by 文杰 on 16/1/23.
//  Copyright © 2016年 wj. All rights reserved.
//



#define cell_h   30

#define window_h [UIScreen mainScreen].bounds.size.height
#define carverAnimationDefalutTime 0.15
#define menuTitleDefalutFont [UIFont systemFontOfSize:11]
#define TableTitleDefalutFont [UIFont systemFontOfSize:10]


#import "WJDropdownMenu.h"
#import <UIKit/UIKit.h>
#import "BrandCollectionViewCell.h"




@interface WJDropdownMenu ()
//背景
@property (nonatomic,strong) UIView         *backView;
//一级tableView
@property (nonatomic,strong) UITableView    *tableFirst;
//二级tableview
@property (nonatomic,strong) UITableView    *tableSecond;
//一级数据数组
@property (nonatomic,strong) NSMutableArray *dataSourceFirst;
//二级数据数组
@property (nonatomic,strong) NSMutableArray *dataSourceSecond;

@property (nonatomic,strong) NSMutableArray *allData;
@property (nonatomic,strong) NSMutableArray *allDataSource;
//显示
@property (nonatomic,assign) BOOL           firstTableViewShow;
@property (nonatomic,assign) BOOL           secondTableViewShow;
@property (nonatomic,assign) BOOL           brandCollectionViewShow;

//选择的下标
@property (nonatomic,assign) NSInteger      lastSelectedIndex;
@property (nonatomic,assign) NSInteger      lastSelectedCellIndex;

//
@property (nonatomic,strong) NSMutableArray *bgLayers;

//宽高
@property (nonatomic,assign) CGFloat tableViewWith;
@property (nonatomic,assign) CGFloat menuBaseHeight;

//

@property (nonatomic,strong) UIScrollView   *backScrollView;
@property (nonatomic,strong) UITableView *brandTableView;
@property (nonatomic,strong) UICollectionView *brandCollectionView;

@end
static NSString *brandCellID = @"id";


@implementation WJDropdownMenu




//  创建3级列表
- (void)createThreeMenuTitleArray:(NSArray *)menuTitleArray FirstArr:(NSArray *)firstArr SecondArr:(NSArray *)secondArr threeArr:(NSArray *)threeArr{
    self.menuBaseHeight = self.frame.size.height;
    [self createMenuViewWithData:menuTitleArray];
    [self.allDataSource addObject:firstArr];
    [self.allDataSource addObject:secondArr];
    [self.allDataSource addObject:threeArr];
    
    [self createTableViewFirst];
    [self creatcollectionviewFirst];
    //[self creatBrandTable];
    [self createTableViewSecond];
    
}
//  4-----
- (void)changeMenuDataWithIndex:(NSInteger)index{
    
    [self createWithFirstData:self.allDataSource[index][0]];
    NSLog(@"%@",self.allData);
    NSLog(@"%@",self.allDataSource);
    NSLog(@"%ld",index);
    
    if ([self.allDataSource[index] count] <2) {
        self.tableViewWith = self.frame.size.width;
        
        self.allData = nil;
    }else{
        
        self.tableViewWith = self.frame.size.width/2;
        [self createWithSecondData:self.allDataSource[index][1]];
    }
    
    
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point{
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    
    if (self.menuArrowStyle == menuArrowStyleSolid) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(8, 0)];
        [path addLineToPoint:CGPointMake(4, 5)];
    }else{
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(5, 5)];
        [path moveToPoint:CGPointMake(5, 5)];
        [path addLineToPoint:CGPointMake(10, 0)];
    }
    
    [path closePath];
    layer.path = path.CGPath;
    
    layer.lineWidth = 0.8;
    if (self.menuArrowStyle == menuArrowStyleSolid) {
        layer.fillColor = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:0xcc/255.0].CGColor;
    }else{
        layer.strokeColor = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:0xcc/255.0].CGColor;
        layer.fillColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:255/255.0].CGColor;
    }

    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}
//创建背景图层
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position{
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, 20, 20);
    layer.backgroundColor = color.CGColor;
    return layer;
}
//添加手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    if ([touch.view isKindOfClass:[UIButton class]] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]){
        return NO;
    }
    
    return YES;
}
//点击空白收回tableView
- (void)remover{
    
        CALayer *layer = self.bgLayers[self.lastSelectedIndex-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        self.firstTableViewShow = NO;
        self.brandCollectionViewShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith/2, 0);
            self.brandCollectionView.frame =CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
        }];
        
        self.secondTableViewShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.tableSecond.frame = CGRectMake(self.frame.size.width/2,CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
        }];
        
        [self hideCarverView];
    
    
    
    
}
- (void)createMenuViewWithData:(NSArray *)data{
    self.cellHeight = self.cellHeight ? self.cellHeight : cell_h;
    self.lastSelectedIndex = -1;
    self.backgroundColor = self.CarverViewColor ? self.CarverViewColor : [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width
, self.menuBaseHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remover)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    self.bgLayers = [[NSMutableArray alloc]init];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.menuBaseHeight)];
    self.backView.userInteractionEnabled = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    NSInteger num = data.count;
    CGFloat btnW = (self.frame.size.width-num+1)/num;
    for (int i = 0; i < num; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((btnW+1)*i, 0, btnW, self.menuBaseHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 100+i;
        btn.titleLabel.font = self.menuTitleFont ? [UIFont systemFontOfSize:self.menuTitleFont] : menuTitleDefalutFont;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setTitle:data[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showFirstTableView:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint bgLayerPoint = CGPointMake(self.frame.size.width
/num-10, self.menuBaseHeight/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor clearColor] andPosition:bgLayerPoint];
        CGPoint indicatorPoint = CGPointMake(10, 10);
        CAShapeLayer *indicator = [self createIndicatorWithColor:[UIColor lightGrayColor] andPosition:indicatorPoint];
        
        [bgLayer addSublayer:indicator];
        [self.bgLayers addObject:bgLayer];
        [btn.layer addSublayer:bgLayer];
        [self.backView addSubview:btn];
    }
    for (int i = 0; i < num; i++) {
        UILabel *lineLb = [[UILabel alloc]initWithFrame:CGRectMake((btnW+1)*i+btnW, self.menuBaseHeight/10, 0.5, self.menuBaseHeight/10*8)];
        lineLb.backgroundColor = [UIColor lightGrayColor];
        if (i == num - 1) {
            lineLb.hidden = YES;
        }
        [self.backView addSubview:lineLb];
    }
    
    
    
    UILabel *VlineLbTop = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, 0.3)];
    VlineLbTop.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *VlineLbBom = [[UILabel alloc]initWithFrame:CGRectMake(0, self.menuBaseHeight, self.backView.frame.size.width, 0.3)];
    VlineLbBom.backgroundColor = [UIColor lightGrayColor];
    
    [self.backView addSubview:VlineLbTop];
    [self.backView addSubview:VlineLbBom];
    
}
//2 -
- (void)showFirstAndSecondTableView:(NSInteger)index{
    
    [self changeMenuDataWithIndex:index-100];
    
    //  6  ------
   UIButton *btn = (id)[self viewWithTag:index];
    if (self.firstTableViewShow == NO||self.brandCollectionViewShow == NO) {
        [self showCarverView];  
        self.firstTableViewShow = YES;
        self.brandCollectionViewShow = YES;
        
        CALayer *layer = self.bgLayers[index-100];
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
        self.brandCollectionView.frame =CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
        if (btn.tag == 100||btn.tag == 102) {
            [UIView animateWithDuration:0.2 animations:^{
                self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*self.dataSourceFirst.count);
                self.backScrollView.frame =CGRectMake(0, 0, self.tableViewWith, [UIScreen mainScreen].bounds.size.height-self.backView.frame.size.height);
                self.backScrollView.contentSize = CGSizeMake(0, self.cellHeight*self.dataSourceFirst.count+self.cellHeight);
            }];
        }else{
            
            
            if (self.dataSourceFirst.count%2==0) {//偶
                [UIView animateWithDuration:0.2 animations:^{
                    self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*self.dataSourceFirst.count/2);
                    
                }];
            }else{
                //奇
                [UIView animateWithDuration:0.2 animations:^{
                    self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*(self.dataSourceFirst.count+1)/2);
                    
                }];
            }
            
            
        }
        
            
        
    }else{
        
        
            CALayer *layer = self.bgLayers[index-100];
            layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
            self.firstTableViewShow = NO;
            self.brandCollectionViewShow = YES;
            self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*self.dataSourceFirst.count);
        if (self.dataSourceFirst.count%2==0) {//偶
            [UIView animateWithDuration:0.2 animations:^{
                self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*self.dataSourceFirst.count/2);
            }];
        }else{
            //奇
            [UIView animateWithDuration:0.2 animations:^{
                self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, self.cellHeight*(self.dataSourceFirst.count+1)/2);
            }];
        }
        
        if (btn.tag == 100||btn.tag == 102) {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
                
                self.backScrollView.frame =CGRectMake(0, 0, self.tableViewWith, 0);
                self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
                
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                
                self.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
                self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
                
            }];
        }
        
            
            self.secondTableViewShow = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.tableSecond.frame = CGRectMake(self.frame.size.width/2, CGRectGetMaxY(self.backView.frame), self.frame.size.width/2, 0);
                
            }];
       
        
            
        
        [self hideCarverView];
        
    }
    
    
    self.lastSelectedIndex = index;
}
- (void)showCarverView{
    
    if (!self.caverAnimationTime) {
        self.caverAnimationTime = carverAnimationDefalutTime;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width
, window_h-self.frame.origin.y);
    [UIView animateWithDuration:self.caverAnimationTime animations:^{
        self.backgroundColor = self.CarverViewColor ? self.CarverViewColor : [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
    }];
    
}
- (void)hideCarverView{


    if (!self.caverAnimationTime) {
        self.caverAnimationTime = carverAnimationDefalutTime;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width
, self.menuBaseHeight);
    [UIView animateWithDuration:self.caverAnimationTime animations:^{
        self.backgroundColor = self.CarverViewColor ? self.CarverViewColor : [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }];
    
}
//1  -
- (void)showFirstTableView:(UIButton *)btn{
    
    
    NSLog(@"%ld",self.lastSelectedIndex);
    NSLog(@"%ld",btn.tag);
    
    if (self.lastSelectedIndex != btn.tag && self.lastSelectedIndex !=-1) {
        
        CALayer *layer = self.bgLayers[self.lastSelectedIndex-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith/2, 0);
            self.tableSecond.frame = CGRectMake(self.frame.size.width
/2, CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, 0);
           
            self.brandTableView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
        }completion:^(BOOL finished) {
            
            self.firstTableViewShow = NO;
            self.brandCollectionViewShow = NO;
            self.secondTableViewShow = NO;
            [self showFirstAndSecondTableView:btn.tag];
            
        }];
        
    }else{
        [self showFirstAndSecondTableView:btn.tag];
    }
    
    
}
// 7 -------
- (void)showSecondTabelView:(BOOL)secondTableViewShow{
    if (self.secondTableViewShow == YES) {
        
            [self showCarverView];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.tableSecond.frame = CGRectMake(self.frame.size.width
/2, CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, self.cellHeight*self.dataSourceSecond.count);
        }];
    }else{
        
            [self showCarverView];

        self.secondTableViewShow = YES;
        self.tableSecond.frame = CGRectMake(self.frame.size.width
/2, CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.tableSecond.frame = CGRectMake(self.frame.size.width
/2, CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, self.cellHeight*self.dataSourceSecond.count);
        }];
    }
    
}
//3  ------
- (void)createWithFirstData:(NSArray *)dataFirst{
    
    self.dataSourceFirst = [NSMutableArray arrayWithArray:dataFirst];
    [self.brandCollectionView reloadData];
    [self.tableFirst reloadData];
    //[self.brandCollectionView reloadData];
}
//5     ---------
- (void)createWithSecondData:(NSArray *)dataSecond{
    self.allData = [NSMutableArray arrayWithArray:dataSecond];
    [self.tableSecond reloadData];
    
}
- (void)creatBrandTable{
    self.brandTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 0) style:UITableViewStylePlain];
    self.brandTableView.delegate = self;
    self.brandTableView.dataSource = self;
    [self insertSubview:self.brandTableView belowSubview:self.backView];
}

- (void)creatcollectionviewFirst{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    self.brandCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 0) collectionViewLayout:layout];
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    self.brandCollectionView.backgroundColor = [UIColor whiteColor];
    
   
    [self.brandCollectionView registerClass:[BrandCollectionViewCell class] forCellWithReuseIdentifier:brandCellID];
    [self insertSubview:self.brandCollectionView belowSubview:self.backView];
}

//每组元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceFirst.count;
}
//设置元素大小
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/2, self.cellHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//设置上一个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    BrandCollectionViewCell *brandcell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCellID forIndexPath:indexPath];
//    brandcell.label.textColor = [UIColor blackColor];
    
    
    
    
    
    NSLog(@"%@-----------------------------------",indexPath);
}


//查询创建UICollectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCellID forIndexPath:indexPath];
    cell.label.text = self.dataSourceFirst[indexPath.row];
    cell.label.font =self.tableTitleFont ? [UIFont systemFontOfSize:self.tableTitleFont+2] : TableTitleDefalutFont;

    cell.backgroundColor = [UIColor whiteColor];
    UILabel *lineLVertical = [[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width-0.5, 0, 0.5, self.cellHeight)];
    lineLVertical.backgroundColor = [UIColor lightGrayColor];

    [cell.contentView addSubview:lineLVertical];
    UILabel *labelHorizontal = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
    labelHorizontal.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:labelHorizontal];
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}

//选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandCollectionViewCell *cell = (BrandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    BrandCollectionViewCell *cell = (BrandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.label.textColor =[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8];
    
    __weak typeof(self)weakSelf = self;
    void (^complete)(void) = ^(void){
        CALayer *layer = self.bgLayers[weakSelf.lastSelectedIndex-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        UIButton *btn = (id)[self viewWithTag:weakSelf.lastSelectedIndex];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.brandCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.tableViewWith, 0);
            
        }];
        weakSelf.brandCollectionViewShow = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.tableSecond.frame = CGRectMake(self.frame.size.width
                                                    /2,CGRectGetMaxY(self.backView.frame), self.frame.size.width
                                                    /2, 0);
        }];
        [weakSelf hideCarverView];
        
        if (weakSelf.allData) {
            
            cell.label.textColor =[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8];
            
            [btn setTitle:weakSelf.dataSourceSecond[indexPath.row] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8] forState:UIControlStateNormal];
            
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstIndex:andSecondIndex:)]) {
                
                [_delegate menuCellDidSelected:weakSelf.lastSelectedIndex-100 firstIndex:weakSelf.lastSelectedCellIndex andSecondIndex:indexPath.row];
                
            }
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstContent:andSecondContent:)]) {
                [_delegate menuCellDidSelected:weakSelf.dataSourceSecond[indexPath.row] firstContent:weakSelf.dataSourceFirst[weakSelf.lastSelectedCellIndex] andSecondContent:weakSelf.dataSourceSecond[indexPath.row]];
            }
            
        }else{
            
//            BrandCollectionViewCell *cell = (BrandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//            
//            cell.label.textColor =[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8];
            
            [btn setTitle:weakSelf.dataSourceFirst[indexPath.row] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8] forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstIndex:andSecondIndex:)]) {
                [_delegate menuCellDidSelected:weakSelf.lastSelectedIndex-100 firstIndex:indexPath.row andSecondIndex:0];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstContent:andSecondContent:)]) {
                [_delegate menuCellDidSelected:weakSelf.dataSourceFirst[indexPath.row] firstContent:weakSelf.dataSourceFirst[indexPath.row] andSecondContent:nil];
            }
        }
        
    };
    
        NSInteger i = indexPath.row;
        self.lastSelectedCellIndex = indexPath.row;
        if (self.allData) {
            self.dataSourceSecond = self.allData[i];
            [self.tableSecond reloadData];
            [self showSecondTabelView:self.secondTableViewShow];
        }else{
            complete();
        }
   
        complete();
    
    
}

- (void)createTableViewFirst{
    
    //CGRectGetMaxY(self.backView.frame)
    self.tableFirst = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width/2, 0) style:UITableViewStylePlain];
    
    self.tableFirst.scrollEnabled = NO;
    self.tableFirst.delegate = self;
    self.tableFirst.dataSource = self;
    
    //CGRectGetMaxY(self.backView.frame)
        self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backView.frame),self.frame.size.width/2, 0)];
    
       // self.backScrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    
    
    
    [self insertSubview:self.backScrollView belowSubview:self.backView];
    [self.backScrollView insertSubview:self.tableFirst belowSubview:self.backView];
    //[self.backScrollView addSubview:self.tableFirst];
}

- (void)createTableViewSecond{
    self.tableSecond = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, 0) style:UITableViewStylePlain];
    self.tableSecond.scrollEnabled = NO;
    self.tableSecond.delegate = self;
    self.tableSecond.dataSource = self;
    self.tableSecond.autoresizesSubviews = NO;
    [self insertSubview:self.tableSecond belowSubview:self.backView];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableFirst) {
        return self.dataSourceFirst.count;
    }
    //if (tableView == self.brandTableView) {
      //  if (self.dataSourceFirst.count%2==0) {//如果是偶数
        //    return self.dataSourceFirst.count/2;
        //}else{//如果是奇数
          //  return (self.dataSourceFirst.count+1)/2;
        //}
        
    //}
    else{
        return self.dataSourceSecond.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableFirst) {
        static NSString *cellID = @"cellFirst";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell1.textLabel.text = self.dataSourceFirst[indexPath.row];
        cell1.textLabel.font = self.tableTitleFont ? [UIFont systemFontOfSize:self.tableTitleFont+2] : TableTitleDefalutFont;
        if (!self.allData) {
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell1.selectionStyle = UITableViewCellSelectionStyleGray;
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell1;
    }
    else{
        static NSString *cellIde = @"cellSecond";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
        }
        cell2.textLabel.text = self.dataSourceSecond[indexPath.row];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.textLabel.font = self.tableTitleFont ? [UIFont systemFontOfSize:self.tableTitleFont+2] : TableTitleDefalutFont;
        return cell2;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self)weakSelf = self;
    void (^complete)(void) = ^(void){
        CALayer *layer = self.bgLayers[weakSelf.lastSelectedIndex-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        UIButton *btn = (id)[self viewWithTag:weakSelf.lastSelectedIndex];
        weakSelf.firstTableViewShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.tableFirst.frame = CGRectMake(0, CGRectGetMaxY(weakSelf.backView.frame), self.tableViewWith/2, 0);
        }];
        weakSelf.brandCollectionViewShow = NO;
        weakSelf.secondTableViewShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.tableSecond.frame = CGRectMake(self.frame.size.width
/2,CGRectGetMaxY(self.backView.frame), self.frame.size.width
/2, 0);
        }];
        [weakSelf hideCarverView];
        
        if (weakSelf.allData) {
            
            [btn setTitle:weakSelf.dataSourceSecond[indexPath.row] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8] forState:UIControlStateNormal];
           
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstIndex:andSecondIndex:)]) {
                
                [_delegate menuCellDidSelected:weakSelf.lastSelectedIndex-100 firstIndex:weakSelf.lastSelectedCellIndex andSecondIndex:indexPath.row];
          
            }
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstContent:andSecondContent:)]) {
                [_delegate menuCellDidSelected:weakSelf.dataSourceSecond[indexPath.row] firstContent:weakSelf.dataSourceFirst[weakSelf.lastSelectedCellIndex] andSecondContent:weakSelf.dataSourceSecond[indexPath.row]];
            }
            
        }else{
            
            [btn setTitle:weakSelf.dataSourceFirst[indexPath.row] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:0.8] forState:UIControlStateNormal];
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstIndex:andSecondIndex:)]) {
                [_delegate menuCellDidSelected:weakSelf.lastSelectedIndex-100 firstIndex:indexPath.row andSecondIndex:0];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(menuCellDidSelected:firstContent:andSecondContent:)]) {
                [_delegate menuCellDidSelected:weakSelf.dataSourceFirst[indexPath.row] firstContent:weakSelf.dataSourceFirst[indexPath.row] andSecondContent:nil];
            }
        }
        
    };
    if (tableView == self.tableFirst) {
        NSInteger i = indexPath.row;
        self.lastSelectedCellIndex = indexPath.row;
        if (self.allData) {
            self.dataSourceSecond = self.allData[i];
            [self.tableSecond reloadData];
            [self showSecondTabelView:self.secondTableViewShow];
        }else{
            complete();
        }
    }else{
        complete();
    }
}
/*
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
*/


- (NSMutableArray *)allDataSource{
    if (_allDataSource == nil) {
        _allDataSource = [NSMutableArray array];
    }
    return _allDataSource;
}

@end
