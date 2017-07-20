//
//  ElectrickettleMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/7/19.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/19  上午10:42
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ElectrickettleMainView: OznerDeviceView {
    
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var lineView: CupHeadCircleView!
    @IBOutlet weak var progressView: GYProgressView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var segement: UISegmentedControl!
    
    var currentTempBtn:UIButton?
    var currentHotBtn:UIButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.isHidden = true
        lineView.layer.masksToBounds = true
        lineView.layer.cornerRadius = 10
        scrollerView.bounces = true
        progressView.startAnimation()
        segement.addTarget(self, action: #selector(ElectrickettleMainView.segmentedChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    
    @IBAction func tempChange(_ sender: UIButton) {
        
        if currentTempBtn?.tag == sender.tag {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
        
        self.currentTempBtn?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        self.currentTempBtn?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            
        }
        currentTempBtn = sender
        
        UIView.animate(withDuration: 0.5) { 
            
            sender.transform = CGAffineTransform(a: 1.3, b: 0, c: 0, d: 1.3, tx: 0, ty: 0)
            sender.setTitleColor(UIColor.init(red: 168/255.0, green: 40/255.0, blue: 102/255.0, alpha: 1.0), for: UIControlState.normal)
        }
        
        
    }
    
 
    @IBAction func hotAction(_ sender: UIButton) {
        
        
        if currentHotBtn?.tag == sender.tag {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            
            self.currentHotBtn?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            self.currentHotBtn?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            
        }
        currentHotBtn = sender
        
        UIView.animate(withDuration: 0.5) {
            
            sender.transform = CGAffineTransform(a: 1.3, b: 0, c: 0, d: 1.3, tx: 0, ty: 0)
            sender.setTitleColor(UIColor.init(red: 168/255.0, green: 40/255.0, blue: 102/255.0, alpha: 1.0), for: UIControlState.normal)
        }
        
        
    }
    
    func segmentedChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            UIView.transition(with: headView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.lineView.isHidden = true
                self.progressView.isHidden = false
                self.progressView.startAnimation()
                
            }, completion: { (finished) in
                
            })
            
            break
        case 1:
            UIView.transition(with: headView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                
                self.progressView.stopanimation()
                self.progressView.isHidden = true
                self.progressView.upperShapeLayer?.strokeEnd = 0
                self.lineView.isHidden = false
                
            }, completion: { (finished) in
                
            })
            
            break
        default:
            break
        }
        
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
