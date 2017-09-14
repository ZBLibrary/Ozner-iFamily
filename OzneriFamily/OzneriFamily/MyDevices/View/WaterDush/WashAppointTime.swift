//
//  WashAppointTime.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/12.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class WashAppointTime: UIView,UIPickerViewDelegate,UIPickerViewDataSource{

    var callBack:((_ Appoint:(model:Int,time:Int)?)->Void)?
    @IBOutlet var pickerView: UIPickerView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
 
    var setTime = 0{
        didSet{
            pickerView.selectRow(setTime/60, inComponent: 1, animated: true)
            pickerView.selectRow(setTime%60, inComponent: 2, animated: true)
        }
    }
    var setModel = 0{
        didSet{
            pickerView.selectRow(setModel-1, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        //0,1
        if sender.tag==0 {//取消
            callBack!(nil)
        }else{//确定
            callBack!((appointValue.model,appointValue.timeM+appointValue.timeH*60))
        }
    }
    let modelItem=["节能洗","强劲洗","日常洗","快速洗","奶瓶洗","瓜果洗","自清洁"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return modelItem.count
        case 1:
            return 24
        default:
            return 60
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return modelItem[row]
        default:
            return row<10 ? "0\(row)":"\(row)"
        }
    }
    var appointValue:(model:Int,timeH:Int,timeM:Int) = (0,0,0)
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            return appointValue.model=row+1
        case 1:
            return appointValue.timeH=row
        default:
            return appointValue.timeM=row
        }
    }
}
