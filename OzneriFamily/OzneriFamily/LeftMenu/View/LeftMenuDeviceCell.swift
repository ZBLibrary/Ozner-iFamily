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

    var currenttag:Int = -100
    var device:OznerBaseDevice! {
        didSet{
            deviceName.text=device.settings.name
            deviceAdressLabel.text=device.settings.GetValue(key: AttributeOfDevice, defaultValue: loadLanguage("我的家庭"))
            connectLabel.text = device.connectStatus == .Connected ? loadLanguage("已连接"):loadLanguage("已断开")
            
            switch ProductInfo.getIOTypeFromProductID(productID: device.deviceInfo.productID) {
            case .Blue:
                connectImg.image=UIImage(named: "device_icon_blutooth")//蓝牙图标
                
            case .MxChip,.Ayla,.AylaMxChip:
                connectImg.image=UIImage(named: "device_icon_wifi")//Wifi图标
                
            default:
                connectImg.image=UIImage(named: "")//无图标
                
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

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bgView.backgroundColor = selected ? UIColor(hexString: "#f3f8fb"):UIColor(hexString: "#e1ebf4")
        connectLabel.textColor = selected ? UIColor(hexString: "#39a7f2"):UIColor(white: 0, alpha: 0.3)
        deviceName.textColor = selected ? UIColor(hexString: "#39a7f2"):UIColor(hexString: "#6d85a0")
        deviceAdressLabel.textColor=selected ? UIColor(hexString: "#39a7f2"):UIColor(white: 0, alpha: 0.3)
        let productInfo=ProductInfo.getProductInfoFromProductID(productID: device.deviceInfo.productID)
        let imgNameStr=[productInfo?["pairing"]["pairingImg4"].stringValue,productInfo?["pairing"]["pairingImg5"].stringValue][selected.hashValue]
        deviceImg.image=UIImage(named: imgNameStr!)
        // Configure the view for the selected state
        
    }
    
}
