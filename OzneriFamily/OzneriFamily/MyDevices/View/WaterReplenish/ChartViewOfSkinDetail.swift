//
//  ChartViewOfSkinDetail.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/7.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
struct WaterReplenishDataStuct {
    var date:NSDate!
    var oil:Double!
    var water:Double!
}
class ChartViewOfSkinDetail: UIView {

    var DataArr = [WaterReplenishDataStuct]()
    var ChartType = 0
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
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
            let pointsArr:[Int:CGPoint]=getNeedData(width: widthOfSelf, height: heightOfSelf, arr: DataArr, index: indexValue)//(width: widthOfSelf, height: heightOfSelf, arr: DataArr)
            
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
                for i in 0...4 {
                    let tmpLayer = CAShapeLayer()
                    
                    let tmpLinePath = UIBezierPath()
                    tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(i)*heightOfSelf/5))
                    tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(i)*heightOfSelf/5))
                    
                    tmpLayer.path = tmpLinePath.cgPath;
                    
                    tmpLayer.fillColor = nil;
                    
                    tmpLayer.opacity = 1;
                    
                    tmpLayer.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
                    
                    self.layer.addSublayer(tmpLayer)
                }
                //背景虚线
                let tmpLayer = CAShapeLayer()
                
                let tmpLinePath = UIBezierPath()
                tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(7)*heightOfSelf/10))
                tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(7)*heightOfSelf/10))
                
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
        let daysCount = ChartType==0 ? 7:NSDate().daysInMonth()
        var pointsArr:[Int:CGPoint]=[:]
        for i in 0..<daysCount {//初始化点
            pointsArr[i]=CGPoint(x: CGFloat(i)*width/CGFloat(daysCount), y: height)
            
        }
       
        for item in arr {
            if ChartType==0 {
                let indexOfDay=(item.date.weekday()-2) < 0 ? 6:(item.date.weekday()-2)
                pointsArr[indexOfDay]=CGPoint(x: (pointsArr[indexOfDay]?.x)!, y: CGFloat(100-(index==0 ? item.oil:item.water))*height/CGFloat(100))
            }else{
                let indexOfDay=item.date.day()-1
                pointsArr[indexOfDay]=CGPoint(x: (pointsArr[indexOfDay]?.x)!, y: CGFloat(100-(index==0 ? item.oil:item.water))*height/CGFloat(100))
            }
            
        }
        return pointsArr
    }
    
    //type 0周  1月
    
    func drawChartView(data:[WaterReplenishDataStuct],charttype:Int){
        DataArr=data
        ChartType=charttype
        self.setNeedsDisplay()
    }
}
