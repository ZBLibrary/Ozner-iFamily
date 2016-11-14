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
   
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        datePicker.backgroundColor=UIColor.white
        cancelButton.setTitle(loadLanguage("取消"), for: UIControlState())
        OKButton.setTitle(loadLanguage("确定"), for: UIControlState())
         
    }
    

}
