//
//  ScrollViewController.h
//  XiaoYuanJianZhi
//
//  Created by mac on 16/2/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "superclassViewController.h"
#import "MRZoomScrollView.h"

//代理
@protocol MRZoomScrollViewDelegate<NSObject>
@optional
-(void)deleItem:(NSInteger)deleteImageNum;
@end
@interface ScrollViewController : superclassViewController
<UIScrollViewDelegate>
 
typedef void(^ScrollVBlock)(NSString *str);


@property (nonatomic,assign)int index;

@property (nonatomic,strong)NSArray *imgArr;
//作为一个变量,传不同的值可以给图片赋予不同类型的数据.
@property (nonatomic,copy)NSString *Login;
@property (nonatomic, retain) UIScrollView      *scrollView;

@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;
@property(nonatomic,weak)id<MRZoomScrollViewDelegate>delegate;
- (void)newScrollV;
- (void)getScrollVBlock:(ScrollVBlock)block;
//声明block    无返回值,传递参数是字符串
@property (nonatomic,copy)void (^blockNum)(NSString *);
@end
