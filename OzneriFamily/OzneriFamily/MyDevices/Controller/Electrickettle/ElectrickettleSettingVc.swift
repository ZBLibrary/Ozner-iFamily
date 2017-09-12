//
//  ElectrickettleSettingVcViewController.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/7/19.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/19  下午8:51
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit



class ElectrickettleSettingVc: DeviceSettingController {
    
    //MARK: - Attributes

    @IBOutlet weak var hideViewContranist: NSLayoutConstraint!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var nameLb: GYLabel!
    
    @IBOutlet weak var gySwitch: UISwitch!
    
    @IBOutlet weak var tmepLb: GYLabel!
    @IBOutlet weak var intervalLb: GYLabel!
    @IBOutlet weak var timeLb: GYLabel!
    @IBOutlet weak var timeConstranit: NSLayoutConstraint!
    
    var currentRemindType: RemindStructs!
    var pickDateView:CupCustomPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLb.text=self.getNameAndAttr()
        
        switch OznerManager.instance.currentDevice?.deviceInfo.deviceType ?? "" {
        case "Ozner Cup":
            currentRemindType = RemindStructs(startTime: "remindStart", endTime: "remindEnd", remindInterval: "", timeSender: "", remindNotification: "")
            
            break
        case "NMQ_BLE":
            currentRemindType = RemindStructs(startTime: "ElStartTiemKey", endTime: "ElEndTiemKey", remindInterval: "ELremindInterval", timeSender: "ELTimeSender", remindNotification: "ElectrickettleRemind")
        
            
            break
        case "智能水杯" :
            currentRemindType = RemindStructs(startTime: "SmartCupStartTiemKey", endTime: "SmartCupEndTiemKey", remindInterval: "SmartCupRemindInterval", timeSender: "SmartCupRemindSender", remindNotification: "SmartCupRemind")
            hideView.isHidden = true
            hideViewContranist.constant = 0
            
            break
        default:
            break
        }

        if self.deviceSetting.GetValue(key: currentRemindType.timeSender, defaultValue: "0") == "0" {
            gySwitch.isOn = false
            timeConstranit.constant = 48

        } else {
            gySwitch.isOn = true
            timeConstranit.constant = 115

        }

        let starTime=Int(self.deviceSetting.GetValue(key: currentRemindType.startTime, defaultValue: "\(9*3600)"))!
        let endTime=Int(self.deviceSetting.GetValue(key: currentRemindType.endTime, defaultValue: "\(19*3600)"))!
        timeLb.text="\(starTime/3600):\(starTime%3600/60)-\(endTime/3600):\(endTime%3600/60)"

        let timeSpace = Int(self.deviceSetting.GetValue(key: currentRemindType.remindInterval, defaultValue: "15")) ?? 15
        
        intervalLb.text = "\(timeSpace%60+timeSpace/60)"+(timeSpace>=60 ? loadLanguage("小时"):loadLanguage("分钟"))
        
        let timeSpac1e = self.deviceSetting.GetValue(key: "ELTempSet", defaultValue: "0")
        tmepLb.text = timeSpac1e + "℃"
        
        gySwitch.addTarget(self, action:#selector(ElectrickettleSettingVc.switchChanged(_:)), for: UIControlEvents.valueChanged)
        
        pickDateView=Bundle.main.loadNibNamed("CupCustomPickerView", owner: nil, options: nil)?.last as! CupCustomPickerView
        pickDateView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        pickDateView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        
    }
    
    func switchChanged(_ sender:UISwitch) {
    
        if sender.isOn {
            timeConstranit.constant = 115
            self.deviceSetting.SetValue(key: currentRemindType.timeSender, value: "1")

        } else {
            timeConstranit.constant = 48
            self.deviceSetting.SetValue(key: currentRemindType.timeSender, value: "0")

        }
    }
    
