//
//  ROWaterSettingTwoInfo.h
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

#import <Foundation/Foundation.h>

@interface ROWaterSettingTwoInfo : NSObject

//加热温度设置
@property (readonly) int hottempSet;


/**
 是否自动开关机
 */
@property (readonly) BOOL isPower;

@property (readonly) int openPowerTime;

@property (readonly) int closePowerTime;

@property (readonly) BOOL isHot;

@property (readonly) int startHotTime;

@property (readonly) int endHotTime;

@property (readonly) BOOL isCold;

- (void)rest;

- (void)load:(NSData*)data;

@end
