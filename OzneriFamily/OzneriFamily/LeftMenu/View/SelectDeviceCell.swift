//
//  SelectDeviceCell.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class SelectDeviceCell: UITableViewCell {
  
    
    
    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var typeImg: UIImageView!
    @IBOutlet var typeState: UILabel!
    func setProductInfo(productInfo:JSON)  {
        
        switch OZIOType.getFromString(str: productInfo["IOType"].stringValue) {
        case .Blue://蓝牙
            typeImg.image=UIImage(named: "select_device_3")
            typeState.text = loadLanguage("蓝牙连接")
        case .MxChip,.Ayla,.AylaMxChip://Wifi
            typeImg.image=UIImage(named: "select_device_4")
            typeState.text = loadLanguage("WiFi连接")
        default://Wifi
            typeImg.image=UIImage(named: "")
            typeState.text = loadLanguage("")
            break
        }

        deviceImg.image=UIImage(named: productInfo["pairing"]["pairingImg1"].stringValue)
        deviceName.text=productInfo["Name"].stringValue
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
