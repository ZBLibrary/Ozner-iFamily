//
//  SmallAriClearView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/18.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SmallAriClearView: UIView {

    
    @IBOutlet weak var placeLb: UILabel!
    @IBOutlet weak var nameLb: UITextField!
    @IBOutlet weak var successbtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        nameLb.placeholder = loadLanguage("台式空净名称")
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
