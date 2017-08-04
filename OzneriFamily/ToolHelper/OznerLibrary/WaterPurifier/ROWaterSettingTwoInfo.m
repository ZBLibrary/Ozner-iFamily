//
//  ROWaterSettingTwoInfo.m
//  OznerLibraryDemo
//
//  Created by ZGY on 2017/6/21.
//  Copyright © 2017年 Ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/6/21  下午8:53
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

#import "ROWaterSettingTwoInfo.h"

@implementation ROWaterSettingTwoInfo


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self rest];
        
    }
    return self;
}

- (void)rest{
    _hottempSet = 0;
    _isPower = 0;
    _openPowerTime = 0;
    _closePowerTime = 0;
    _isHot = false;
    _startHotTime = 0;
    _endHotTime = 0;
    _isCold = false;
}

- (void)load:(NSData*)data
{
   
    Byte* bytes=(Byte*)[data bytes];
    _hottempSet = bytes[1];
    _isPower = bytes[2];
    _openPowerTime = bytes[3];
    _closePowerTime = bytes[4];
    _isHot = bytes[5];
    _startHotTime = bytes[6];
    _endHotTime = bytes[7];
    _isCold = bytes[8];
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"加热温度设置:%d 自动开关机:%d 开机时间:%d ",_hottempSet,_isPower,_openPowerTime];
}

@end
