//
//  OznerCircleView.swift
//  TestAnmial
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class LineChartView: UIView {

    
   
    
       override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let subLayers = self.layer.sublayers  {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let widthOfSelf = rect.size.width
        let heightOfSelf = rect.size.height
        
        
        //模拟数据
        var pointsArr:[CGPoint]=[]
        for i in 0...30 {
            pointsArr.append(CGPoint(x: CGFloat(i)*widthOfSelf/30, y: CGFloat(arc4random()%30)*heightOfSelf/30))
        }
        
       
        
        ////折线图颜色填充
        let linePath=UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: heightOfSelf))
        for i in 0..<pointsArr.count {
            linePath.addLine(to: pointsArr[i])
        }
        linePath.addLine(to: CGPoint(x: widthOfSelf, y: heightOfSelf))
      
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(colorLiteralRed: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).cgColor,
            UIColor(colorLiteralRed: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).cgColor,
            UIColor.white.cgColor//UIColor(colorLiteralRed: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).CGColor
            
        ];
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.type = kCAGradientLayerAxial
        let shapeLayer=CAShapeLayer()
        shapeLayer.path=linePath.cgPath
        gradientLayer.mask=shapeLayer
        self.layer.addSublayer(gradientLayer)
        

        //背景线
        for i in 0...2 {
            let tmpLayer = CAShapeLayer()
            
            let tmpLinePath = UIBezierPath()
            tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(i*44)*heightOfSelf/112))
            tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(i*44)*heightOfSelf/112))
            
            tmpLayer.path = tmpLinePath.cgPath;
            
            tmpLayer.fillColor = nil;
            
            tmpLayer.opacity = 1;
            
            tmpLayer.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
            
            self.layer.addSublayer(tmpLayer)
        }
        //轮廓线
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path=linePath.cgPath
        shapeLayer2.lineWidth=1
        shapeLayer2.fillColor = UIColor.white.withAlphaComponent(0.4).cgColor
        shapeLayer2.strokeColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        self.layer.addSublayer(shapeLayer2)
        
    }
    func updateCircleView(){
        self.setNeedsDisplay()
    }

}
