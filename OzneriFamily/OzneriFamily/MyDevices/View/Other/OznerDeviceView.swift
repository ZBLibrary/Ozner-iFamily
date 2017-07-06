//
//  OznerDeviceView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/18.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
//enum DeviceViewStatus {
//    case DisConnect
//    case Connectting
//    case Connectted
//    case offLine
//    case onLine
//}
class OznerDeviceView: UIView {

    var delegate:DeviceViewContainerDelegate!
    var currentDevice:OznerBaseDevice?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func SensorUpdate(identifier: String) {
        
     
    }
    //连接状态变化
    func StatusUpdate(identifier: String,status:OznerConnectStatus) {
        
    }
    
}
