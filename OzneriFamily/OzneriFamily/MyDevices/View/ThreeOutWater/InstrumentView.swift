//
//  InstrumentView.swift
//  ATAnimatons
//
//  Created by ZGY on 2018/1/16.
//Copyright © 2018年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2018/1/16  上午10:26
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class InstrumentView: UIView {

    private var progressLayer:CAShapeLayer?
    private var colorsLayer:CAGradientLayer?
    private var startAngle = CGFloat.pi * 0.75
    private var endAngle = CGFloat.pi * 2.25
    private var radius:CGFloat = 0.0
    private var widthA:CGFloat = 0.0
    private var heightA:CGFloat = 0.0
    private var sumAngle = CGFloat.pi * 1.5
    var progress:CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
       
    }

    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         initData()
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLayer()

    }
    
    private func initData() {
        
        self.backgroundColor = UIColor.clear
        radius = self.frame.width/2
        widthA = self.frame.width / 2
        heightA = self.frame.width / 2
        
    }
    
    func setTemperature(_ temperature:CGFloat) {
        
        let sumNum = CGFloat(sumAngle / (CGFloat.pi * 0.03))
        progress = temperature * (sumNum/100.0)
        setNeedsDisplay()
        
    }
    
    fileprivate func drawLayer() {
        
        
        let context = UIGraphicsGetCurrentContext() //获取上下文
        
        context?.translateBy(x: self.bounds.midX, y: self.bounds.midY)

        let sumNum = Int(sumAngle / (CGFloat.pi * 0.03))
        let colors = Colors.getMuatbleColors()
        
        for i in 0...sumNum {
            if i == 0 {
                context?.rotate(by: (CGFloat.pi * 45 / 180))
            } else {
                context?.rotate(by: (CGFloat.pi * 0.03))
            }
            
            if i%2 == 1 {
                context?.saveGState()
                context?.addLines(between: [CGPoint(x: 0, y: radius * 0.75),CGPoint(x: 0, y: radius * 0.75 + 15 )])
                context?.setStrokeColor(colors[sumNum - i].cgColor)
                context?.setLineWidth(3)
                context?.setLineCap(CGLineCap.round)
                context?.strokePath()
                context?.restoreGState()
                
            } else {
                context?.saveGState()
                context?.addLines(between: [CGPoint(x: 0, y: radius * 0.75),CGPoint(x: 0, y: radius * 0.75 + 25 )])
                context?.setStrokeColor(colors[sumNum - i].cgColor)
                context?.setLineWidth(3)
                context?.setLineCap(CGLineCap.round)
                context?.strokePath()
                context?.restoreGState()
            }

        }
        
        context?.translateBy(x: 0, y: 0)
        context?.saveGState()
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius * 0.6, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        
        context?.addPath(path.cgPath)
        path.addLine(to:CGPoint(x: -radius * 0.2, y: radius * 0.5))
        path.addLine(to: CGPoint(x: -radius * 0.5, y: radius * 0.5))
        path.addLine(to: CGPoint(x: -radius * 0.5, y: radius * 0.2))

        context?.rotate(by: (CGFloat.pi * 45 / 180) + (CGFloat.pi * 0.03) * progress)
        
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setFillColor(UIColor.white.cgColor)
        path.fill()
        context?.strokePath()
        context?.restoreGState()//恢复成初始状态
        
        let str:NSString = "\(Int(progress * 2.0))" + "℃" as NSString
        context?.saveGState()
        context?.rotate(by: (CGFloat.pi * 45 / 180))
        let attributes = [NSFontAttributeName:  UIFont.systemFont(ofSize: 40),  NSForegroundColorAttributeName: UIColor.blue]
        
        str.draw(at: CGPoint(x: -42, y:-50), withAttributes: attributes)
        ("当前温度" as NSString).draw(at: CGPoint(x: -60, y:10), withAttributes: [NSFontAttributeName:  UIFont.systemFont(ofSize: 30), NSForegroundColorAttributeName: UIColor.blue])
        
        context?.restoreGState()
 
    }
    
    

}
