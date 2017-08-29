//
//  GYLabel.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/2/23.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/2/23  14:45
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if self.text != nil {
            self.text = loadLanguage(self.text!)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
     
        if self.text != nil {
            self.text = loadLanguage(self.text!)
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
}

class HelperTools: NSObject {
    
    class func callMobile(_ view:UIView) {
       
        let urlStr = NSMutableString.init(string: "tel:4008209667")
        
        let callWebView = UIWebView()
        callWebView.loadRequest(URLRequest(url: URL(string: urlStr as String)!))
        
        view.addSubview(callWebView)
        
        
    }
    
    
}
