//
//  GYTempValueView.swift
//  UISlider
//
//  Created by ZGY on 2017/6/21.
//  Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/6/21  上午11:11
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYTempValueView: UIView {
    
    var valueLb: UILabel!
    var arrowView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
    

    fileprivate func initUI() {
        
        valueLb = UILabel(frame: CGRect.init(x: 3, y: 3, width: self.frame.width - 6, height: self.frame.height - 6))
        valueLb.layer.cornerRadius = valueLb.frame.height / 2
        valueLb.font = UIFont.systemFont(ofSize: 16)
        valueLb.textAlignment = .center
        valueLb.textColor = UIColor.init(hex: "48c2fa")
        addSubview(valueLb)
        
//        arrowView = UIView(frame: CGRect(x: 0, y: 0, width: 19, height: 18))
//        
//        var rect = arrowView.frame
//        rect.origin.y = self.bounds.height - 15
//        rect.origin.x = self.bounds.midX - round(arrowView.frame.width/2)
//        
//        arrowView.frame = rect
//        arrowView.backgroundColor = UIColor.blue
//        arrowView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
//        arrowView.layer.cornerRadius = 18
//        arrowView.backgroundColor = UIColor.clear
//        addSubview(arrowView)
//        sendSubview(toBack: arrowView)
//        
    }
    
    func changeValue(_ str:String) {
        
        valueLb.text = str
        
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        initUI()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
