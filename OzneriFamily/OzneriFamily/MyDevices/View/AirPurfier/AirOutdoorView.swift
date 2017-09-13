//
//  AirOutdoorView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class AirOutdoorView: UIView {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var pm25Label: UILabel!
    @IBOutlet var AQILabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var himitLabel: UILabel!
    @IBOutlet var dataFromLabel: UILabel!
    @IBAction func IKnowClick(_ sender: UIButton) {
        callBack()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var callBack:(()->Void)!
    func updateView(city:String,pm25:Int,AQI:String,temp:String,himit:String,from:String,callback:@escaping (()->Void)){
        cityNameLabel.text=city
        pm25Label.text = (pm25==0 ? "-":"\(pm25)")+"ug/m3"
        AQILabel.text=AQI
        tempLabel.text=temp+"℃"
        himitLabel.text=himit+"%"
        dataFromLabel.text=loadLanguage("数据来源:")+from
        callBack=callback
    }
}
