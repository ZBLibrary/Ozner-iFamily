//
//  GYCirclePoint.swift
//  CirClePoint
//
//  Created by ZGY on 2017/8/31.
//  Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/8/31  上午11:25
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYCirclePoint: UIView {
    
    var image:UIImage!
    var currenTemp:Float = -1
    var tmepLb:UILabel!
    var stateLb:UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        image = UIImage(named: "circle_point1")
        
        initUI()
        
    }
    
    private func initUI() {
        
        let lb1 = UILabel(frame: CGRect(x: 0, y: 40, width: 100, height: 20))
        lb1.center.x = self.frame.width/2
        lb1.text = "水温"
        lb1.textAlignment = .center
        lb1.textColor = UIColor.white
        self.addSubview(lb1)
                
        tmepLb = UILabel(frame: CGRect(x: 0, y:lb1.frame.maxY + 5, width: 200, height: 70))
        tmepLb.center.x = self.frame.width/2 + 10
        tmepLb.text = "暂无"
        tmepLb.textAlignment = .center
        //".SF UI Display"
        tmepLb.font = UIFont.init(name: ".SFUIDisplay-Thin", size: 50)

        self.addSubview(tmepLb)
        
        stateLb = UILabel(frame: CGRect(x: 0, y:tmepLb.frame.maxY + 5, width: 200, height: 30))
        stateLb.text = "--"
        stateLb.font = UIFont.systemFont(ofSize: 20)
        stateLb.center.x = self.frame.width/2
        stateLb.textAlignment = .center
        stateLb.textColor = UIColor.white
        self.addSubview(stateLb)
        
        tempLoad()

    }
    
    
    fileprivate func tempLoad() {
        
        switch currenTemp {

        case 0...25:
            tmepLb.textColor = UIColor.init(hexString: "3A71DD")
            stateLb.text = "偏凉"
            break
        case 26...50:
            tmepLb.textColor = UIColor.yellow
            stateLb.text = "适中"
            break
        case 50...100:
            tmepLb.textColor = UIColor.red
            stateLb.text = "偏烫"
            break
        default:
            break
        }
        
        tmepLb.text = String.init(format: "%0.f", currenTemp) + "°"
        if Int(currenTemp) == -1 {
            tmepLb.textColor = UIColor.init(hexString: "3A71DD")
            tmepLb.text = "暂无"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image = UIImage(named: "circle_point1")
        initUI()
        
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let maxWidth = self.frame.width < self.frame.height ? self.frame.width : self.frame.height
        
        let maxX = self.frame.width > self.frame.height ? self.frame.width : self.frame.height
        
        let center = CGPoint(x: maxX/2, y: maxWidth/2 + 5)
        var radious = maxWidth/2.0 - 5 - 2
        
        if currenTemp > 50 {
            radious = maxWidth/2.0 - 5 - 1
        }
        
        let starAnagel = -Double.pi
        let endAnagel = 0
        let strokenWidth:CGFloat = 10
        
        let basePath = UIBezierPath(arcCenter: center, radius: radious, startAngle: CGFloat(starAnagel), endAngle: CGFloat(endAnagel), clockwise: true)
        
//        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//        pathAnimation.path = basePath.cgPath
//        pathAnimation.duration = 4
//        self.layer.add(pathAnimation, forKey: "PathAnimation")
        ctx?.setLineWidth(strokenWidth)
        //设置线条顶端
        ctx?.setLineCap(CGLineCap.round)
        ctx?.setStrokeColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        ctx?.addPath(basePath.cgPath)
        ctx?.strokePath()//渲染背景色
        
        var x:Float = 0
        var y:Float = 0
        
        if Int(currenTemp) != -1{
         
        // 0.11 * currenTemp
        x = Float(center.x) - Float(maxWidth/2) * sinf(Float(raidanstoDegress(90 + Double(currenTemp * 1.8)))) -  0.14 * currenTemp     // - 13 * 50/100
        y = Float(center.y) + Float(maxWidth/2) * cosf(Float(raidanstoDegress(90 + Double(currenTemp * 1.8))))
        
        ctx?.draw(image.cgImage!, in: CGRect(x: Double(x), y: Double(y), width: 17.0, height: 17.0))
        
        }
   
    }
    
    func currentTemp(_ temp:Int) {
        
        currenTemp = Float(temp)
        tempLoad()
        self.setNeedsDisplay()
    }
    
    private func raidanstoDegress(_ x:Double) -> Double{
        
        return Double.pi * x / 180
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        image = UIImage(named: "circle_point1")

    }

}
