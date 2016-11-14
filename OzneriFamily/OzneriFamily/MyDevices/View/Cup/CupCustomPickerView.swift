//
//  CupCustomPickerView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupCustomPickerView: UIView,UIPickerViewDelegate {

    @IBAction func cancelClick(_ sender: AnyObject) {
        CancelBack()
    }
    @IBAction func OKClick(_ sender: AnyObject) {
        OKBack(pickerData[currRow])
    }
    @IBOutlet var pickerView: UIPickerView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
           }
    
    var OKBack:((_ valueIndex:Int)->Void)!
    var CancelBack:(()->Void)!
    func setView(valueIndex:Int,OKClick:@escaping ((_ valueIndex:Int)->Void),CancelClick:@escaping (()->Void)){
        OKBack=OKClick
        CancelBack=CancelClick
        pickerView.selectRow(valueIndex, inComponent: 0, animated: true)
    }
    
    var pickerData = [15,30,45,60,120]
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //dynamic delegate methods using pickerviewObj.tag
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])分钟"
    }
    var currRow = 0
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currRow=row
    }
}
