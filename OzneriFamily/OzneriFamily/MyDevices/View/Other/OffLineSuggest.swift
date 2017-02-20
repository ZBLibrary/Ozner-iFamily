//
//  OffLineSuggest.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/12/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class OffLineSuggest: UIView {

    @IBOutlet var textView: UITextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func IKnowClick(_ sender: AnyObject) {
        callBack()
    }
    var callBack:(()->Void)!
    func updateView(IsAir:Bool,callback:@escaping (()->Void)){
        callBack=callback
        if IsAir {
            textView.text="请尝试以下方式：\n1.检查您的设备是否通电\n\n2.请检测您的网络是否通畅\n\n3.同时按下电源和风速，WIFI指示灯闪烁，重新配对\n\n4.如仍无法连接设备，请在设置中删除此设备，重新配对"
        }else{
            textView.text="请尝试以下方式：\n1.检查您的设备是否通电\n\n2.请检测您的网络是否通畅\n\n3.如仍无法连接设备，请在设置中删除此设备，重新配对"
        }
    }
}
