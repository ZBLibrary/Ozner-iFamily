//
//  CupMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupMainView: OznerDeviceView {

 
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @IBAction func headCenterClick(_ sender: UITapGestureRecognizer) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupSetting")
    }
    @IBAction func drinkingClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupDrinkingDetail")
    }
    @IBAction func temperatureClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupTemperatureDetail")
    }
    
    @IBOutlet var circleView: CupHeadCircleView!
    override func draw(_ rect: CGRect) {
        
        // Drawing code
    }
    override func SensorUpdate(device: OznerDevice!) {
        self.currentDevice=device
    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        self.currentDevice=device
    }

}
