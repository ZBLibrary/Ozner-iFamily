//
//  WaterPurifierHeadCircleView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurifierHeadCircleView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    private var lastAngle:[CGFloat]=[0,0]//lastAngle=0需要动画，否则不需要动画
    private var currentAngle:[CGFloat]=[0,0]
    private var currentLayer:[CAGradientLayer]=[]
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for layer in currentLayer {
            layer.removeFromSuperlayer()
        }
        currentLayer=[]
        
        //第1条背景线
        let context=UIGraphicsGetCurrentContext()
        context!.setAllowsAntialiasing(true);
        context!.setLineWidth(2);
        context!.setStrokeColor(UIColor(white: 1, alpha: 0.8).cgColor);
        context?.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2), radius: rect.size.width/2-5, startAngle: -CGFloat(M_PI), endAngle: 0, clockwise: false)//clockwise顺时针
        context!.strokePath()
        if currentAngle[0] != 0 {
            //第2条背景线
            context!.setAllowsAntialiasing(true);
            context!.setLineWidth(2);
            context!.setStrokeColor(UIColor(white: 1, alpha: 0.8).cgColor);
            context?.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2), radius: rect.size.width/2-20, startAngle: -CGFloat(M_PI), endAngle: 0, clockwise: false)//clockwise顺时针
            context!.strokePath()
        }
        //TDS线
        for i in 0...1 {
            
        
            let shapeLayer=CAShapeLayer()
            shapeLayer.path=UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: rect.size.width/2), radius: rect.size.width/2-5-CGFloat(i*15), startAngle: -CGFloat(M_PI), endAngle: -CGFloat(M_PI)+CGFloat(M_PI)*currentAngle[i], clockwise: true).cgPath
            shapeLayer.lineCap="round"//圆角
            shapeLayer.lineWidth=10
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.purple.cgColor
            if lastAngle[i] == 0 {
                let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
                drawAnimation.duration            = 5.0;
                drawAnimation.repeatCount         = 0;
                drawAnimation.isRemovedOnCompletion = false;
                drawAnimation.fromValue = 0;
                drawAnimation.toValue   = 10;
                drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                shapeLayer.add(drawAnimation, forKey: "drawCircleAnimation")
            }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [
                UIColor(colorLiteralRed: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).cgColor,
                UIColor(colorLiteralRed: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).cgColor,
                UIColor(colorLiteralRed: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).cgColor
            ];
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.mask=shapeLayer
            currentLayer.append(gradientLayer)
            self.layer.addSublayer(gradientLayer)
        }
        lastAngle=currentAngle
        
        
    }
    func updateCircleView(angleBefore:CGFloat,angleAfter:CGFloat){
        currentAngle=[angleBefore,angleAfter]
        if currentAngle != lastAngle {
            self.setNeedsDisplay()
        }
        
    }


}
