//
//  EquidsCollectionViewCell.swift
//  My
//
//  Created by test on 15/11/24.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class EquidsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var equipNameLabel: UILabel!
    @IBOutlet var equipImage: UIImageView!
    @IBOutlet var right_up: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
         equipNameLabel.text = loadLanguage("智能水杯");
         right_up.setTitle("", for: UIControlState.normal)
        right_up.setTitleColor(UIColor.white, for: UIControlState.normal)
        
    
    
    }
    func update(device:OznerDevice!)
    {
        equipNameLabel.text = loadLanguage(OznerDeviceType.getType(type: device.type).Name())
        var imgwhich=""
        switch OznerDeviceType.getType(type: device.type) {
        case OznerDeviceType.Cup:
            imgwhich+="My_cup"
        case .Tap:
            imgwhich+="My_tantou"
        case .TDSPan:
            imgwhich+="My_tantou"
        case .Water_Wifi:
            imgwhich+="My_shuiji"
        case .Air_Blue:
            imgwhich+="My_kongjing_small"
        case .Air_Wifi,.Water_Wifi_JZYA1XBA8CSFFSF,.Water_Wifi_JZYA1XBA8DRF,.Water_Wifi_JZYA1XBLG_DRF:
            imgwhich+="My_kongjing_big"
        case .WaterReplenish:
            imgwhich+="My_bsy"
        case .Water_Bluetooth:
            imgwhich+="My_shuiji"

        }
        equipImage.image=UIImage(named: imgwhich)
    }
}
