//
//  WaterPurfierTDSChart.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurfierTDSChart: UIView {

    var weakData=[WaterReplenishDataStuct]()
    var monthData=[WaterReplenishDataStuct]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let subLayers = self.layer.sublayers  {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        let widthOfSelf = rect.size.width
        let heightOfSelf = rect.size.height
        for indexValue in 0...1
        {
            let pointsArr:[Int:CGPoint]=getNeedData(width: widthOfSelf, height: heightOfSelf, arr: IsWeak ? weakData:monthData, index: indexValue)
            
            ////折线图颜色填充
            let linePath=UIBezierPath()
            linePath.move(to: CGPoint(x: 0, y: heightOfSelf))
            for i in 0..<pointsArr.count {
                linePath.addLine(to: pointsArr[i]!)
            }
            linePath.addLine(to: CGPoint(x: widthOfSelf, y: heightOfSelf))
            
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.frame = self.bounds
//            gradientLayer.colors = [
//                UIColor(colorLiteralRed: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).cgColor,
//                UIColor(colorLiteralRed: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).cgColor,
//                UIColor.white.cgColor//UIColor(colorLiteralRed: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).CGColor
//                
//            ];
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//            gradientLayer.type = kCAGradientLayerAxial
//            let shapeLayer=CAShapeLayer()
//            shapeLayer.path=linePath.cgPath
//            gradientLayer.mask=shapeLayer
//            self.layer.addSublayer(gradientLayer)
            
            if indexValue==1 {
                
                
                //背景实线
                for i in 0...1 {
                    let tmpLayer = CAShapeLayer()
                    
                    let tmpLinePath = UIBezierPath()
                    tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(i)*heightOfSelf/3))
                    tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(i)*heightOfSelf/3))
                    
                    tmpLayer.path = tmpLinePath.cgPath;
                    
                    tmpLayer.fillColor = nil;
                    
                    tmpLayer.opacity = 1;
                    
                    tmpLayer.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
                    
                    self.layer.addSublayer(tmpLayer)
                }
                //背景虚线
                let tmpLayer = CAShapeLayer()
                
                let tmpLinePath = UIBezierPath()
                tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(2)*heightOfSelf/3))
                tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(2)*heightOfSelf/3))
                
                tmpLayer.path = tmpLinePath.cgPath;
                tmpLayer.lineDashPattern=[8,8]
                tmpLayer.fillColor = nil;
                
                tmpLayer.opacity = 1;
                
                tmpLayer.strokeColor = UIColor.green.withAlphaComponent(0.8).cgColor
                
                self.layer.addSublayer(tmpLayer)
            }
            //轮廓线
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.path=linePath.cgPath
            shapeLayer2.lineWidth=1//d7a6c7 418bef
            shapeLayer2.fillColor = UIColor.white.withAlphaComponent(0.4).cgColor
            shapeLayer2.strokeColor = UIColor(hexString: indexValue==0 ? "#d31a98":"#418bef")?.cgColor
            self.layer.addSublayer(shapeLayer2)
        }
    }
    private func getNeedData(width:CGFloat,height:CGFloat,arr:[WaterReplenishDataStuct],index:Int)->[Int:CGPoint]{
        let daysCount = IsWeak ? 7:NSDate().daysInMonth()
        var pointsArr:[Int:CGPoint]=[:]
        for i in 0..<daysCount {//初始化点
            pointsArr[i]=CGPoint(x: CGFloat(i)*width/CGFloat(daysCount), y: height)
            
        }
        
        for item in arr {
            if IsWeak {
                let indexOfDay=(item.date.weekday()-2) < 0 ? 6:(item.date.weekday()-2)
                pointsArr[indexOfDay]=getPointFromTDS(pointX: (pointsArr[indexOfDay]?.x)!, height: height, TDS: Int(index==0 ? item.oil:item.water))
                
            }else{
                let indexOfDay=item.date.day()-1
                pointsArr[indexOfDay]=getPointFromTDS(pointX: (pointsArr[indexOfDay]?.x)!, height: height, TDS: Int(index==0 ? item.oil:item.water))
            }
            
        }
        return pointsArr
    }
    func getPointFromTDS(pointX:CGFloat,height:CGFloat,TDS:Int) -> CGPoint {
        var angle = CGFloat(0)
        
        switch true {
        case TDS<=Int(tds_good):
            angle=CGFloat(TDS)/CGFloat(tds_good*3)
        case TDS>Int(tds_good)&&TDS<=Int(tds_bad):
            angle=CGFloat(TDS-Int(tds_good))/CGFloat((tds_bad-tds_good)*3)+0.33
        case TDS>Int(tds_bad)&&TDS<Int(tds_bad+50):
            angle=CGFloat(TDS-Int(tds_bad))/CGFloat(50*3)+0.66
        default:
            angle=1.0
            break
        }
        return CGPoint(x: pointX, y: (1-angle)*height)
    }
    
    var IsWeak=true
    func updateView(isWeak:Bool)  {
        IsWeak=isWeak
        self.setNeedsDisplay()
    }
}
