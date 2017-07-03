//
//  analyticClass.h
//  名医在身边
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//一下两种状态可固定可随机,主要用于加密使用.
#define App_Key @"app554704abf5b337a7"
#define App_Secret @"67762ef490795a9c6016a2372b326349"
//设置一个block块,减少后面modeles,code,msg的代码书写
typedef void(^AnalyzeObjectBlock)(id models,NSString *code,NSString *msg);
@interface analyticClass : NSObject
//服务器时间(无参)
-(void)school_baike_dateWithBlock:(AnalyzeObjectBlock)block;
//意见反馈(有参)
-(void)school_user_jianyiWithUid:(NSString *)uid content:(NSString *)content time:(NSString *)time appkey:(NSString *)appkey appSecret:(NSString *)appSecret Block:(AnalyzeObjectBlock)block;
#pragma mark---基础配置---
-(void)jichupeizhiBlock:(AnalyzeObjectBlock)block;
#pragma mark---焦点图片---
-(void)lunbotu:(NSString *)mark Block:(AnalyzeObjectBlock)block;
#pragma mark---首页公告---
-(void)shouyegonggaoBlock:(AnalyzeObjectBlock)block;
#pragma mark---更多广告---
-(void)gengduoguanggaopageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---公告详情---
-(void)gonggaodetail:(NSString *)noticeId Block:(AnalyzeObjectBlock)block;
#pragma mark---产品分类---
-(void)chanpinfenleiBlock:(AnalyzeObjectBlock)block;
#pragma mark---产品品牌---
-(void)chanpinpinpaiBlock:(AnalyzeObjectBlock)block;
#pragma mark---推荐商品---
-(void)tuijianshangpinuserId:(NSString *)userId Block:(AnalyzeObjectBlock)block;
#pragma mark---商品列表---
-(void)shangpinliebiao:(NSString *)categoryId getkeywords:(NSString *)keywords getprice:(NSString *)price getsale:(NSString *)sale getbrandId:(NSString *)brandId getuserId:(NSString *)userId getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---商品详情---
-(void)shangpinDetail:(NSString *)userId getproductId:(NSString *)productId Block:(AnalyzeObjectBlock)block;
#pragma mark---推荐商品---
-(void)tuijianshangpin:(NSString *)userId Block:(AnalyzeObjectBlock)block;
#pragma mark---推荐评估---
-(void)tuijianpingguBlock:(AnalyzeObjectBlock)block;
#pragma mark---环境/评估列表---
-(void)huanjingpinggu:(NSString *)mark getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---知晓环境搜索---
-(void)zhixiaohuanjingsearch:(NSString *)keywords getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---环境评估详情--
-(void)huanjingpingguxiangqing:(NSString *)ID Block:(AnalyzeObjectBlock)block;

//个人中心
#pragma mark---获取验证码--
-(void)huoquyanzhengma:(NSString *)mobile getmark:(NSString *)mark Block:(AnalyzeObjectBlock)block;
#pragma mark---用户注册--
-(void)yonghuzhuce:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block;
#pragma mark---用户登录--
-(void)yonghudenglu:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block;
#pragma mark---找回密码--
-(void)zhaohuimima:(NSString *)mobile getpwd:(NSString *)pwd Block:(AnalyzeObjectBlock)block;
#pragma mark---用户信息--
-(void)yonghuxinxi:(NSString *)userId Block:(AnalyzeObjectBlock)block;
#pragma mark---修改密码--
-(void)xiugaimima:(NSString *)userId getoldpwd:(NSString *)oldpwd getpwd:(NSString *)pwd getqrwd:(NSString *)qrwd Block:(AnalyzeObjectBlock)block;
#pragma mark---意见反馈--
-(void)yijianfankui:(NSString *)userId getremark:(NSString *)remark getsource:(NSString *)source getbase64Img:(NSString *)base64Img Block:(AnalyzeObjectBlock)block;
#pragma mark---常见问题--
-(void)changjianwentiBlock:(AnalyzeObjectBlock)block;
#pragma mark---常见问题详情--
-(void)changjianwentidetail:(NSString *)ID Block:(AnalyzeObjectBlock)block;
#pragma mark---修改个人资料--
-(void)xiugaigerenziliao:(NSString *)userId getnickName:(NSString *)nickName getrealName:(NSString *)realName getsex:(NSString *)sex getaddress:(NSString *)address Block:(AnalyzeObjectBlock)block;
#pragma mark---修改头像--
-(void)xiugaitouxiang:(NSString *)userId getbase64Img:(NSString *)base64Img Block:(AnalyzeObjectBlock)block;
#pragma mark---添加取消收藏--
-(void)tianjiaquxiaoshoucang:(NSString *)userId getouterId:(NSString *)outerId getmark:(NSString *)mark getaction:(NSString *)action Block:(AnalyzeObjectBlock)block;
#pragma mark---我的收藏--
-(void)wodeshoucang:(NSString *)userId getmark:(NSString *)mark getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---我的检测--
-(void)wodejiance:(NSString *)userId getpageindex:(NSString *)pageindex Block:(AnalyzeObjectBlock)block;
#pragma mark---我的检测详情--
-(void)wodejiandetail:(NSString *)ID Block:(AnalyzeObjectBlock)block;
#pragma mark---清空收藏--
-(void)qingkongshoucang:(NSString *)userId getmark:(NSString *)mark Block:(AnalyzeObjectBlock)block;
@end
