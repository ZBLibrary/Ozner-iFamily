//
//  CupDrinkingChartView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/14.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupDrinkingChartView: UIView {

    var volumes:OznerCupRecords!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let subLayers = self.layer.sublayers  {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        let widthOfSelf = rect.size.width
        let heightOfSelf = rect.size.height
        
        let pointsArr=getNeedData(width: widthOfSelf, height: heightOfSelf) as [Int:CGPoint]
        //背景实线
        for i in 0..<3{
            let tmpLayer = CAShapeLayer()
            let tmpLinePath = UIBezierPath()
            tmpLinePath.move(to: CGPoint(x: 0, y: CGFloat(i)*heightOfSelf/3))
            tmpLinePath.addLine(to: CGPoint(x: widthOfSelf, y: CGFloat(i)*heightOfSelf/3))
            tmpLayer.path = tmpLinePath.cgPath;
            tmpLayer.fillColor = nil;
            tmpLayer.opacity = 1;
            tmpLayer.strokeColor = UIColor.blue.withAlphaComponent(0.1).cgColor
            self.layer.addSublayer(tmpLayer)
        }
        
        for (_,value) in pointsArr{
            
            let tmpLayer = CAShapeLayer()
            let tmpLinePath = UIBezierPath()
            tmpLinePath.move(to: CGPoint(x: value.x, y: heightOfSelf))
            tmpLinePath.addLine(to: value)
            tmpLayer.path = tmpLinePath.cgPath;
            tmpLayer.fillColor = nil
            tmpLayer.lineWidth = 4
            tmpLayer.opacity = 1
            tmpLayer.strokeColor = UIColor(hexString: "#4990ef")!.cgColor
            self.layer.addSublayer(tmpLayer)
        }
        
        
    }
    private func getNeedData(width:CGFloat,height:CGFloat)->[Int:CGPoint]{
        let pointCount = [24,7,NSDate().daysInMonth()][segIndex]
        var pointsArr:[Int:CGPoint]=[:]
        for i in 0..<pointCount {//初始化点
            pointsArr[i]=CGPoint(x: CGFloat(i)*width/CGFloat(pointCount), y: height)
            
        }        
        let arr = volumes.getRecord(type: [.day,.weak,.month][segIndex])
        
        for item in arr {
            let volume=item.value.Volume
            let maxvolume = [500,3000,3000][segIndex]
            var tmpPercent=CGFloat(volume)/CGFloat(maxvolume)
            tmpPercent=min(tmpPercent, 1.1)
            let index=item.key
            
            pointsArr[index]=CGPoint(x: (pointsArr[index]?.x)!, y: (1-tmpPercent)*height)
        }
        return pointsArr
    }
    var segIndex=0
    func updateView(segindex:Int)  {
        segIndex=segindex
        self.setNeedsDisplay()
    }
}
