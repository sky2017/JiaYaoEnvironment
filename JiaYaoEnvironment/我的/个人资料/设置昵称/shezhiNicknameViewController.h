//
//  shezhiNicknameViewController.h
//  JiaYaoEnvironment
//
//  Created by apple on 17/3/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "superclassViewController.h"
@interface shezhiNicknameViewController : superclassViewController
//声明block    无返回值,传递参数是字符串
@property (nonatomic,copy)void (^block)(NSString *);
@property (nonatomic,copy)NSString *nicheng;
@end
