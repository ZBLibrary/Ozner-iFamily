//
//  MyInfoHeadView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyInfoHeadView: UIView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var leaveLb: UILabel!
    
    @IBOutlet weak var MyIfoLb: UILabel!
    @IBOutlet weak var infoNumLb: UILabel!
    @IBOutlet weak var moneyLb: UILabel!
    
    @IBOutlet weak var MymoneyLb: UILabel!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var myMoneyBtn: UIButton!
    @IBOutlet weak var myDeviceNumBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MyIfoLb.text = loadLanguage("我的设备")
        MymoneyLb.text = loadLanguage("我的小金库")
        loginBtn.setTitle(loadLanguage("点击登录"), for: UIControlState.normal)
        loginBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        
        
        
    }
    
    
    
}
