//
//  GYValueElectSlider.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/7/20.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/20  下午3:59
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit


class GYValueElectSlider: UISlider {

   
    var gradientLaye: CAGradientLayer?
    var previewView:GYTempValueView?
    weak var delegate:GYValueSliderDelegate?
    var block:(() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
        
    }
    
    fileprivate func initUI() {
        
        self.minimumTrackTintColor = UIColor.init(hexString: "a63765")
        self.isEnabled = true
        self.minimumValue = 0
        self.maximumValue = 100
        
        self.addTarget(self, action: #selector(sliderValueChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let tracking = super.beginTracking(touch, with: event)
        let rect = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value)
        let rect1 = rect.insetBy(dx: -8, dy: -8)
        
        let rect2 = rect1.offsetBy(dx: 0, dy: -30)
        
        if previewView == nil {
            
            //            let rect = CGRect.offsetBy(CGRect.insetBy(self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value)))
            
            
            addSubview(creatGYTmpView(rect2))
            
            UIView.animate(withDuration: 0.08, animations: {
                self.previewView?.alpha = 1
            })
            
        } else {
            
            //            let rect = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value)
            //            let rect1 = rect.insetBy(dx: -8, dy: -8)
            //            let rect2 = rect1.offsetBy(dx: 0, dy: -20)
            previewView?.frame = rect2
            
        }
        
        
        return tracking
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let continueTracking = super.continueTracking(touch, with: event)
        
        if self.isTracking {
            
            var rect = previewView?.frame
            rect?.origin.x = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value).midX - ((rect?.width)! / 2)
            previewView?.frame = rect!
            previewView?.changeValue(String.init(format: "%.0f", self.value) + "℃")
            
        }
        
        return continueTracking
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        super.endTracking(touch, with: event)
        
        if previewView !=  nil {
            UserDefaults.standard.setValue(Int32(String.init(format: "%.0f", self.value)), forKey: "UISliderValueElectrickettle")
            UserDefaults.standard.synchronize()
            
            let device = OznerManager.instance.currentDevice as? Electrickettle_Blue
            
            _ = device?.setSetting((hotTemp: lround(Double(self.value)), hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
            previewView?.valueLb.text = String.init(format: "%d", lround(Double(self.value))) + "℃"

            
//            _ = device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 0, hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
//            if block != nil {
//                block!()
//            }
            
            //            removeFromGYSlider()
            
        }
        
    }
    
    fileprivate func removeFromGYSlider() {
        
        var rect = previewView?.frame
        
        rect?.origin.x = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value).midX - ((rect?.width)! / 2)
        
        previewView?.frame = rect!
        
        UIView.animate(withDuration: 0.07, animations: {
            
        }) { (finished) in
            if finished {
                
                if self.previewView != nil {
                    self.previewView?.removeFromSuperview()
                    self.previewView = nil
                }
                
            }
        }
        
    }
    
    func creatGYTmpView(_ frame: CGRect) -> GYTempValueView{
        
        previewView = GYTempValueView(frame: frame)
        //        String(Double(self.value) * 100.0)
        previewView?.valueLb.text = String.init(format: "%.0f", self.value) + "℃"
        previewView?.valueLb.textColor = UIColor.init(hexString: "a63765")
        previewView?.layer.cornerRadius = (previewView?.frame.height)! / 2
        previewView?.alpha = 1.0
        previewView?.backgroundColor = UIColor.clear
        return previewView!
        
    }
    
    func sliderValueChanged(_ sender:UISlider) {
        
        print(sender.value)
        
    }
    
    fileprivate func imageFromColor(_ color: UIColor) -> UIImage{
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
        //        fatalError("init(coder:) has not been implemented")
        
    }
    
    

}
