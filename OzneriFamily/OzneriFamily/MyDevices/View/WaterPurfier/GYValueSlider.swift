//
//  GYValueSlider.swift
//  UISlider
//
//  Created by ZGY on 2017/6/21.
//  Copyright © 2017年 macpro. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/6/21  上午9:45
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

@objc protocol GYValueSliderDelegate {
   @objc optional func endTrackingSetValue()
}

class GYValueSlider: UISlider {

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
        
        maximumTrackTintColor = UIColor.clear
        self.minimumTrackTintColor = UIColor.clear
        self.isEnabled = false
        self.minimumValue = 40
        self.maximumValue = 99
        
        self.setMaximumTrackImage(imageFromColor(UIColor.clear), for: UIControlState.normal)
        self.setMaximumTrackImage(imageFromColor(UIColor.clear), for: UIControlState.normal)

        self.addTarget(self, action: #selector(sliderValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        gradientLaye = CAGradientLayer()
      
        switch LoginManager.currenIphoneType() {
        case .Iphone6:
            gradientLaye?.frame = CGRect(x: 1.5, y: 20, width: self.frame.width - 3, height: 2)
            break
        case .Iphone6p:
            gradientLaye?.frame = CGRect(x: 1.5, y: 20, width: self.frame.width - 3, height: 2)
            break
        default:
            gradientLaye?.frame = CGRect(x: 1.5, y: 8, width: self.frame.width - 3, height: 2)
            break
        }
        
        gradientLaye?.colors = [UIColor.init(hex: "0xFF6347").cgColor,
                                UIColor.init(hex: "0xFFEC8B").cgColor,
                                UIColor.init(hex: "0x98FB98").cgColor,
                                UIColor.init(hex: "0x00B2EE").cgColor,
                                UIColor.init(hex: "0x9400D3").cgColor]
        gradientLaye?.locations = [(0.1),(0.3),(0.5),(0.7),(1)]
        gradientLaye?.startPoint = CGPoint(x: 0, y: 0)
        gradientLaye?.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(gradientLaye!)

                
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let tracking = super.beginTracking(touch, with: event)
        
        beginAdd()
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
    
    func chageValueFrame() {
        
        var rect = previewView?.frame
        
        rect?.origin.x = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value).midX - ((rect?.width)! / 2)
        previewView?.frame = rect!
        
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        super.endTracking(touch, with: event)
        
        if previewView !=  nil {
            UserDefaults.standard.setValue(Int32(String.init(format: "%.0f", self.value)), forKey: "UISliderValue")
            UserDefaults.standard.synchronize()
            
//            let currentDevice = OznerManager.instance.currentDevice as! WaterPurifier_Blue
            
            if block != nil {
                block!()
            }
            
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
        previewView?.valueLb.text = String.init(format: "%.0f", self.value) + "℃"
        previewView?.layer.cornerRadius = (previewView?.frame.height)! / 2
        previewView?.alpha = 1.0
        previewView?.backgroundColor = UIColor.clear
        return previewView!
        
    }
    
    func beginAdd() {
        
        let rect = self.thumbRect(forBounds: self.bounds, trackRect: self.bounds, value: self.value)
        let rect1 = rect.insetBy(dx: -8, dy: -8)
        
        let rect2 = rect1.offsetBy(dx: 0, dy: -30)
        
        if previewView == nil {
    
            addSubview(creatGYTmpView(rect2))
            
            UIView.animate(withDuration: 0.08, animations: {
                self.previewView?.alpha = 1
            })
            
        } else {
            
            previewView?.frame = rect2
            
        }
        
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
        
    }
    
    

}
