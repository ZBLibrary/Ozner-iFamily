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

    @IBOutlet weak var tdsView: CupHeadCircleView!
    @IBOutlet weak var segement: UISegmentedControl!
    
    @IBOutlet weak var tempView: GYCirclePoint!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        tdsView.isHidden = true
        tempView.isHidden = false
        segement.addTarget(self, action:  #selector(TwoCupMainView.segmentedChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    func segmentedChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            UIView.transition(with: tempView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.tdsView.isHidden = true
                self.tempView.isHidden = false
                
            }, completion: { (finished) in
                
            })
            
            break
        case 1:
            UIView.transition(with: tdsView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.tempView.isHidden = true
                self.tdsView.isHidden = false
            }, completion: { (finished) in
                
            })
            
            break
        default:
            break
        }
        
    }

    
    
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

}
