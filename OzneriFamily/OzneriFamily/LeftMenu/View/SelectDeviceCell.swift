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
    case Cup="CP001"
    case Tap="SC001"
    case TDSPan="SCP001"//有问题，待测
    case Water_Wifi="MXCHIP_HAOZE_Water"
    case Air_Blue="FLT001"
    case Air_Wifi="FOG_HAOZE_AIR"
 
    case WaterReplenish="BSY001"
    //case Water_Wifi_Ayla="Water_Wifi_Ayla"
    //case Air_Wifi_Ayla="Air_Wifi_Ayla"
    func Name()->String {
        return ["智能水杯","水探头","智能检测笔","净水器","台式空净","立式空净","补水仪"][self.hashValue]
    }
    func Name_En()->String {
        return ["Cup","Tap","TDSPan","WaterPurfier","Air_Blue","Air_Wifi","WaterReplenish"][self.hashValue]
    }
    
}

class SelectDeviceCell: UITableViewCell {
  
    
    
    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var typeImg: UIImageView!
    @IBOutlet var typeState: UILabel!
    func setDeviceType(deviceType:OznerDeviceType)  {
        
        switch deviceType {
        case .Cup,.Tap,.TDSPan,.Air_Blue,.WaterReplenish://蓝牙
            typeImg.image=UIImage(named: "select_device_3")
            typeState.text = "蓝牙连接"
            break
        default://Wifi
            typeImg.image=UIImage(named: "select_device_4")
            typeState.text = "Wifi连接"
            break
        }

        deviceImg.image=UIImage(named: ["select_device_0","select_device_1","TDSPAN_ICON","select_device_2","select_device_3zb","select_device_4zb","WaterReplenish1_1"][deviceType.hashValue])
        deviceName.text=deviceType.Name()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
