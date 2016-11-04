//
//  FriendZeroBgView.swift
//  OZner
//
//  Created by zhuguangyang on 16/10/13.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class FriendZeroBgView: UIView {

    
    @IBOutlet weak var addFriendLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addFriendLabel.text = loadLanguage("立即添加设备好友")
        
        label1.text = loadLanguage("立即邀请好友")
        label2.text = loadLanguage("一起开启智能生活体验吧!")
        
        
    }
    

}
