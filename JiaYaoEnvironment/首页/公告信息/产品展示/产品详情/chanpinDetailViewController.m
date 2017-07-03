//
//  chanpinDetailViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 apple. All rights reserved.
//


#import "chanpinDetailViewController.h"
#import "SDCycleScrollView.h"
#import "ScrollViewController.h"
#import "LoginViewController.h"
@interface chanpinDetailViewController ()<SDCycleScrollViewDelegate,MRZoomScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollViewData;
@property (nonatomic,strong)NSDictionary *dictData;
@property (nonatomic,strong)NSMutableArray *MarryImage;
//轮播全局变量
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView3;
@property (nonatomic,strong)ScrollViewController *scrollImageSecond;
@property (nonatomic,strong)UIWebView *webviewproduct;
@property (nonatomic,strong)UIWebView *webviewxiangqing;
@property (nonatomic,assign)NSInteger reminderTag;
@end

@implementation chanpinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reminderTag=1;
    _MarryImage=[[NSMutableArray alloc]init];
    _dictData=[[NSDictionary alloc]init];
    [self setNavigation];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy shangpinDetail:ID getproductId:self.chanpinid Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            _dictData=[models mutableCopy];
            [self setUI];
        }
        else
        {
            [self showMessage:msg getself:self];
        }
    }];
}
-(void)setNavigation
{
    //设置左边边图片
    UIButton *buttonL=[[UIButton alloc]initWithFrame:CGRectMake(0
                                                                , self.NavTitle.top, self.NavTitle.height, self.NavTitle.height)];
    [buttonL setImage:[UIImage imageNamed:@"arrow_left_1"] forState:UIControlStateNormal];
    [buttonL addTarget:self action:@selector(leftJump) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:buttonL];
    UIImageView *imageViewTop=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-150/2.34, 64-80/2.34, 300/2.34, 60/2.34)];
    imageViewTop.image=[UIImage imageNamed:@"shangpin"];
    imageViewTop.userInteractionEnabled=YES;
    imageViewTop.tag=1000;
    [self.NavImg addSubview:imageViewTop];
    
    NSArray *arry=[[NSArray alloc]initWithObjects:@"商品",@"详情", nil];
    for (int i=0; i<arry.count; i++) {
        UIButton* positionL=[[UIButton alloc]initWithFrame:CGRectMake(i*150/2.34,0,150/2.34,60/2.34)];
        positionL.titleLabel.font=DefaultFont(self.scale);
        if(i==0)
        {
         [positionL setTitleColor:Fmaincolor forState:UIControlStateNormal];
        }
        else{
        [positionL setTitleColor:whiteLineColore forState:UIControlStateNormal];
        }
        [positionL setTitle:arry[i] forState:UIControlStateNormal];
        positionL.tag=i+1;
        [positionL setBackgroundImage:[UIImage ImageForColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [positionL addTarget:self action:@selector(topEvent:) forControlEvents:UIControlEventTouchUpInside];
        [imageViewTop  addSubview:positionL];
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"index===%lu",index);
    NSArray *arryImage=_MarryImage;
    _scrollImageSecond=[[ScrollViewController alloc]init];
    NSArray *arryScroll=[arryImage copy];
    _scrollImageSecond.imgArr=arryScroll;
    int num=(int)arryScroll.count;
    _scrollImageSecond.delegate=self;
    _scrollImageSecond.Login=@"1";
    _scrollImageSecond.index=(index)%num;
    [_scrollImageSecond newScrollV];
    [_scrollImageSecond getScrollVBlock:^(NSString *str) {
        [UIView animateWithDuration:.3 animations:^{
            _scrollImageSecond.view.alpha = 0;
        }completion:^(BOOL finished) {
            [_scrollImageSecond.view removeFromSuperview];
            _scrollImageSecond= nil;
        } ];
    }];
    [self.view addSubview:_scrollImageSecond.view];

}
-(void)setUI
{
    self.scrollViewData=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-90/2.34*self.scale)];
    self.scrollViewData.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.scrollViewData];
    [_MarryImage removeAllObjects];
    NSArray *arrybannerImg=[[_dictData objectForKey:@"bannerImg"] mutableCopy];
    for ( int i=0; i<arrybannerImg.count; i++) {
        [_MarryImage addObject:[arrybannerImg[i] objectForKey:@"img_url"]];
    }
    //轮播图
    // 网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.width) delegate:self placeholderImage:[UIImage imageNamed:@"notpad1"]];
    _cycleScrollView3.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView3.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
      _cycleScrollView3.imageURLStringsGroup = _MarryImage;
     _cycleScrollView3.currentPageDotColor=Fmaincolor;
    _cycleScrollView3.autoScrollTimeInterval = 3;
    [self.scrollViewData addSubview:_cycleScrollView3];

    //标题
    UILabel *labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(30/2.34*self.scale, _cycleScrollView3.bottom+30/2.34*self.scale, self.view.width-60/2.34*self.scale, 20)];
    labelTitle.textColor=blackTextColor;
    labelTitle.font=DefaultFont(self.scale);
    labelTitle.numberOfLines=0;
    labelTitle.text=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"name"]];
    [labelTitle sizeToFit];
    [self.scrollViewData addSubview:labelTitle];
    UILabel *labelMoney=[[UILabel alloc]initWithFrame:CGRectMake(labelTitle.left, labelTitle.bottom, labelTitle.width, 50/2.34*self.scale)];
    labelMoney.textColor=textColorred;
    labelMoney.font=DefaultFont(self.scale);
    labelMoney.text=[NSString stringWithFormat:@"%@%@",@"￥",[_dictData objectForKey:@"productPrice"]];
    [self.scrollViewData addSubview:labelMoney];
    //品牌
    UILabel *labelpinpai=[[UILabel alloc]initWithFrame:CGRectMake(labelTitle.left, labelMoney.bottom, labelTitle.width/2, 60/2.34*self.scale)];
    labelpinpai.textColor=black153Color;
    labelpinpai.font=DefaultFont(self.scale);
    labelpinpai.text=[NSString stringWithFormat:@"%@%@",@"品牌 : ",[_dictData objectForKey:@"brandName"]];
    [self.scrollViewData addSubview:labelpinpai];
    UIView *viewhuise=[[UIView alloc]initWithFrame:CGRectMake(0, labelpinpai.bottom+20/2.34*self.scale, self.view.width, 20/2.34*self.scale)];
    viewhuise.backgroundColor=Fbottomcolor;
    [viewhuise addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [viewhuise addSubview:[self getView:CGRectMake(0, viewhuise.height-.5, self.view.width, .5)]];
    [self.scrollViewData addSubview:viewhuise];
    
    CGSize sizeshoucang=[NSString getLabelText:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"collectCount"]] getLabelSize:CGSizeMake(MAXFLOAT, MAXFLOAT) getTextFont:[UIFont systemFontOfSize:12*self.scale]];
    CGFloat Widthshoucang=sizeshoucang.width+60/2.34*self.scale;
   UIButton *buttonshoucang=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-30/2.34*self.scale-Widthshoucang, labelpinpai.top, Widthshoucang, labelpinpai.height)];
    buttonshoucang.titleLabel.font=SmallFont(self.scale);
    [buttonshoucang setTitle:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"collectCount"]] forState:UIControlStateNormal];
    [buttonshoucang setImage:[UIImage imageNamed:@"icon_lvxin"] forState:UIControlStateNormal];
    [buttonshoucang setTitleColor:blackTextColor forState:UIControlStateNormal];
       [buttonshoucang TiaoZhengButtonWithOffsit:2 TextImageSite:UIButtonTextRight];
    //[buttonshoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewData addSubview:buttonshoucang];
    
    
    CGSize sizesee=[NSString getLabelText:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"click"]] getLabelSize:CGSizeMake(MAXFLOAT, MAXFLOAT) getTextFont:[UIFont systemFontOfSize:12*self.scale]];
    CGFloat Widthsee=sizesee.width+60/2.34*self.scale;
    UIButton *buttonsee=[[UIButton alloc]initWithFrame:CGRectMake(buttonshoucang.left-60/2.34*self.scale-sizesee.width, buttonshoucang.top, Widthsee, buttonshoucang.height)];
    buttonsee.titleLabel.font=SmallFont(self.scale);
    [buttonsee setTitle:[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"click"]] forState:UIControlStateNormal];
    [buttonsee setTitleColor:blackTextColor forState:UIControlStateNormal];
      [buttonsee setImage:[UIImage imageNamed:@"icon_eyesk"] forState:UIControlStateNormal];
     [buttonsee TiaoZhengButtonWithOffsit:2 TextImageSite:UIButtonTextRight];
    [buttonsee addTarget:self action:@selector(see) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewData addSubview:buttonsee];
    
    
    //商品参数
    UIView *viewshangpin=[[UIView alloc]initWithFrame:CGRectMake(0, viewhuise.bottom, self.view.width, 80/2.34*self.scale)];
    viewshangpin.backgroundColor=[UIColor whiteColor];
    [self.scrollViewData addSubview:viewshangpin];
    UIImageView *imagexian=[[UIImageView alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 20/2.34*self.scale, 2, 40/2.34*self.scale)];
    imagexian.backgroundColor=Fmaincolor;
    [viewshangpin addSubview:imagexian];
    UILabel *labelcanshu=[[UILabel alloc]initWithFrame:CGRectMake(imagexian.right+20/2.34*self.scale, 0, self.view.width-imagexian.right, viewshangpin.height)];
    labelcanshu.textColor=blackTextColor;
    labelcanshu.font=Big14Font(self.scale);
    labelcanshu.text=@"商品参数";
    [viewshangpin addSubview:[self getView:CGRectMake(30/2.34*self.scale, viewshangpin.height-.5, self.view.width-60/2.34*self.scale, .5)]];
    [viewshangpin addSubview:labelcanshu];

    _webviewproduct=[[UIWebView alloc]initWithFrame:CGRectMake(0, viewshangpin.bottom, self.view.width, 0)];
    _webviewproduct.tag=10010;
    _webviewproduct.scrollView.scrollEnabled=NO;
    _webviewproduct.backgroundColor=[UIColor whiteColor];
    _webviewproduct.delegate=self;
    [self webViewLoadHTML:@"" Title:@"" Content:[_dictData objectForKey:@"productSpec"]];
    [self.scrollViewData addSubview:_webviewproduct];

    
    _webviewxiangqing=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-90/2.34*self.scale)];
    _webviewxiangqing.tag=10086;
    _webviewxiangqing.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webviewxiangqing];
    _webviewxiangqing.hidden=YES;
    [self webViewLoadHTMLs:@"" Title:@"" Content:[_dictData objectForKey:@"contents"]];
    
    UIView *viewBottom=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-90/2.34*self.scale, self.view.width, 90/2.34*self.scale)];
    [self.view addSubview:viewBottom];
    viewBottom.backgroundColor=[UIColor redColor];
    NSArray *arryshoucang=[[NSArray alloc]initWithObjects:@"收藏",@"电话咨询", nil];
    for (int i=0; i<arryshoucang.count; i++) {
        UIButton *buttonData=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2*i, 0, self.view.width/2, viewBottom.height)];
        buttonData.titleLabel.font=Big14Font(self.scale);
        buttonData.tag=100+i;
        [buttonData setTitle:arryshoucang[i] forState:UIControlStateNormal];
        if(i==0)
        {
          [buttonData setTitleColor:black153Color forState:UIControlStateNormal];
            [buttonData setImage:[UIImage imageNamed:@"hurt_xin"] forState:UIControlStateNormal];
            buttonData.backgroundColor=Fbottomcolor;
            [buttonData setImage:[UIImage imageNamed:@"shoucangzhuangtai"] forState:UIControlStateSelected];
             NSString *isCollect=[NSString stringWithFormat:@"%@",[_dictData objectForKey:@"isCollect"]];
              buttonData.adjustsImageWhenHighlighted=NO;
            buttonData.adjustsImageWhenDisabled=NO;
            if([isCollect isEqualToString:@"0"])
            {
            buttonData.selected=NO;
            }
            else
            {
                buttonData.selected=YES;
            }
        }
        else
        {
                [buttonData setImage:[UIImage imageNamed:@"icon_phones"] forState:UIControlStateNormal];
           [buttonData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             buttonData.backgroundColor=Fmatchcolor;
        }
        [buttonData TiaoZhengButtonWithOffsit:10 TextImageSite:UIButtonTextRight];
        [buttonData addTarget:self action:@selector(showData:) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:buttonData];
        [viewBottom addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    }
    
    UIImageView *imageview=(UIImageView *)[self.view viewWithTag:1000];
    if(_reminderTag==1)
    {
        imageview.image=[UIImage imageNamed:@"shangpin"];
        UIButton *buttonnomol=(UIButton *)[self.view viewWithTag:2];
        [buttonnomol setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *buttonreminder=(UIButton *)[self.view viewWithTag:_reminderTag];
        [buttonreminder setTitleColor:Fmaincolor forState:UIControlStateNormal];
        _scrollViewData.hidden=NO;
        _webviewproduct.hidden=NO;
        _webviewxiangqing.hidden=YES;
    }
    else
    {
        imageview.image=[UIImage imageNamed:@"xiangqing"];
        UIButton *buttonnomol=(UIButton *)[self.view viewWithTag:1];
        [buttonnomol setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *buttonreminder=(UIButton *)[self.view viewWithTag:_reminderTag];
        [buttonreminder setTitleColor:Fmaincolor forState:UIControlStateNormal];
        _scrollViewData.hidden=YES;
        _webviewproduct.hidden=YES;
        _webviewxiangqing.hidden=NO;
        
    }

}
#pragma mark----UIWebView代理---
-(void)webViewDidFinishLoad:(UIWebView *)webView{
        [self performSelector:@selector(yanchi) withObject:self afterDelay:0.2];
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height= webViewHeight;
    NSLog(@"webViewHeight==%f",webViewHeight);
    NSLog(@"_webviewproduct.bottom===%f",_webviewproduct.bottom);
    _webviewproduct.frame= newFrame;
    _scrollViewData.contentSize=CGSizeMake(self.view.width, _webviewproduct.bottom);
   
}
-(void)yanchi
{
    CGFloat webViewHeight =[[_webviewproduct stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect newFrame = _webviewproduct.frame;
    newFrame.size.height= webViewHeight;
    NSLog(@"webViewHeight==%f",webViewHeight);
    NSLog(@"_webviewproduct.bottom===%f",_webviewproduct.bottom);
    _webviewproduct.frame= newFrame;
    _scrollViewData.contentSize=CGSizeMake(self.view.width, _webviewproduct.bottom);
}
-(void)webViewLoadHTML:(NSString *)Title Title:(NSString *)Timer Content:(NSString *)content
{
    NSString *BookStr = [NSString stringWithFormat:@"%@",content];
    [_webviewproduct loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
}
-(void)webViewLoadHTMLs:(NSString *)Title Title:(NSString *)Timer Content:(NSString *)content
{
    NSString *BookStr = [NSString stringWithFormat:@"%@",content];
    [_webviewxiangqing loadHTMLString:BookStr baseURL:[NSURL URLWithString:YUMING]];
}
#pragma mark---EVENT---
-(void)topEvent:(UIButton *)button
{
    UIImageView *imageview=(UIImageView *)[self.view viewWithTag:1000];
    if(button.tag==1)
    {
        imageview.image=[UIImage imageNamed:@"shangpin"];
        UIButton *buttonnomol=(UIButton *)[self.view viewWithTag:2];
        [buttonnomol setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:Fmaincolor forState:UIControlStateNormal];
        _scrollViewData.hidden=NO;
         _webviewproduct.hidden=NO;
        _webviewxiangqing.hidden=YES;
    }
    if(button.tag==2)
    {
          imageview.image=[UIImage imageNamed:@"xiangqing"];
        UIButton *buttonnomol=(UIButton *)[self.view viewWithTag:1];
        [buttonnomol setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [button setTitleColor:Fmaincolor forState:UIControlStateNormal];
        _scrollViewData.hidden=YES;
         _webviewproduct.hidden=YES;
        _webviewxiangqing.hidden=NO;
    }
    _reminderTag=button.tag;
}
-(void)showData:(UIButton *)button
{
if(button.tag==100)
{
        //未收藏
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    if([ID isEmptyString])
    {
        LoginViewController *login=[LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
        [self startProgress];
        NSString *outerId=[NSString stringWithFormat:@"%@",self.chanpinid];
        analyticClass *analy=[analyticClass new];
        [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
            [self stopProgress];
            if([code isEqualToString:@"1"])
            {
           // [self showMessage:msg getself:self];
                [self getData];
            }
            else
            {
            //    [self showMessage:msg getself:self];
            }
        }];
}
    if(button.tag==101)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *tel= [defaults objectForKey:@"tel"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
-(void)see
{

}
-(void)shoucang
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
    NSString *outerId=[NSString stringWithFormat:@"%@",self.chanpinid];
    analyticClass *analy=[analyticClass new];
    [analy tianjiaquxiaoshoucang:ID getouterId:outerId getmark:@"product" getaction:@"" Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
          //  [self showMessage:msg getself:self];
            [self getData];
        }
        else
        {
           // [self showMessage:msg getself:self];
        }
    }];

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
