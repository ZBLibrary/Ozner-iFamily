//
//  TapSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class TapSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var timeLabel1: UILabel!
    @IBOutlet var timeLabel2: UILabel!
    var currTimeLabel:UILabel!
    
    @IBAction func checkTimeClick(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.keyWindow?.addSubview(pickDateView)
        currTimeLabel = [timeLabel1,timeLabel2][(sender.view?.tag)!]
        pickDateView.datePicker.date = NSDate(string: currTimeLabel.text!, formatString: "HH:mm") as Date
    }
    @IBAction func deleteDeviceClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    var pickDateView:TapDatePickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        self.title = loadLanguage("设置")
        pickDateView=Bundle.main.loadNibNamed("TapDatePickerView", owner: nil, options: nil)?.last as! TapDatePickerView
        pickDateView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        pickDateView.cancelButton.addTarget(self, action: #selector(pickerCancle), for: .touchUpInside)
        pickDateView.OKButton.addTarget(self, action: #selector(pickerOK), for: .touchUpInside)
        nameAndAttrLabel.text=self.getNameAndAttr()
        timeLabel1.text=self.deviceSetting.GetValue(key: "checktime1", defaultValue: "10:00")
        timeLabel2.text=self.deviceSetting.GetValue(key: "checktime2", defaultValue: "18:00")
        // Do any additional setup after loading the view.
    }
    
    func pickerCancle()  {
        pickDateView.removeFromSuperview()
    }
    func pickerOK()  {
        let date = pickDateView.datePicker.date as NSDate
        
        currTimeLabel.text=date.formattedDate(withFormat: "HH:mm")
        self.deviceSetting.SetValue(key: ["checktime1","checktime2"][currTimeLabel.tag], value:  currTimeLabel.text!)
        
        if currTimeLabel.tag==0 {
            self.deviceSetting.SetValue(key: "detectTime1", value: "\(TimeInterval(date.hour()*3600+date.minute()*60))")
        }else{
            self.deviceSetting.SetValue(key: "detectTime2", value: "\(TimeInterval(date.hour()*3600+date.minute()*60))")
        }
        pickDateView.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func nameChange(name:String,attr:String) {
        super.nameChange(name: name, attr: attr)
        nameAndAttrLabel.text="\(name)(\(attr))"
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showAboutDevice" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutTap"]?.stringValue)!, Type: 0)
        }
    }
    

}