    //MARK: - Override
    
    
    override func nameChange(name:String,attr:String) {
        super.nameChange(name: name, attr: attr)
        nameLb.text="\(name)(\(attr))"
        
    }
    
    //MARK: - Initial Methods
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        self.saveDevice()
        //ElectrickettelAlert
        if gySwitch.isOn {
            
            let repeatInter = Int(self.deviceSetting.GetValue(key: currentRemindType.remindInterval, defaultValue: "15"))
            let starTime = Int(self.deviceSetting.GetValue(key: currentRemindType.startTime, defaultValue: "\(9*3600)"))!/60
            let endTime = Int(self.deviceSetting.GetValue(key: currentRemindType.endTime, defaultValue: "\(9*3600)"))!/60
            
            LocalNotificationHelper.addeDeviceNotice(repeatInter: repeatInter!, starTime: starTime, endTime: endTime,notiInfo:currentRemindType.remindNotification)
        } else {

            LocalNotificationHelper.removeNoticeForKey(key: currentRemindType.remindNotification)
        }
        
        let timeSpace = Int(self.deviceSetting.GetValue(key: "ELTempSet", defaultValue: "0"))!
        
        let device = OznerManager.instance.currentDevice as? Electrickettle_Blue
        
        if device?.connectStatus == .Connected {
        
          _ = device?.setSetting((hotTemp:  device?.settingInfo.hotTime ?? 0, hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: timeSpace, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
        }
        
    }
    
    
    
    
        
    @IBAction func deleteAction(_ sender: Any) {
        
        super.deleteDevice()
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 666:
            
            self.performSegue(withIdentifier: "ElectriketIdentifier", sender: nil)
            break
        case 777:
            
            self.performSegue(withIdentifier: "ElectricketTimeIdener", sender: nil)
            break
        case 999:
            pickDateView.pickerData.removeAll()
            pickDateView.pickerData = [15,30,45,60,120]
            pickDateView.units = "分钟"
            pickDateView.pickerView.reloadAllComponents()
            let timeSpace = Int(self.deviceSetting.GetValue(key: currentRemindType.remindInterval, defaultValue: "15"))!
            let index=[15:0,30:1,45:2,60:3,120:4][timeSpace]
            pickDateView.setView(valueIndex: index!, OKClick: { (value) in
                self.intervalLb.text="\(value%60+value/60)"+(value>=60 ? loadLanguage("小时"):loadLanguage("分钟"))
                self.deviceSetting.SetValue(key: self.currentRemindType.remindInterval, value: "\(value)")

                self.pickDateView.removeFromSuperview()
            }) {
                self.pickDateView.removeFromSuperview()
            }
            UIApplication.shared.keyWindow?.addSubview(pickDateView)
            
            break
        case 1111:
            
            pickDateView.pickerData.removeAll()
            for i in 0...100 {
                
                pickDateView.pickerData.append(i)

            }
            
            pickDateView.units = "℃"
            pickDateView.pickerView.reloadAllComponents()
            let timeSpace = Int(self.deviceSetting.GetValue(key: "ELTempSet", defaultValue: "0"))!

            pickDateView.setView(valueIndex: timeSpace, OKClick: { (value) in
                self.tmepLb.text="\(value)" + "℃"
                self.deviceSetting.SetValue(key: "ELTempSet", value: "\(value)")
                self.pickDateView.removeFromSuperview()
            }) {
                self.pickDateView.removeFromSuperview()
            }
            UIApplication.shared.keyWindow?.addSubview(pickDateView)

            break
        default:
            break
        }
        
    }
    //MARK: - Delegate
    
    
    //MARK: - Target Methods
    
    
    //MARK: - Notification Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    
    //MARK: - Privater Methods
    
    
    //MARK: - Setter Getter Methods
    
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
         if segue.identifier=="ElectricketTimeIdener" {
            
            let VC=segue.destination as!  CupSetDrinkTimeController
            VC.currSetting = self.deviceSetting
        }
        
    }
 

}
