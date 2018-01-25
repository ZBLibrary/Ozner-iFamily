//
//  Colors.swift
//  ATAnimatons
//
//  Created by ZGY on 2018/1/17.
//Copyright © 2018年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2018/1/17  上午9:52
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class Colors: NSObject {
    
//    class func cacluateColor(_ valPer:CGFloat, firstColor:UInt8,secondColor:UInt8,otherColor:[UInt8]?) {
//        var colorNum = 2
//
//        if otherColor != nil && otherColor!.count > 0 {
//
//            colorNum = otherColor!.count + colorNum
//
//        }
//
//        let sectionNum = colorNum - 1 //颜色区间个数
//        let perStep = 100.0 / CGFloat(sectionNum) //均分区间
//        let perInSection = Int(valPer/perStep) //区间百分比
//
//    }
    
    class func getMuatbleColors()-> [UIColor]{
        var red = 255.0
        var green = 0.0
        var blue = 0.0
        let colorNum = 20.0
        var colors:[UIColor] = []
        while green < 256 {
            let color = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
            colors.append(color)
            green = colorNum + green
        }
        
        while red > 0 {
            red = red - colorNum
            let color = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
            colors.append(color)
        }
        
        while green > 0 {
            green = green - colorNum
            blue = blue + colorNum
            let color = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
            colors.append(color)
        }
        
        while red < 256 {
            red = red + colorNum
            let color = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
            colors.append(color)
        }
        
        return colors
        
    }

}
