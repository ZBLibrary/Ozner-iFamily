//
//  WaterPurifierSensor.m
//  MxChip
//
//  Created by Zhiyongxu on 15/12/9.
//  Copyright © 2015年 Zhiyongxu. All rights reserved.
//

#import "WaterPurifierSensor.h"

@implementation WaterPurifierSensor
-(instancetype)init
{
    if (self=[super init])
    {
        _TDS1=WATER_PURIFIER_SENSOR_ERROR;
        _TDS2=WATER_PURIFIER_SENSOR_ERROR;
        _filterRemindDays=WATER_PURIFIER_SENSOR_ERROR;
    }
    return self;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"TDS1:%d TDS2:%d filterRemindDays:%d",_TDS1,_TDS2,_filterRemindDays];
}
-(void)load:(BytePtr)bytes
{
    _TDS1 = *((short*)(bytes+16));
    _TDS2 = *((short*)(bytes+18));
    _filterRemindDays = *((int*)(bytes+20))/(3600*24);
}
@end
