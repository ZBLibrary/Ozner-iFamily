//
//  GYProgressView.swift
//  ProgressView
//
//  Created by ZGY on 2017/7/19.
//  Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/19  下午1:52
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYProgressView: UIView {

    var progressLayer:CAShapeLayer?
    var progressLayer1:CAShapeLayer?
    var progressGradientLayer:CAGradientLayer?
    var progressGradientLayer2:CAGradientLayer?
    
    var upperShapeLayer:CAShapeLayer?
    var upperShapeLayer1:CAShapeLayer?
    var timer:Timer?
    var startAngle = CGFloat(Double.pi) - 0.2
    var endAngle:CGFloat = CGFloat(Double.pi) + 3.4
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawLayers()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawLayers()
        
    }
    
    fileprivate func drawLayers() {
        
        self.backgroundColor = UIColor.clear
        
        drawProgressLayer()
        drawUpperLayer()
        drawUpperLayerTwo()
        drawProgressGradientLayer()
        drawProgressGradientLayer2()
        progressLayer?.addSublayer(progressGradientLayer!)
        progressLayer?.addSublayer(progressGradientLayer2!)
//        progressLayer1?.addSublayer(progressGradientLayer2!)
        progressGradientLayer?.mask = upperShapeLayer
        progressGradientLayer2?.mask = upperShapeLayer1
        self.layer.addSublayer(progressLayer!)
//        self.layer.addSublayer(progressLayer1!)

//        d(1, b: 2,3,4)
        
    }
    
//    fileprivate func d(_ a:Int,b:Int...) {
//        print(b[1])
//        
//    }
    
    func startAnimation() {
        
//        let transition = CATransition()
//        transition.repeatCount = 3
//        transition.duration = 5
////        transition.type  = kCATransitionMoveIn
//        self.upperShapeLayer?.strokeStart = 0
//        self.upperShapeLayer?.strokeEnd = 1
////        transition.subtype = kCAMediaTimingFunctionLinear
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
//    
//        self.upperShapeLayer?.add(transition, forKey: "transition")
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
            CATransaction.setAnimationDuration(3)
            self.upperShapeLayer1?.strokeEnd = 1
            self.upperShapeLayer?.strokeEnd = 1
            CATransaction.commit()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GYProgressView.timerAction), userInfo: nil, repeats: true)

        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
        
      
    }
    
    
    func stopanimation() {
        
        if timer != nil {
            
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    deinit {
        if timer != nil {
         
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    func timerAction() {
        
        DispatchQueue.main.async {
            
            CATransaction.commit()
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
            CATransaction.setAnimationDuration(0)
            self.upperShapeLayer?.strokeEnd = 0
            self.upperShapeLayer1?.strokeEnd = 0
            CATransaction.commit()
            
            //
            CATransaction.commit()
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
            CATransaction.setAnimationDuration(3)
            self.upperShapeLayer?.strokeEnd = 1
            self.upperShapeLayer1?.strokeEnd = 1
            CATransaction.commit()
            
        }
        
    }
    
    fileprivate func drawUpperLayer() {
        
        upperShapeLayer = CAShapeLayer()
        upperShapeLayer?.frame = self.bounds
        
        let bezierPath = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 35) , radius: (self.bounds.size.width - 100)/1.5, startAngle: startAngle , endAngle: endAngle, clockwise: true)
        upperShapeLayer?.path = bezierPath.cgPath
        
        upperShapeLayer?.strokeStart = 0
        upperShapeLayer?.strokeEnd = 0
        upperShapeLayer?.lineJoin = kCALineJoinRound
        upperShapeLayer?.lineWidth = 25
        upperShapeLayer?.cornerRadius = 2.5
        upperShapeLayer?.masksToBounds = true
        upperShapeLayer?.lineCap = kCALineCapButt
        upperShapeLayer?.lineDashPattern = [5,40]
        upperShapeLayer?.strokeColor = UIColor.red.cgColor
        upperShapeLayer?.fillColor = UIColor.clear.cgColor
        
        
    }
    
    fileprivate func drawUpperLayerTwo() {
        
        upperShapeLayer1 = CAShapeLayer()
        upperShapeLayer1?.frame = self.bounds
        
        let bezierPath = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 + 35) , radius: (self.bounds.size.width - 100)/1.5 + 5, startAngle: startAngle , endAngle: endAngle, clockwise: true)
        upperShapeLayer1?.path = bezierPath.cgPath
        
        upperShapeLayer1?.strokeStart = 0
        upperShapeLayer1?.strokeEnd = 0
        
        upperShapeLayer1?.lineWidth = 18
        upperShapeLayer1?.lineJoin = kCALineJoinRound
        upperShapeLayer1?.lineCap = kCALineCapButt
        upperShapeLayer1?.lineDashPattern = [5,20,5,40,5,40,5,40,5,40,5,24,5,20,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40,5,40]
        upperShapeLayer1?.cornerRadius = 2.5
        upperShapeLayer1?.masksToBounds = true
        
        upperShapeLayer1?.strokeColor = UIColor.red.cgColor
        upperShapeLayer1?.fillColor = UIColor.clear.cgColor
        
    }
    
    fileprivate func drawProgressLayer() {
        
        
        progressLayer = CAShapeLayer()
        progressLayer?.frame = self.bounds
        
        let bezierPath = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 35) , radius: (self.bounds.size.width - 100)/1.5, startAngle: startAngle , endAngle: endAngle , clockwise: true)
        
        progressLayer?.path = bezierPath.cgPath
    
        progressLayer?.lineCap = kCALineCapButt
        progressLayer?.lineDashPattern = [5,40]
        progressLayer?.lineWidth = 25
        progressLayer?.cornerRadius = 2.5
        progressLayer?.masksToBounds = true
        progressLayer?.lineJoin = kCALineJoinRound
        progressLayer?.strokeColor = UIColor.clear.cgColor
        progressLayer?.fillColor = UIColor.clear.cgColor
        
