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
    func update(device:OznerBaseDevice!)
    {
        
        let deviceClass=ProductInfo.getDeviceClassFromProductID(productID: device.deviceInfo.productID)
        equipNameLabel.text = loadLanguage(ProductInfo.getNameFromProductID(productID: device.deviceInfo.productID))
        var imgwhich=""
        switch deviceClass {
        case .Cup:
            imgwhich+="My_cup"
        case .Tap:
            imgwhich+="My_tantou"
        case .TDSPan:
            imgwhich+="My_tantou"
        case .WaterPurifier_Wifi:
            imgwhich+="My_shuiji"
        case .AirPurifier_Blue:
            imgwhich+="My_kongjing_small"
        case .AirPurifier_Wifi:
            imgwhich+="My_kongjing_big"
        case .WaterReplenish:
            imgwhich+="My_bsy"
        case .WaterPurifier_Blue:
            imgwhich+="My_shuiji"
        case .Electrickettle_Blue:
            imgwhich += "icon_cup_on"

        }
        equipImage.image=UIImage(named: imgwhich)
    }
}
