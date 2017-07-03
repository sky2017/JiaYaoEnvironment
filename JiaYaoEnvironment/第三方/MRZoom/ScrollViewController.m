//
//  ScrollViewController.m
//  XiaoYuanJianZhi
//
//  Created by mac on 16/2/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@property (nonatomic,strong)ScrollVBlock block;
@end

@implementation ScrollViewController
- (void)getScrollVBlock:(ScrollVBlock)block{

    _block = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)newScrollV{

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView setContentSize:CGSizeMake(self.view.width * self.imgArr.count, self.view.height )];
    
    [_scrollView setContentOffset:CGPointMake(self.index * self.view.width, 0) animated:NO];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 44*self.scale-150/2.34*self.scale, self.view.width, 44*self.scale)];
    
    lab.text = [NSString stringWithFormat:@"%@/%lu",@"1",(unsigned long)_imgArr.count];
    lab.tag = 999;
    lab.font = [UIFont systemFontOfSize:15*self.scale];
    lab.textColor = [UIColor     whiteColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = 1;
    [self.view  addSubview:lab];
    
    
    if (_index) {
        lab.text = [NSString stringWithFormat:@"%d/%lu",_index+ 1,(unsigned long)_imgArr.count];
    }

    for (int i = 0; i < self.imgArr.count; i++) {
        
        _zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _zoomScrollView.backgroundColor = [UIColor blackColor];
        [_zoomScrollView initImageView];
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        //必须放在图片赋值的前面.
        _zoomScrollView.imageView.contentMode=UIViewContentModeScaleAspectFit;
        if([self.Login isEqualToString:@"1"])
        {
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imgArr[i]]];
            [_zoomScrollView.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"notpad1"]];
        }
        else
        {
            UIImage *image=(UIImage *)self.imgArr[i];
            _zoomScrollView.imageView.image=image;
        }
        [self.scrollView addSubview:_zoomScrollView];
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShouShi:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_zoomScrollView.imageView addGestureRecognizer:singleRecognizer];
 //在scrollView上添加删除按钮,可以删除对应的图片.
        UIButton *buttonDelete=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60*self.scale, 10, 60*self.scale, 30*self.scale)];
        [_zoomScrollView addSubview:buttonDelete];
        [buttonDelete setTitle:@"删除" forState:UIControlStateNormal];
        [buttonDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonDelete.tag=i+1;
        [buttonDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        buttonDelete.titleLabel.font=DefaultFont(self.scale);
        if([self.Login isEqualToString:@"1"])
        {
            buttonDelete.hidden=YES;
        }
    }
}
-(void)delete:(UIButton *)button
{
    //判断deleItem:这个代理方法是否被调用过.
    if([self.delegate respondsToSelector:@selector(deleItem:)])
    {
         _block (nil);
        [self.delegate deleItem:button.tag-1];
    }
}
- (void)ShouShi:(UITapGestureRecognizer *)ShouShi{
    
    _block (nil);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint point=[scrollView contentOffset];
    int n=(int)point.x/(scrollView.width);

    UILabel *lab = [self.view viewWithTag:999];
    lab.text = [NSString stringWithFormat:@"%d/%lu",n + 1,(unsigned long)_imgArr.count];
    if(self.blockNum)
    {
        NSString*Num=[NSString stringWithFormat:@"%d",n];
        self.blockNum(Num);
    }
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
