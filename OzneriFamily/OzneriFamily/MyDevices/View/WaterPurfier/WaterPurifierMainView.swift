//
//  WaterPurifierMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurifierMainView: OznerDeviceView {

    var scanEnable = true
    var coolEnable = true
    var hotEnable = true
    var buyLvXinUrl = ""
    var lvXinStopDate = NSDate()
    var lvXinUsedDays = 0
    @IBOutlet var circleView: WaterPurifierHeadCircleView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setLvXinAndEnable(scan:Bool,cool:Bool,hot:Bool,buyLvXinUrl:String,lvXinStopDate:NSDate,lvXinUsedDays:Int){
        self.scanEnable=scan
        self.coolEnable=cool
        self.hotEnable=hot
        self.buyLvXinUrl=buyLvXinUrl
        self.lvXinStopDate=lvXinStopDate
        self.lvXinUsedDays=lvXinUsedDays
       
        
    }
}
