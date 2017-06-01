//
//  SelectDeviceCell.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
//wifi产品一定要带WIFI字母
enum OznerDeviceType:String {
    
    case Water_Bluetooth="Ozner RO"
    case Cup="CP001"
    case Tap="SC001"
    case TDSPan="SCP001"
    case Water_Wifi="MXCHIP_HAOZE_Water"
    case Air_Blue="FLT001"
    case Air_Wifi="FOG_HAOZE_AIR"
    case WaterReplenish="BSY001"
    
    case Water_Wifi_JZYA1XBA8CSFFSF="JZY-A1XB-A8_CSF&FSF"
    case Water_Wifi_JZYA1XBA8DRF="JZY-A1XB-A8_DRF"
    case Water_Wifi_JZYA1XBLG_DRF="JZY-A1XB-LG_DRF"
    
    //case Water_Wifi_Ayla="Water_Wifi_Ayla"
    //case Air_Wifi_Ayla="Air_Wifi_Ayla"
  
    func Name()->String {
        return [loadLanguage("水芯片净水器"),loadLanguage("智能水杯"),loadLanguage("水探头"),loadLanguage("智能检测笔"),loadLanguage("净水器"),loadLanguage("台式空净"),loadLanguage("立式空净"),loadLanguage("补水仪"),loadLanguage("净水器"),loadLanguage("净水器"),loadLanguage("净水器")][self.hashValue]
    }
    func Name_En()->String {
        return ["WaterPurfier","Cup","Tap","TDSPan","WaterPurfier","Air_Blue","Air_Wifi","WaterReplenish","JZY-A1XB-A8_CSF&FSF","JZY-A1XB-A8_DRF","JZY-A1XB-LG_DRF"][self.hashValue]
    }
    static func getType(type:String) -> OznerDeviceType {
        switch type {
        case "580c2783":
           return OznerDeviceType.Air_Wifi
        case "16a21bd6":
            return OznerDeviceType.Water_Wifi
        default:
          return OznerDeviceType(rawValue: type)!
        }
    }
}

class SelectDeviceCell: UITableViewCell {
  
    
    
    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var typeImg: UIImageView!
    @IBOutlet var typeState: UILabel!
    func setDeviceType(deviceType:OznerDeviceType)  {
        
        switch deviceType {
        case .Cup,.Tap,.TDSPan,.Air_Blue,.WaterReplenish,.Water_Bluetooth://蓝牙
            typeImg.image=UIImage(named: "select_device_3")
            typeState.text = loadLanguage("蓝牙连接")
            break
        default://Wifi
            typeImg.image=UIImage(named: "select_device_4")
            typeState.text = loadLanguage("Wifi连接")
            break
        }

        deviceImg.image=UIImage(named: ["水芯片配对图标1","select_device_0","select_device_1","TDSPAN_ICON","select_device_2","select_device_3zb","select_device_4zb","WaterReplenish1_1"][deviceType.hashValue])
        deviceName.text=deviceType.Name()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deviceImg.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
