//
//  HSVZB.h
//  ColorPickDemo
//
//  Created by test on 15/12/11.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSVZB : NSObject
#define UNDEFINED 0
typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;

// Theoretically, hue 0 (pure red) is identical to hue 6 in these transforms. Pure
// red always maps to 6 in this implementation. Therefore UNDEFINED can be
// defined as 0 in situations where only unsigned numbers are desired.
RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);

HSVType RGB_to_HSV( RGBType RGB );
RGBType HSV_to_RGB( HSVType HSV );

// RGB转成十六进制数，例如:0xfff6f9
int RGB_to_HEX(int r,int g,int b);
@end
