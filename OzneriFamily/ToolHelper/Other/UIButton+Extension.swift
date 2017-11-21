//
//  UIButton+Extension.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/11/21.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/21  上午9:55
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

extension UIButton {
    
    /// create btn only text
    ///
    /// - Parameters:
    ///   - title:
    ///   - target:
    ///   - action:
    ///   - frame:
    /// - Returns:
    class func createButtonWithText(_ title:String?,target:AnyObject?,action:Selector,frame:CGRect) -> UIButton {
        
        let btn = UIButton()
        btn.setTitle(title, for: UIControlState.normal)
        
        btn.frame = frame
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        return btn
    }
    
}
