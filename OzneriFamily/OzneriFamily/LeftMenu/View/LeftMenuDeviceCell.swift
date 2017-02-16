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

    var device:OznerDevice! {
        didSet{
            
            
            deviceName.text=device.settings.name
            deviceAdressLabel.text=device.settings.get(AttributeOfDevice, default: "我的家庭") as! String?
            switch OznerDeviceType.getType(type: (device?.type)!) {
            case .Cup,.Tap,.TDSPan,.Air_Blue,.WaterReplenish,.Water_Bluetooth:
                connectLabel.text=["连接中","已断开","已连接"][Int(device.connectStatus().rawValue)]
                connectImg.image=UIImage(named: "device_icon_blutooth")//蓝牙图标
                break
            case .Air_Wifi:
                connectImg.image=UIImage(named: "device_icon_wifi")//Wifi图标
                connectLabel.text=(device as! AirPurifier_MxChip).isOffline ? "已断开" : "已连接"
                break
            case .Water_Wifi:
                connectImg.image=UIImage(named: "device_icon_wifi")//Wifi图标
                connectLabel.text=(device as! WaterPurifier).isOffline ? "已断开" : "已连接"
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
    private let imgArr:[OznerDeviceType:NSArray]=[
        OznerDeviceType.Cup:["device_cup_normal_state","deveice_cup_select_state"],
        OznerDeviceType.Tap:["device_tan_tou_noamrl_state","device_tan_tou_select_state"],
        OznerDeviceType.TDSPan:["device_TDSPAN_noamrl_state","device_tdspan_select_state"],
        OznerDeviceType.Water_Wifi:["device_jin_shui_qi_normal","device_jin_shui_qi_select"],
        OznerDeviceType.Air_Blue:["device_jin_smallair_normal","device_jin_smallair_select"],
        OznerDeviceType.Air_Wifi:["device_jin_bigair_normal","device_jin_bigair_select"],
        OznerDeviceType.WaterReplenish:["WaterReplenish2","WaterReplenish1_2"],
        OznerDeviceType.Water_Bluetooth:["device_jin_shui_qi_normal","device_jin_shui_qi_select"]
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
