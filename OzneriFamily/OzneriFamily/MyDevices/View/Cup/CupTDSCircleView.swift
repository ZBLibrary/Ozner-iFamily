//
//  drawCircleView.swift
//  OZner
//
//  Created by test on 16/1/20.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class CupTDSCircleView: UIView {

    
    let colordefault=UIColor.init(red: 235/255, green: 242/255, blue: 248/255, alpha: 1)
    let color1=UIColor.init(red: 241/255, green: 102/255, blue: 102/255, alpha: 1)
    let color2=UIColor.init(red: 128/255, green: 94/255, blue: 230/255, alpha: 1)
    let color21=UIColor.init(red: 242/255, green: 134/255, blue: 82/255, alpha: 1)
    let color3=UIColor.init(red: 70/255, green: 143/255, blue: 241/255, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
  
    func UpdateCircle(type:Int,state1:Int,state2:Int,state3:Int)
    {
        for i in 1...6
        {
            var lineColor:UIColor!
            var radius:CGFloat=0.0
            var endAngle:Double=0
            switch i
            {
            case 1:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-5
                break
            case 2:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-20
                break
            case 3:
                endAngle=M_PI
                lineColor=colordefault
                radius=frame.height/2-35
                break
            case 4:
                
                endAngle = 3*M_PI*Double(state1)/100/2-M_PI/2
                lineColor=color1
                radius=frame.height/2-5
                break
            case 5:
                endAngle = 3*M_PI*Double(state2)/100/2-M_PI/2
                lineColor=type==0 ? color2:color21
                radius=frame.height/2-20
                break
            case 6:
                endAngle = 3*M_PI*Double(state3)/100/2-M_PI/2
                lineColor=color3
                radius=frame.height/2-35
                break
            default:
                break
            }
            let beierpath=UIBezierPath.init()
            
            beierpath.addArc(withCenter: CGPoint(x: frame.height/2, y: frame.height/2), radius: radius, startAngle: CGFloat(-M_PI/2), endAngle: CGFloat(endAngle), clockwise: true)
            beierpath.lineCapStyle=CGLineCap.round
            beierpath.lineJoinStyle=CGLineJoin.round
            beierpath.lineWidth=10.0
            
            let mcashapelayer=CAShapeLayer()
            mcashapelayer.path=beierpath.cgPath
            mcashapelayer.strokeColor=lineColor.cgColor
            mcashapelayer.fillColor=nil
            
            //mcashapelayer.opacity=0.5
            
            mcashapelayer.strokeStart=0.0
            mcashapelayer.strokeEnd=0
            mcashapelayer.lineWidth=10
            mcashapelayer.lineCap=kCALineCapRound
            mcashapelayer.lineJoin=kCALineJoinRound
            
            
            self.layer.addSublayer(mcashapelayer)
            let anim=CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = 2.0
            if i<=3
            {
                anim.duration = 0.0
            }
            
            //anim.delegate=self
            anim.isRemovedOnCompletion=false
            anim.isAdditive=true
            anim.fillMode=kCAFillModeForwards
            anim.fromValue=0
            anim.toValue=1
            mcashapelayer.add(anim, forKey: "strokeEnd")
        }
        
        
    }
    


}
