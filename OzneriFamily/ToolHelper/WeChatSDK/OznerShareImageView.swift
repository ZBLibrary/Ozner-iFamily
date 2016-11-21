//
//  ShareView_zb.swift
//  OZner
//
//  Created by test on 16/1/9.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class OznerShareImageView: UIView {

    @IBOutlet var share_rank: UILabel!
    @IBOutlet var share_title: UILabel!
    @IBOutlet var share_value: UILabel!
    @IBOutlet var share_beat: UILabel!
    @IBOutlet var share_stateImage: UIImageView!
    @IBOutlet var share_OwnerImage: UIImageView!
    @IBOutlet var share_OwnerName: UILabel!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        share_OwnerImage.layer.cornerRadius=38
        share_OwnerImage.layer.borderColor=UIColor.white.cgColor
        share_OwnerImage.layer.borderWidth=1
        // Drawing code
    }
    
    

}