//        progressLayer1 = CAShapeLayer()
//        progressLayer1?.frame = self.bounds
//        
//        let bezierPath1 = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 35) , radius: (self.bounds.size.width - 100)/1.5, startAngle: startAngle + 0.5 , endAngle: endAngle - 0.5, clockwise: true)
//        
//        progressLayer1?.path = bezierPath1.cgPath
//        
//        progressLayer1?.lineCap = kCALineCapButt
//        progressLayer1?.lineDashPattern = [5,25]
//        progressLayer1?.lineWidth = 15
//        
//        progressLayer1?.strokeColor = UIColor.clear.cgColor
//        progressLayer1?.fillColor = UIColor.clear.cgColor
        
        
    }
    
    
    fileprivate func drawProgressGradientLayer() {

        let path = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 35), radius: (self.bounds.size.width - 100)/1.5, startAngle: startAngle , endAngle: endAngle , clockwise: true)
        
        progressGradientLayer = CAGradientLayer()
        progressGradientLayer?.shadowPath = path.cgPath
        progressGradientLayer?.frame = self.bounds
        progressGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        progressGradientLayer?.endPoint = CGPoint(x: 1, y: 0)
        progressGradientLayer?.colors = [
            UIColor(colorLiteralRed: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).cgColor,
            UIColor(colorLiteralRed: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).cgColor,
            UIColor(colorLiteralRed: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).cgColor
        ]
        
    }
    
    fileprivate func drawProgressGradientLayer2() {
        
        let path = UIBezierPath(arcCenter:CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 35), radius: (self.bounds.size.width - 100)/1.5, startAngle: startAngle , endAngle: endAngle , clockwise: true)
        
        progressGradientLayer2 = CAGradientLayer()
        progressGradientLayer2?.shadowPath = path.cgPath
        progressGradientLayer2?.frame = self.bounds
        progressGradientLayer2?.startPoint = CGPoint(x: 0, y: 0.5)
        progressGradientLayer2?.endPoint = CGPoint(x: 1, y: 0)
        progressGradientLayer2?.colors = [
            UIColor(colorLiteralRed: 9.0/255, green: 142.0/255, blue: 254.0/255, alpha: 1.0).cgColor,
            UIColor(colorLiteralRed: 134.0/255, green: 102.0/255, blue: 255.0/255, alpha: 1.0).cgColor,
            UIColor(colorLiteralRed: 215.0/255, green: 67.0/255, blue: 113.0/255, alpha: 1.0).cgColor
        ]
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        drawLayers()
    }
    

}
