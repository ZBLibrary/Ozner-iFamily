//
//  FriendRecentView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/24.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import IQKeyboardManager

class FriendRecentView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var recentContentLb: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendBtn.layer.cornerRadius = 10
        sendBtn.layer.masksToBounds = true
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.borderColor = UIColor.lightGray.cgColor
        IQKeyboardManager.shared().isEnabled = true
        
        label.text = loadLanguage("回复")
        sendBtn.setTitle(loadLanguage("发送"), for: UIControlState.normal)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
