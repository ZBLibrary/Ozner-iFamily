//
//  WaterRefeishView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/18.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterRefeishView: UIView {

    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var segementSex: UISegmentedControl!
    
    @IBOutlet weak var sucessAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeName.placeholder = loadLanguage("补水仪名称")
        segementSex.setTitle(loadLanguage("女"), forSegmentAt: 0)
         segementSex.setTitle(loadLanguage("男"), forSegmentAt: 1)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
