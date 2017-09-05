//
//  TwoCupMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/9/4.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/9/4  下午2:58
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class TwoCupMainView: OznerDeviceView {

    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var secondRemindLb: UILabel!
    @IBOutlet weak var timeRemindLb: UILabel!
    @IBOutlet weak var batteryLb: UILabel!
    @IBOutlet weak var batteryImage: UIImageView!

    
//    override func draw(_ rect: CGRect) {
//        
//        super.draw(rect)
//        
//        
//        /// 获取当前View在屏幕上的坐标点
//        let lb1Frame = lb1.convert(lb1.bounds, to: appDelegate.window)
//        
//        
////        let lb1Frame = lb1.frame
////        print(lb1Frame)
////        print(lb2.frame)
//        
//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.setLineCap(CGLineCap.round)
//        
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: lb1Frame.minX - 6, y: lb1Frame.minY))
//        path.addLine(to: CGPoint(x: lb1Frame.minX - 6, y: lb1Frame.maxY))
//        path.closeSubpath() //关闭路径
//        
//        ctx?.setFillColor(UIColor.blue.cgColor)
//        ctx?.setLineWidth(4)
//        ctx?.addPath(path)
//        ctx?.strokePath()
//    
//        
//        
//    }
//    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
