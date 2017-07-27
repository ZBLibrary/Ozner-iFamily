//
//  uiDatePickerView_EN.swift
//  OZner
//
//  Created by test on 15/12/19.
//  Copyright © 2015年 sunlinlin. All rights reserved.
//

import UIKit

class TapDatePickerView: UIView {

    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var OKButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.backgroundColor=UIColor.white
//        datePicker.delegate = self
        cancelButton.setTitle(loadLanguage("取消"), for: UIControlState())
        OKButton.setTitle(loadLanguage("确定"), for: UIControlState())

    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.removeFromSuperview()
        
    }
    

}
