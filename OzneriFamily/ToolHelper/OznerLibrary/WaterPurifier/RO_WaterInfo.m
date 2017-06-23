//
//  RO_WaterInfo.m
//  OznerLibraryDemo
//
//  Created by Zhiyongxu on 2016/10/25.
//  Copyright © 2016年 Ozner. All rights reserved.
//

#import "RO_WaterInfo.h"

@implementation RO_WaterInfo
-(instancetype)init
{
    if (self=[super init])
    {
        [self reset];
    }
    return self;
}
-(void)reset
{
    _TDS1=0;
    _TDS2=0;
    _TDS1_RAW=0;
    _TDS2_RAW=0;
    _TDS_Temperature=0;
    _waterml = 0;

}
-(void)load:(NSData*)data
{
    short* bytes=(short*)[data bytes];
    
//    *((UInt32*)(bytes+4))
    _TDS1=bytes[0];
    _TDS2=bytes[1];
    
    _TDS1_RAW=bytes[2];
    _TDS2_RAW=bytes[3];
    
    _TDS_Temperature=bytes[4];
    
//    Byte[] *bte1 = [data bytes];
    BytePtr bytes1=(BytePtr)[data bytes];
    
    int a = bytes1[10];
    int b = bytes1[11] * 256;
    int c = bytes1[12] * 256 * 256;
    int d = bytes1[13] * 256 * 256 * 256;
    _waterml = a + b + c + d;

//    Byte bytes[4];
//    memset(bytes, 0, 4);
//    bytes[0]=code;
//    memcpy(bytes+1, [data bytes], data.length);

    
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"TDS1:%d(%d) TDS2:%d(%d) 温度:%d 制水量:%d",
            _TDS1,_TDS1_RAW,
            _TDS2,_TDS2_RAW,
            _TDS_Temperature,_waterml];
}
@end
