//
//  WashDush_WifiMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/8/9.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/8/9  下午2:06
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class WashDush_WifiMainView: OznerDeviceView {
    
    
    @IBOutlet var remindTimeView1: UIView!
    @IBOutlet var remindTimeView2: UIView!
    @IBOutlet var remindTimeView3: UIView!
    @IBOutlet var remindTimeValue: UILabel!

    @IBOutlet var temperatView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
       temperatView.layer.cornerRadius=temperatView.frame.height/2
        remindTimeView1.layer.cornerRadius=remindTimeView1.frame.height/2
        remindTimeView2.layer.cornerRadius=remindTimeView2.frame.height/2
        remindTimeView3.layer.cornerRadius=remindTimeView3.frame.height/2
        
    }
    

}
