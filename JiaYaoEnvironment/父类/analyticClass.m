//
//  analyticClass.m
//  名医在身边
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "analyticClass.h"
#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "TimeClock.h"
//DES加密与解密
#import "NSString+Encrypt.h"
//MD5加密使用
#import <CommonCrypto/CommonDigest.h>
typedef void(^AnalyzeObjectBlock)(id models,NSString *code,NSString *msg);
@implementation analyticClass
-(id)init{
    self = [super init];
    return self;
}
//service不同的接口所对应的端口name不同
-(void)LinkServceWithData:(NSDictionary *)dic getservices:(NSString *)service Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    
     NSString *services=[NSString stringWithFormat:@"%@",service];
    [[AFAppDotNetAPIClient sharedClient]POST:services parameters:dic progress:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
       NSLog(@"%@",responseObject);
        NSString *code =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msgcode"]];
        NSString *msg =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        if ([code isEqualToString:@"1"]) {
            block([responseObject objectForKey:@"data"],code,msg);
        }else{
            block(nil,code,msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,@"0",@"请保持网络畅通");
    }];
}
#pragma mark---焦点图片---
-(void)lunbotu:(NSString *)mark Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mark,@"mark", nil];
    [self LinkServceWithData:dic getservices:@"/api/Other/GetBanner" Block:block];
}
#pragma mark---基础配置---
-(void)jichupeizhiBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"/api/Other/GetBase" Block:block];
}
#pragma mark---首页公告---
-(void)shouyegonggaoBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"/api/User/GetTopNotice" Block:block];
}

