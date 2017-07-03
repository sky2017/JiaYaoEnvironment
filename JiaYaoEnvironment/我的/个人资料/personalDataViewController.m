//
//  personalDataViewController.m
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "personalDataViewController.h"
#import "personalTableViewCell.h"
#import "shezhiNicknameViewController.h"
@interface personalDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *Marry;
@property (nonatomic,strong)NSMutableArray *MarryRight;
@end

@implementation personalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _Marry=[[NSMutableArray alloc]initWithObjects:@"昵称",@"性别",@"手机号", nil];
    NSString *xingbie=@"";
    if([self.sex isEqualToString:@"1"])
    {
    xingbie=@"男";
    }
    else if ([self.sex isEqualToString:@"2"])
    {
     xingbie=@"女";
    }
    else
    {
    xingbie=@"";
    }
    _MarryRight=[[NSMutableArray alloc]initWithObjects:self.UserName,xingbie,self.mobile, nil];
    [self setNavigation];
    // Do any additional setup after loading the view.
}
-(void)setNavigation
{
    self.NavTitle.text=@"个人资料";
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.width, self.view.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=Fbottomcolor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[personalTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark-----UITableView代理----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 180/2.34*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180/2.34*self.scale)];
        viewHeader.backgroundColor=[UIColor whiteColor];
    UIView *viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20/2.34*self.scale)];
    viewTop.backgroundColor=Fbottomcolor;
    [viewHeader addSubview:viewTop];
    [viewTop addSubview:[self getView:CGRectMake(0, viewTop.height-.5, self.view.width, .5)]];
    UIView *viewCenter=[[UIView alloc]initWithFrame:CGRectMake(0, viewTop.bottom, self.view.width, 140/2.34*self.scale)];
    viewCenter.backgroundColor=[UIColor whiteColor];
    [viewHeader addSubview:viewCenter];
    UILabel *labeltouxiang=[[UILabel alloc]initWithFrame:CGRectMake(30/2.34*self.scale, 0, (self.view.width-60/2.34*self.scale)/2, viewCenter.height)];
    labeltouxiang.text=@"我的头像";
    labeltouxiang.textColor=blackTextColor;
    labeltouxiang.font=DefaultFont(self.scale);
    [viewCenter addSubview:labeltouxiang];
    UIImageView *imageRight=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-65/2.34*self.scale, (viewCenter.height-48/2.34*self.scale)/2, 48/2.34*self.scale, 48/2.34*self.scale)];
   
    imageRight.image=[UIImage imageNamed:@"arrow_rightkk"];
    [viewCenter addSubview:imageRight];
    viewCenter.userInteractionEnabled=YES;
    UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage)];
    [viewCenter addGestureRecognizer:Tap];
    
    UIImageView *imagetouxiang=[[UIImageView alloc]initWithFrame:CGRectMake(imageRight.left-110/2.34*self.scale,(viewCenter.height-100/2.34*self.scale)/2, 100/2.34*self.scale, 100/2.34*self.scale)];
     [imagetouxiang setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrl]] placeholderImage:[UIImage imageNamed:@"icon_lvxiao"]];
    imagetouxiang.layer.cornerRadius=imagetouxiang.width/2;
    imagetouxiang.layer.masksToBounds=YES;
    imagetouxiang.tag=200;
    [viewCenter addSubview:imagetouxiang];
    UIView *viewBottom=[[UIView alloc]initWithFrame:CGRectMake(0, viewCenter.bottom, self.view.width, 20/2.34*self.scale)];
    viewBottom.backgroundColor=Fbottomcolor;
    [viewHeader addSubview:viewBottom];
    [viewBottom addSubview:[self getView:CGRectMake(0, 0, self.view.width, .5)]];
    [viewBottom addSubview:[self getView:CGRectMake(0, viewBottom.height-.5, self.view.width, .5)]];
    viewHeader.height=viewBottom.bottom;
        return viewHeader;
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
    return [_Marry count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90/2.34*self.scale;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    personalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.labelRight.text=_Marry[indexPath.row];
    cell.labelRightData.text=self.MarryRight[indexPath.row];
    if(indexPath.row==self.Marry.count-1)
    {
        cell.viewxian.hidden=YES;
        [cell addSubview:[self getView:CGRectMake(0, 90/2.34*self.scale-.5, self.view.width, .5)]];
        cell.imageRight.hidden=YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        shezhiNicknameViewController *nicehng=[shezhiNicknameViewController new];
        nicehng.nicheng=self.UserName;
        nicehng.block=^(NSString *text)
        {
            [_MarryRight setObject:text atIndexedSubscript:0];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:nicehng animated:YES];
    }
    if(indexPath.row==1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
        analyticClass *analy=[analyticClass new];
        UIAlertController *control=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [control addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startProgress];
        [analy xiugaigerenziliao:ID getnickName:@"" getrealName:@"" getsex:@"1" getaddress:@"" Block:^(id models, NSString *code, NSString *msg) {
            [self stopProgress];
            if([code isEqualToString:@"1"])
            {
                [_MarryRight setObject:@"男" atIndexedSubscript:1];
                [_tableView reloadData];
            }
            else
            {
                [self showMessage:msg getself:self];
            }
        }];
        }]];
        [control addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startProgress];
            [analy xiugaigerenziliao:ID getnickName:@"" getrealName:@"" getsex:@"2" getaddress:@"" Block:^(id models, NSString *code, NSString *msg) {
                [self stopProgress];
                if([code isEqualToString:@"1"])
                {
                    [_MarryRight setObject:@"女" atIndexedSubscript:1];
                    [_tableView reloadData];
                }
                else
                {
                    [self showMessage:msg getself:self];
                }
            }];

            
        }]];
        [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        
        [self presentViewController:control animated:YES completion:nil];
    }
}

#pragma mark---EVENT---
-(void)changeImage
{
    UIAlertController *control=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [control addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        
    }]];
    [control addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }]];
    [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    [self presentViewController:control animated:YES completion:nil];

}
#pragma mark---设置图片的宽高返回新的图片---
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    //赋值
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:200];
    imageView.image=newImg;
    //将图片转化为数据类型参数(图片,压缩比例)
    NSData *imgData=UIImageJPEGRepresentation(newImg, 0.5);
    NSString *base64img=[imgData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength];
    [self UpDateLogo:base64img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)UpDateLogo:(NSString *)logo
{
    NSString *newlogo=[logo trimString];
    [self startProgress];
    //上传资料
    analyticClass *analytic=[[analyticClass alloc]init];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"]];
[analytic xiugaitouxiang:ID getbase64Img:newlogo Block:^(id models, NSString *code, NSString *msg) {
    [self stopProgress];
    if([code isEqualToString:@"1"])
    {
        [self showMessage:@"上传成功" getself:self];
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
