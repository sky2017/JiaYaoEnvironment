//
//  yijianfankuiViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "yijianfankuiViewController.h"
#import "LoginViewController.h"
#import "TZImagePickerController.h"
#import "ScrollViewController.h"
@interface yijianfankuiViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,MRZoomScrollViewDelegate>
@property (nonatomic,assign)NSInteger reminderTag;
@property (nonatomic,strong)NSMutableArray *SaveDict;
@property (nonatomic,strong)NSMutableArray *LeftArryPhoto;
@property (nonatomic,strong)UIButton *buttonjia;
@property (nonatomic,strong)ScrollViewController *scrollImage;
@end

@implementation yijianfankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //图片存在的数组
    self.LeftArryPhoto=[[NSMutableArray alloc]init];
    //以字典的形式存储
    _SaveDict=[[NSMutableArray alloc]init];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"需求反馈";
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
    self.view.backgroundColor=Fbottomcolor;
//    UILabel *labelTop=[[UILabel alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 64+20/2.34*self.scale, self.view.width-60/2.34*self.scale, 60/2.34*self.scale)];
//    labelTop.font=SmallFont(self.scale);
//    labelTop.textColor=blackTextColor;
//    labelTop.text=@"告诉 \"佳垚环境\" 您的宝贵意见,我们改进会更快哟";
//    [self.view addSubview:labelTop];
    UIView *viewwenben=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 470/2.34*self.scale)];
    viewwenben.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewwenben];
    
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(30/2.34*self.scale,20/2.34*self.scale, self.view.width-60/2.34*self.scale, 400/2.34*self.scale)];
    textView.backgroundColor=[UIColor whiteColor];
    textView.tag=10089;
    textView.textColor=blackTextColor;
    textView.delegate=self;
    textView.font=SmallFont(self.scale);
    [viewwenben addSubview:textView];
    
    //反馈内容
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale,0, textView.width, 30)];
    placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    placeLabel.text=@"请填写内容";
    placeLabel.tag=12;
    placeLabel.font=DefaultFont(self.scale);
    [textView addSubview:placeLabel];
    
    
    CGFloat Width=(self.view.width-20/2.34*self.scale*5)/4;
    UIView *viewImage=[[UIView alloc]initWithFrame:CGRectMake(0, viewwenben.bottom, self.view.width, 20/2.34*self.scale*2+Width*2)];
    viewImage.tag=777;
    [self.view addSubview:viewImage];
    //上传图片
    
    _buttonjia=[[UIButton alloc]initWithFrame:CGRectMake(20/2.34*self.scale,20/2.34*self.scale, Width, Width)];
    [_buttonjia setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_buttonjia addTarget:self action:@selector(jia:) forControlEvents:UIControlEventTouchUpInside];
    [viewImage addSubview:_buttonjia];
    
    
    UIButton *buttontuijian=[[UIButton alloc]initWithFrame:CGRectMake(30/2.34*self.scale, viewwenben.bottom+Width*2+20/2.34*self.scale*2+80/2.34*self.scale, self.view.width-60/2.34*self.scale, 80/2.34*self.scale)];
    buttontuijian.backgroundColor=Fmaincolor;
    buttontuijian.layer.cornerRadius=5;
    buttontuijian.layer.masksToBounds=YES;
    [buttontuijian setTitle:@"提交" forState:UIControlStateNormal];
    [buttontuijian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttontuijian.adjustsImageWhenHighlighted=NO;
    buttontuijian .titleLabel.font=Big14Font(self.scale);
    [buttontuijian addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttontuijian];
}
#pragma mark---UITextView代理----
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];//此label是需要在UITextView上显示的.相当于UITextFiled的placehold.
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
//    if (textView.text.length>140) {
//        textView.text=[textView.text substringToIndex:140];
//    }
}
#pragma mark---EVENT---
-(void)jia:(UIButton *)button
{
   //_reminderTag=button.tag;
    NSInteger NumLeft=8-_SaveDict.count;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:NumLeft delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark---获取照片代理--
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    for (NSInteger i=0; i<photos.count; i++) {
        [self.LeftArryPhoto addObject:photos[i]];
        UIImage *newimage=photos[i];
        UIImage *imageyasuo= [self scaleImage:newimage];
        //将图片转化为数据类型参数(图片,压缩比例)
        NSData *imgData=UIImageJPEGRepresentation(imageyasuo, 0.8);
        NSString *base64img=[imgData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength];
        [_SaveDict addObject:base64img];
    }
    //重新规划图片的显示
   [self setImageView];
}
-(void)setImageView
{
    NSLog(@"_SaveDict==%lu",_SaveDict.count);
      CGFloat Width=(self.view.width-20/2.34*self.scale*5)/4;
     UIView *viewB=(UIView *)[self.view viewWithTag:777];
    NSArray *arry=viewB.subviews;
    for (int i=0; i<arry.count; i++) {
        UIButton *buttonshow=(UIButton *)arry[i];
        [buttonshow removeFromSuperview];
    }
    UIButton *buttonreminder=[[UIButton alloc]init];
    for ( int i=0; i<_SaveDict.count; i++) {
        UIButton *buttonaddImage=[[UIButton alloc]initWithFrame:CGRectMake(20/2.34*self.scale+(Width+20/2.34*self.scale)*(i%4),20/2.34*self.scale+(Width+20/2.34*self.scale)*(i/4),Width,Width)];
        [buttonaddImage setImage:_LeftArryPhoto[i] forState:UIControlStateNormal];
        buttonaddImage.tag=i+1;
        [viewB addSubview:buttonaddImage];
        [buttonaddImage addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        if(i==_SaveDict.count-1)
        {
            buttonreminder=buttonaddImage;
        }
    }
    if(_SaveDict.count==8)
    {
        _buttonjia.hidden=YES;
    }
    else
    {
         _buttonjia.hidden=NO;
        if(_SaveDict.count==4)
        {
            _buttonjia.frame=CGRectMake(20/2.34*self.scale, buttonreminder.bottom+20/2.34*self.scale, Width, Width);
              [viewB addSubview:_buttonjia];
        }
        else
        {
         _buttonjia.frame=CGRectMake(buttonreminder.right+20/2.34*self.scale,buttonreminder.top, Width, Width);
            [viewB addSubview:_buttonjia];
        }
    }
    
}
-(void)chooseImage:(UIButton *)button
{
    _scrollImage=[[ScrollViewController alloc]init];
    NSArray *arryScroll=[_LeftArryPhoto copy];
    _scrollImage.imgArr=arryScroll;
    int num=(int)arryScroll.count;
    _scrollImage.delegate=self;
    _scrollImage.index=(button.tag-1)%num;
    [_scrollImage newScrollV];
    [_scrollImage getScrollVBlock:^(NSString *str) {
        [UIView animateWithDuration:.3 animations:^{
            _scrollImage.view.alpha = 0;
        }completion:^(BOOL finished) {
            [_scrollImage.view removeFromSuperview];
            _scrollImage= nil;
        } ];
    }];
    [self.view addSubview:_scrollImage.view];
}
-(void)deleItem:(NSInteger)deleteImageNum
{
    UIView *viewB=(UIView *)[self.view viewWithTag:777];
    [self.LeftArryPhoto removeObjectAtIndex:deleteImageNum];
    [self.SaveDict removeObjectAtIndex:deleteImageNum];
    NSArray *arry=viewB.subviews;
    for (int i=0; i<arry.count; i++) {
        UIImageView *imageView=(UIImageView *)arry[i];
        [imageView removeFromSuperview];
    }
    [self setImageView];
}
-(void)submit
{
    UITextView *textview=(UITextView *)[self.view viewWithTag:10089];
    if([textview.text isEqualToString:@""])
    {
        [self showMessage:@"意见不能为空" getself:self];
        return;
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
    if([ID isEmptyString])
    {
        //跳到首页
        LoginViewController *login=[LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    NSString *baseString=@"";
    if(self.SaveDict.count==0)
    {
    baseString=@"";
    }
    else
    {
        for (int i=0; i<self.SaveDict.count; i++) {
            if(i==0)
            {
                baseString=self.SaveDict[0];
            }
            else
            {
                baseString=[NSString stringWithFormat:@"%@%@%@",baseString,@";",self.SaveDict[i]];
            }
        }
    }
    NSLog(@"baseString===%@",baseString);
    [self startProgress];
    analyticClass *analy=[analyticClass new];
    [analy yijianfankui:ID getremark:textview.text getsource:@"ios" getbase64Img:baseString  Block:^(id models, NSString *code, NSString *msg) {
        [self stopProgress];
        if([code isEqualToString:@"1"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertController *control=[UIAlertController alertControllerWithTitle:@"" message:@"反馈成功" preferredStyle:UIAlertControllerStyleAlert];
            [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self.navigationController.topViewController presentViewController:control animated:YES completion:nil];

        }
        else
        {
            [self showMessage:msg getself:self];
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
