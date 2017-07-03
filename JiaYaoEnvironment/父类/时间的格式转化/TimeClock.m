//
//  TimeClock.m

//  LunTai
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "TimeClock.h"
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}
@interface TimeClock()
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSDate *nowDateTime;
@end
@implementation TimeClock
single_implementation(TimeClock);

-(void)SetTimeClockStartTimeByTimeFormat:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: TimeFormat];
    _nowDateTime= [dateFormatter dateFromString:time];
    if (!_nowDateTime) {
        _nowDateTime = [NSDate date];
    }
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerLoop) userInfo:nil repeats:YES];
    }
}

-(void)SetTimeClockStartTimeByTimeStamp:(NSString *)time{
    NSTimeInterval timeinter=[time doubleValue];
    _nowDateTime =[NSDate dateWithTimeIntervalSince1970:timeinter];
    if (!_nowDateTime) {
        _nowDateTime = [NSDate date];
    }
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerLoop) userInfo:nil repeats:YES];
    }
}
-(void)TimerLoop{
    _nowDateTime = [NSDate dateWithTimeInterval:1 sinceDate:_nowDateTime];
    NSLog(@" System------ %@",[self StringTimeStampFromDate:_nowDateTime]);
}
#pragma mark - 格式化时间
-(NSString *)StringFormatFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: TimeFormat];
    return [dateFormatter stringFromDate:date];
}
-(NSString *)GetTimeFormatFromTimeClock{
    return [self StringFormatFromDate:_nowDateTime];
}
#pragma mark - 时间戳
-(NSString *)StringTimeStampFromDate:(NSDate *)date{
   return  [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}
-(NSString *)GetTimeStampFromTimeClock{
    return [self StringTimeStampFromDate:_nowDateTime];
}
@end