#pragma mark---更多广告---
-(void)gengduoguanggaopageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:pageindex,@"pageindex", nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetMoreNotice" Block:block];
}
#pragma mark---公告详情---
-(void)gonggaodetail:(NSString *)noticeId Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:noticeId,@"noticeId", nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetNoticeDetail" Block:block];
}
#pragma mark---产品分类---
-(void)chanpinfenleiBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"/api/Product/GetProductTypeList" Block:block];
}
#pragma mark---产品品牌---
-(void)chanpinpinpaiBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"/api/Product/GetProductBrand" Block:block];
}
#pragma mark---推荐商品---
-(void)tuijianshangpinuserId:(NSString *)userId Block:(AnalyzeObjectBlock)block
{
       NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    [self LinkServceWithData:dic getservices:@"/api/Product/GetCommentProduct" Block:block];
}
#pragma mark---商品列表---
-(void)shangpinliebiao:(NSString *)categoryId getkeywords:(NSString *)keywords getprice:(NSString *)price getsale:(NSString *)sale getbrandId:(NSString *)brandId getuserId:(NSString *)userId getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:categoryId,@"categoryId",keywords,@"keywords",price,@"price",sale,@"sale",brandId,@"brandId",userId,@"userId",pageindex,@"pageindex", nil];
    [self LinkServceWithData:dic getservices:@"/api/Product/GetProductList" Block:block];
}
#pragma mark---商品详情---
-(void)shangpinDetail:(NSString *)userId getproductId:(NSString *)productId Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",productId,@"productId", nil];
    [self LinkServceWithData:dic getservices:@"/api/Product/GetProductDetail" Block:block];
}
#pragma mark---推荐商品---
-(void)tuijianshangpin:(NSString *)userId Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nil];
    [self LinkServceWithData:dic getservices:@"/api/Product/GetCommentProduct" Block:block];
}
#pragma mark---推荐评估---
-(void)tuijianpingguBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic = nil;
    [self LinkServceWithData:dic getservices:@"/api/News/GetCommendProject" Block:block];
}
#pragma mark---环境/评估列表---
-(void)huanjingpinggu:(NSString *)mark getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mark,@"mark",pageindex,@"pageindex",nil];
    [self LinkServceWithData:dic getservices:@"/api/News/GetSeviceList" Block:block];
}
#pragma mark---知晓环境搜索---
-(void)zhixiaohuanjingsearch:(NSString *)keywords getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords",pageindex,@"pageindex",nil];
    [self LinkServceWithData:dic getservices:@"/api/News/GetSearchNews" Block:block];
}
#pragma mark---环境评估详情--
-(void)huanjingpingguxiangqing:(NSString *)ID Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",nil];
    [self LinkServceWithData:dic getservices:@"/api/News/GetArticleDetail" Block:block];
}
//个人中心
#pragma makr---获取验证码--
-(void)huoquyanzhengma:(NSString *)mobile getmark:(NSString *)mark Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",mark,@"mark",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetPhoneCode" Block:block];
}
#pragma makr---用户注册--
-(void)yonghuzhuce:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",pwd,@"pwd",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/RegUser" Block:block];
}
#pragma makr---用户登录--
-(void)yonghudenglu:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",pwd,@"pwd",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/UserLogin" Block:block];
}
#pragma makr---找回密码--
-(void)zhaohuimima:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",pwd,@"pwd",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetPassWord" Block:block];
}
#pragma makr---用户信息--
-(void)yonghuxinxi:(NSString *)userId Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetUser" Block:block];
}
#pragma makr---修改密码--
-(void)xiugaimima:(NSString *)userId getoldpwd:(NSString *)oldpwd getpwd:(NSString *)pwd getqrwd:(NSString *)qrwd Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",oldpwd,@"oldpwd",pwd,@"pwd",qrwd,@"qrwd",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/UpdatePassword" Block:block];
}
#pragma makr---意见反馈--
-(void)yijianfankui:(NSString *)userId getremark:(NSString *)remark getsource:(NSString *)source getbase64Img:(NSString *)base64Img Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",remark,@"remark",source,@"source",base64Img,@"base64Img",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/AddFeedBack" Block:block];

}
#pragma makr---常见问题--
-(void)changjianwentiBlock:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"/api/User/GetHelpList" Block:block];
}
#pragma makr---常见问题详情--
-(void)changjianwentidetail:(NSString *)ID Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetHelpDetail" Block:block];
}
#pragma makr---修改个人资料--
-(void)xiugaigerenziliao:(NSString *)userId getnickName:(NSString *)nickName getrealName:(NSString *)realName getsex:(NSString *)sex getaddress:(NSString *)address Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nickName,@"nickName",realName,@"realName",sex,@"sex",address,@"address",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/UpdateUser" Block:block];
}
#pragma makr---修改头像--
-(void)xiugaitouxiang:(NSString *)userId getbase64Img:(NSString *)base64Img Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",base64Img,@"base64Img",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/UploadHead" Block:block];
}
#pragma makr---添加取消收藏--
-(void)tianjiaquxiaoshoucang:(NSString *)userId getouterId:(NSString *)outerId getmark:(NSString *)mark getaction:(NSString *)action Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",outerId,@"outerId",mark,@"mark",action,@"action",nil];
    [self LinkServceWithData:dic getservices:@"/api/Collect/EditCollect" Block:block];
}
#pragma makr---我的收藏--
-(void)wodeshoucang:(NSString *)userId getmark:(NSString *)mark getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",mark,@"mark",pageindex,@"pageindex",nil];
    [self LinkServceWithData:dic getservices:@"/api/Collect/GetCollectList" Block:block];
}
#pragma makr---我的检测--
-(void)wodejiance:(NSString *)userId getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",pageindex,@"pageindex",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetMyDetection" Block:block];
}
#pragma makr---我的检测详情--
-(void)wodejiandetail:(NSString *)ID Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",nil];
    [self LinkServceWithData:dic getservices:@"/api/User/GetMyDetectionDetail" Block:block];
}
#pragma mark---清空收藏--
-(void)qingkongshoucang:(NSString *)userId getmark:(NSString *)mark Block:(AnalyzeObjectBlock)block
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",mark,@"mark",nil];
    [self LinkServceWithData:dic getservices:@"/api/Collect/ClearCollect" Block:block];
}
//无参
-(void)school_baike_dateWithBlock:(AnalyzeObjectBlock)block{
    NSDictionary *dic =nil;
    [self LinkServceWithData:dic getservices:@"" Block:block];
}
//有参
-(void)school_user_jianyiWithUid:(NSString *)uid content:(NSString *)content time:(NSString *)time appkey:(NSString *)appkey appSecret:(NSString *)appSecret Block:(AnalyzeObjectBlock)block{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",content,@"content",time,@"time",appkey,@"appkey",appSecret,@"appSecret", nil];
    [self LinkServceWithData:dic getservices:@"" Block:block];
}
@end
