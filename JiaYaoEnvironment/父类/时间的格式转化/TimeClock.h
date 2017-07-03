//
//  TimeClock.h
//  LunTai
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 mac. All rights reserved.
//


#import <Foundation/Foundation.h>

#define single_interface(class)  + (class *)shared##class;


#define TimeFormat @"yyyy-MM-dd HH:mm:ss"
@interface TimeClock : NSObject
single_interface(TimeClock);
/**
 *yyyy-MM-dd HH:mm:ss
 *通过时间格式来设置时间
 */
-(void)SetTimeClockStartTimeByTimeFormat:(NSString *)time;
/**
 *
 *获取格式化的时间
 */
-(NSString *)GetTimeFormatFromTimeClock;
/**
 *1441008753
 *通过时间戳来设置时间
 */
-(void)SetTimeClockStartTimeByTimeStamp:(NSString *)time;
/**
 *
 *得到当前时钟的时间戳
 */
-(NSString *)GetTimeStampFromTimeClock;
@end
