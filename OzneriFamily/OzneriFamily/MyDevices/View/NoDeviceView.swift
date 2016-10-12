//
//  NoDeviceView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class NoDeviceView: UIView {
   
    var addDeviceClickBlock:(()->Void)!
    
    @IBAction func addDeviceClick(_ sender: AnyObject) {
        addDeviceClickBlock()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
