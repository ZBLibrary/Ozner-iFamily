//
//  LeftMenuDeviceCell.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

let AttributeOfDevice = "AttributeOfDevice"

class LeftMenuDeviceCell: UITableViewCell {

    var device:OznerBaseDevice! {
        didSet{
            deviceName.text=device.settings.name
            deviceAdressLabel.text=device.settings.GetValue(key: AttributeOfDevice, defaultValue: loadLanguage("我的家庭"))
            connectLabel.text=[OznerConnectStatus.Connecting:loadLanguage("连接中"),OznerConnectStatus.Disconnect:loadLanguage("已断开"),OznerConnectStatus.Connected:loadLanguage("已连接")][device.connectStatus]
            switch ProductInfo.getIOTypeFromProductID(productID: device.deviceInfo.productID) {
            case .Blue:
                connectImg.image=UIImage(named: "device_icon_blutooth")//蓝牙图标
                break
            case .MxChip,.Ayla,.AylaMxChip:
                connectImg.image=UIImage(named: "device_icon_wifi")//Wifi图标
                break
            default:
                connectImg.image=UIImage(named: "")//无图标
                break
            }
        }
    }
    @IBOutlet var bgView: UIView!
    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var connectImg: UIImageView!
    @IBOutlet var connectLabel: UILabel!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var deviceAdressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    private let imgArr:[OZDeviceClass:NSArray]=[
        .Cup:["device_cup_normal_state","deveice_cup_select_state"],
        .Tap:["device_tan_tou_noamrl_state","device_tan_tou_select_state"],
        .TDSPan:["device_TDSPAN_noamrl_state","device_tdspan_select_state"],
        .WaterPurifier_Wifi:["device_jin_shui_qi_normal","device_jin_shui_qi_select"],
        .AirPurifier_Blue:["device_jin_smallair_normal","device_jin_smallair_select"],
        .AirPurifier_Wifi:["device_jin_bigair_normal","device_jin_bigair_select"],
        .WaterReplenish:["WaterReplenish2","WaterReplenish1_2"],
        .WaterPurifier_Blue:["水芯片配对图标4","水芯片配对图标5"]
    ]
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        bgView.backgroundColor = selected ? UIColor(hexString: "#f3f8fb"):UIColor(hexString: "#e1ebf4")
        connectLabel.textColor = selected ? UIColor(hexString: "#39a7f2"):UIColor(white: 0, alpha: 0.3)
        deviceName.textColor = selected ? UIColor(hexString: "#39a7f2"):UIColor(hexString: "#6d85a0")
        deviceAdressLabel.textColor=selected ? UIColor(hexString: "#39a7f2"):UIColor(white: 0, alpha: 0.3)
        let imgNameStr=imgArr[OznerDeviceType.getType(type: (device?.type)!)]?[selected.hashValue]
        deviceImg.image=UIImage(named: imgNameStr as! String)
        // Configure the view for the selected state
        
    }
    
}
