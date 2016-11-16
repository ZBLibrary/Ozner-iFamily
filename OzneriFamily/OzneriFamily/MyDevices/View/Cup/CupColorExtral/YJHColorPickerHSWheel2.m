//
//  YJHColorPickerHSWheel2.m
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/11/2.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  方法二：使用拖拽手势和敲击手势来做移动获取颜色

#import "YJHColorPickerHSWheel2.h"
#import "UIImage+ColorAtPixel.h"
#import "HSVZB.h"
#import "UIColor+Convert.h"

@interface YJHColorPickerHSWheel2()

@property (nonatomic, weak) UIImageView *wheelImageView;

@property (nonatomic, weak) UIImageView *wheelKnobView;

@property (nonatomic, assign) HSVType currentHSV;

// 旧的颜色十六进制
@property (nonatomic, copy) NSString *oldColorHex;

// 当前选中的颜色十六进制
@property (nonatomic, copy) NSString *currentColorHex;

@end

@implementation YJHColorPickerHSWheel2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 初始化取色板图片
        UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerColorWheel.png"]];
        //UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color.png"]];
        wheel.contentMode = UIViewContentModeTopLeft;
        wheel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:wheel];
        self.wheelImageView = wheel;
        
        UIImageView *wheelKnob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
        wheelKnob.contentMode = UIViewContentModeCenter;
        wheelKnob.backgroundColor= [UIColor redColor];
        wheelKnob.frame = CGRectMake(frame.size.width/2, 0, 53, 53);
        wheelKnob.layer.cornerRadius = 26.5;
        wheelKnob.layer.masksToBounds = YES;
        [self addSubview:wheelKnob];
        self.wheelKnobView = wheelKnob;
        
        self.currentHSV = HSVTypeMake(0, 0, 1);
        
        // 拖拽手势
        UIPanGestureRecognizer *panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.wheelImageView addGestureRecognizer:panGestureRecognizer];
        
        // 敲击手势
        UITapGestureRecognizer *tapGestureRecognizer;
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.wheelImageView addGestureRecognizer:tapGestureRecognizer];
        self.wheelImageView.userInteractionEnabled = YES;
        
    }
    
    return self;
}

/**
 *  根据移动的点计算currentHSV
 *
 *  @param point 移动到的点
 */
- (void) p_mapPointToColor:(CGPoint) point {
    CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
                                 self.wheelImageView.bounds.size.height * 0.5);
    double radius = self.wheelImageView.bounds.size.width * 0.5;
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
    if (isnan(angle))
        angle = 0.0;
    
    double dist = 112;//sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist/radius, 1.0);
    
    if (dist < 10)
        saturation = 0; // snap to center
    
    if (point.x < center.x)
        angle = M_PI - angle;
    
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
    
    // 设置currentHSV的值
    NSLog(@"%f",angle / (2.0 * M_PI));
    NSLog(@"%f",saturation);
    self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);

}

/**
 *  根据hsv移动色块
 *
 */
- (void) setCurrentHSV:(HSVType)hsv {
    _currentHSV = hsv;
    _currentHSV.v = 1.0;
    //NSLog(@"h:%f,s:%f",_currentHSV.h,_currentHSV.s);
    double angle = _currentHSV.h * 2.0 * M_PI;
    CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
                                 self.wheelImageView.bounds.size.height * 0.5);
    double radius = self.wheelImageView.bounds.size.width * 0.5 -17;//- 3.0f;
    radius *= _currentHSV.s;
    NSLog(@"_currentHSV.s:%f",_currentHSV.s);
    CGFloat x = center.x + cosf(angle) * radius;
    CGFloat y = center.y - sinf(angle) * radius;
    
    //x = x - self.wheelKnobView.bounds.size.width * 0.5 + self.wheelKnobView.bounds.size.width * 0.5;
    //y = y - self.wheelKnobView.bounds.size.height * 0.5 + self.wheelKnobView.bounds.size.height * 0.5;
    float tmpcenter_x=x + self.wheelImageView.frame.origin.x;
    float tmpcenter_y=y + self.wheelImageView.frame.origin.y;
    //x*x+y*y
    self.wheelKnobView.center = CGPointMake(tmpcenter_x,tmpcenter_y);
    
    
}


/**
 *  拖动手势
 *
 */
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self.wheelImageView];
        CGFloat tmpnumber=(tapPoint.x-112)*(tapPoint.x-112)+(tapPoint.y-112)*(tapPoint.y-112);
        if (tmpnumber<80*80||tmpnumber>111*111) {
            return;
        }
        NSLog(@"x:%f,y:%f",tapPoint.x,tapPoint.y);
        [self p_mapPointToColor:tapPoint];
        
        RGBType rgba = [self.wheelImageView.image colorAtPixel2:tapPoint];
        NSInteger hex = RGB_to_HEX(rgba.r, rgba.g, rgba.b);
        self.oldColorHex = [NSString stringWithFormat:@"0x%06lx", (long)hex];
        
        // 当颜色不一样时才回调
        if (![self.oldColorHex isEqualToString:self.currentColorHex]) {
            self.confirmBlock([UIColor colorWithHexString:_oldColorHex alpha:1.f]);
            self.currentColorHex = self.oldColorHex;
            self.wheelKnobView.backgroundColor = [UIColor colorWithHexString:_oldColorHex alpha:1.f];
        }
        
        
        
    }
}


/**
 *  轻触手势
 *
 */
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self.wheelImageView];
        CGFloat tmpnumber=(tapPoint.x-112)*(tapPoint.x-112)+(tapPoint.y-112)*(tapPoint.y-112);
        if (tmpnumber<80*80||tmpnumber>111*111) {
            return;
        }
        //NSLog(@"x:%f,y:%f",tapPoint.x,tapPoint.y);
        [self p_mapPointToColor:tapPoint];
        
        RGBType rgba = [self.wheelImageView.image colorAtPixel2:tapPoint];
        NSInteger hex = RGB_to_HEX(rgba.r, rgba.g, rgba.b);
        self.oldColorHex = [NSString stringWithFormat:@"0x%06lx", (long)hex];
        
        // 当颜色不一样时才回调
        if (![self.oldColorHex isEqualToString:self.currentColorHex]) {
            self.confirmBlock([UIColor colorWithHexString:_oldColorHex alpha:1.f]);
            self.currentColorHex = self.oldColorHex;
            self.wheelKnobView.backgroundColor = [UIColor colorWithHexString:_oldColorHex alpha:1.f];
            
        }
    }
}
//拖动17半径，拖到的边圆？，大圆112，中间32

@end
