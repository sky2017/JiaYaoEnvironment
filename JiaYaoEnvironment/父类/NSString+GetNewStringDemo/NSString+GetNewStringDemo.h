//
//  NSString+GetNewStringDemo.h
//  StringDemo
//
//  Created by wasd on 15/10/12.
//  Copyright (c) 2015年 zhiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (GetNewStringDemo)
//分割线获取数组
+(NSArray*)componentsSeparatedByString:(NSString *)SeparatedString components:(NSString *)SeparatedChar;
//截取字符串中索引对应的字符
+(char)characterAtIndex:(NSString*)characterText characterIndex:(NSInteger)Index;
//截取字符串(从某个索引开始和要截取字符串的数目)
+(NSString *)substringWithRange:(NSString *)substring beginIndex:(NSInteger)beginIndex num:(NSInteger)num;
//将字符串中的某个字符全部转化为指定的字符
+(NSString *)stringByReplacingOccurrencesOfString:(NSString *)ReplacingString willReplaceString:(NSString *)oldString withString:(NSString *)newString;
//将c语言的char类型转化NSString字符串
+(NSString *)stringWithUTF8:(char *)Cchar;
//去除字符串前后中的所有空格和回车.
+(NSString *)stringByTrimmingCharactersInSet:(NSString *)TrimmingString;
//在Documents等下创建文件(Library/Preferences Library/Caches tmp Documents)
+(NSString *)DirectionaryType:(NSString *)DirectoryName WithDocumentsPath:(NSString *)fileName;
//在Documents的文件夹下的文件夹下创建文件
+(NSString *)DirectionaryType:(NSString *)DirectoryName fileWithDirectionaryArry:(NSArray *)fileArry WithDocumentsPath:(NSString *)fileName;
//在Documents等的文件夹下创建文件夹
+(NSString *)DirectionaryType:(NSString *)DirectoryName fileWithDirectionaryArry:(NSArray *)fileArry;
//计算控件的宽和高.必须导入<UIKit/UIKit.h>,因为CGSize结构体在其内部封装的.
+(CGSize)getLabelText:(NSString *)text getLabelSize:(CGSize)Lablesize getTextFont:(UIFont *)Textsize;
//判断一个字符串是否是纯数字
- (BOOL)isPureInt:(NSString *)string;
//判断一个字符串是否是浮点型
- (BOOL)isPureFloat:(NSString *)string;
//将字符串转化为日期
//常见的日期结构
//yyyy-MM-dd HH:mm:ss.SSS
//yyyy-MM-dd HH:mm:ss
//yyyy-MM-dd
//MM dd yyyy
+(NSDate *)changeString:(NSString *)string changeStyle:(NSString *)style;
//将日期转化为字符串
+(NSString *)changeDate:(NSDate *)date changeStyle:(NSString *)style;
//设置一个label,控制其显示两种颜色.
+(NSMutableAttributedString *)needChangeText:(NSString *)string needColor:(UIColor *)FirstColor needRange:(NSRange)Fpoint neesColorS:(UIColor *)SecondColor neewRangeS:(NSRange)Spoint;
//获取中文的首字母
+(char)pinyinFirstLetter:(unsigned short)ChinaWord;
//获取当前设备的IP地址

@end
