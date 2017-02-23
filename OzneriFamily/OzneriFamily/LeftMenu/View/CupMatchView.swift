//
//  CupMatchView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/14.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupMatchView: UIView {
    
    @IBOutlet weak var myCup: UILabel!
    
    @IBOutlet weak var cupNameLb: UITextField!
    @IBOutlet weak var sucessBtn: UIButton!

    @IBOutlet weak var suggestLb: UILabel!
    @IBOutlet weak var weightLb: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myCup.text = loadLanguage("我的水杯")
        weightLb.placeholder = loadLanguage("输入体重")
        suggestLb.text = loadLanguage("填写体重获得更健康的饮水量建议")
        sucessBtn.setTitle(loadLanguage("完成"), for: UIControlState.normal)
        cupNameLb.placeholder = loadLanguage("输入智能杯名称")
        weightLb.keyboardType = .numberPad
    }
}
