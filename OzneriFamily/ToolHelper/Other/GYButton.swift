//
//  GYButton.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/2/28.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/2/28  14:44
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.title(for: UIControlState.normal) != nil {
            self.setTitle(loadLanguage(self.title(for: UIControlState.normal)!), for: UIControlState.normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if self.title(for: UIControlState.normal) != nil {
            self.setTitle(loadLanguage(self.title(for: UIControlState.normal)!), for: UIControlState.normal)
        }
    }

}
