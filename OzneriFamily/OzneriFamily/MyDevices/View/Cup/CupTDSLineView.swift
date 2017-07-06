//
//  CupTDSLineView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/17.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSLineView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let subLayers = self.layer.sublayers  {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        let widthOfSelf = rect.size.width
        let heightOfSelf = rect.size.height
        let pointsArr:[Int:CGPoint]=getNeedData(width: widthOfSelf, height: heightOfSelf)
        
        ////折线图颜色填充
        let linePath=UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: heightOfSelf))
        for i in 0..<pointsArr.count {
            linePath.addLine(to: pointsArr[i]!)
        }
        linePath.addLine(to: CGPoint(x: widthOfSelf, y: heightOfSelf))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = (sensorType==0 ? [
            UIColor(hexString: "#ee696b")!.cgColor,
            UIColor(hexString: "#7f64e5")!.cgColor,
            UIColor(hexString: "#4990ef")!.cgColor
            ]
            :[
                UIColor(hexString: "#ef6668")!.cgColor,
                UIColor(hexString: "#e58e62")!.cgColor,
                UIColor(hexString: "#4bacef")!.cgColor
                
        ])
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
    
    private func getNeedData(width:CGFloat,height:CGFloat)->[Int:CGPoint]{
        let daysCount=[24,7,NSDate().daysInMonth()][dateType]
        var pointsArr:[Int:CGPoint]=[:]
        for i in 0..<daysCount {//初始化点
            pointsArr[i]=CGPoint(x: CGFloat(i)*width/CGFloat(daysCount), y: height)
            
        }
        if volumes != nil {
            var starDate=NSDate()
            starDate=NSDate(string: starDate.formattedDate(withFormat: "YYYY-MM-dd")+" 00:00:00", formatString: "YYYY-MM-dd hh:mm:ss")
            var dataArr = [Int:(Temperature:Int,Volume:Int,TDS:Int)]()
            switch dateType {
            case 0:
                //取这个天的
                dataArr = volumes.getRecord(type: CupRecordType.day)
            case 1://本周
                dataArr = volumes.getRecord(type: CupRecordType.weak)
            case 2://本月
                dataArr = volumes.getRecord(type: CupRecordType.month)
            default:
                break
            }
            for item in dataArr {

                let index=item.key
                let point = sensorType==0 ? getPointFromTDS(pointX: (pointsArr[index]?.x)!, height: height, TDS: item.value.TDS):
                    getPointFromTemp(pointX: (pointsArr[index]?.x)!, height: height, Temp: item.value.Temperature)
                pointsArr[index]=point
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
    func getPointFromTemp(pointX:CGFloat,height:CGFloat,Temp:Int) -> CGPoint {
        var angle = CGFloat(0)
        
        switch true {
        case Temp<=Int(temperature_low):
            angle=CGFloat(Temp)/CGFloat(temperature_low*3)
        case Temp>Int(temperature_low)&&Temp<=Int(temperature_high):
            angle=CGFloat(Temp-Int(temperature_low))/CGFloat((temperature_high-temperature_low)*3)+0.33
        case Temp>Int(temperature_high)&&Temp<=100:
            angle=CGFloat(Temp-Int(temperature_high))/CGFloat((100-temperature_high)*3)+0.66
        default:
            angle=1.0
            break
        }
        return CGPoint(x: pointX, y: (1-angle)*height)
    }
    //模拟数据
    var volumes:OznerCupRecords!
    var sensorType = 0//0 tds,1 temp
    var dateType = 0//0 day,1 weak,2 month
    func updateCircleView(SensorType:Int,DateType:Int,Volumes:OznerCupRecords){
        sensorType=SensorType
        volumes=Volumes
        dateType=DateType
        self.setNeedsDisplay()
        
    }

}
