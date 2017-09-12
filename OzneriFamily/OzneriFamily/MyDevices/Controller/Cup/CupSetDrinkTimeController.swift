//
//  CupSetDrinkTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

//var 

struct RemindStructs {
    
    var startTime:String = ""
    var endTime:String = ""
    var remindInterval = ""
    var timeSender = ""
    var remindNotification = ""
}

class CupSetDrinkTimeController: BaseViewController {

    var currSetting:BaseDeviceSetting!
    var currentRemindType:RemindStructs!
    @IBAction func saveClick(_ sender: AnyObject) {
        let date1 = NSDate(string: starTimeLabel.text!, formatString: "HH:mm")
        let date2 = NSDate(string: endTimeLabel.text!, formatString: "HH:mm")
        let time1 = Int((date1?.hour())!)*3600+Int((date1?.minute())!)*60
        let time2 = Int((date2?.hour())!)*3600+Int((date2?.minute())!)*60
        
        
        //解决iOS 10.1.1 时间处理的Bug
//        let arrDate1 = starTimeLabel.text!.components(separatedBy: ":")
//        let arrDate2 = endTimeLabel.text!.components(separatedBy: ":")
//        let time1 = Int(arrDate1[0])!*3600+Int(arrDate1[1])!*60
//        let time2 = Int(arrDate2[0])!*3600+Int(arrDate2[1])!*60
        currSetting.SetValue(key: currentRemindType.startTime, value: "\(uint(time1))")
        currSetting.SetValue(key: currentRemindType.endTime, value: "\(uint(time2))")
        if OznerManager.instance.currentDevice?.deviceInfo.deviceType == "Ozner Cup" {

            let vcs=self.navigationController?.viewControllers
            let vc=vcs?[(vcs?.count)!-2] as! CupSettingController
            vc.drinkRemaindTimeLabel.text=starTimeLabel.text!+"-"+endTimeLabel.text!
            _=self.navigationController?.popViewController(animated: true)
            
        } else {
            
            let vcs=self.navigationController?.viewControllers
            let vc=vcs?[(vcs?.count)!-2] as! ElectrickettleSettingVc
            vc.timeLb.text=starTimeLabel.text!+"-"+endTimeLabel.text!
            _=self.navigationController?.popViewController(animated: true)

        }

    }
    @IBOutlet var starTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var starImg: UIImageView!
    @IBOutlet var endImg: UIImageView!
    var currTimeLabel:UILabel!
    @IBAction func tapClick(_ sender: UITapGestureRecognizer) {
        starImg.isHidden = sender.view?.tag != 0
        endImg.isHidden = sender.view?.tag != 1
        currTimeLabel=[starTimeLabel,endTimeLabel][(sender.view?.tag)!]

        datePicker.date=NSDate(string: currTimeLabel.text!, formatString: "HH:mm") as Date
    }
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        currTimeLabel.text=(sender.date as NSDate).formattedDate(withFormat: "HH:mm")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch OznerManager.instance.currentDevice?.deviceInfo.deviceType ?? "" {
        case "Ozner Cup":
            currentRemindType = RemindStructs(startTime: "remindStart", endTime: "remindEnd", remindInterval: "", timeSender: "", remindNotification: "")

            break
        case "NMQ_BLE":
            currentRemindType = RemindStructs(startTime: "ElStartTiemKey", endTime: "ElEndTiemKey", remindInterval: "", timeSender: "", remindNotification: "")

            break
        case "智能水杯" :
            currentRemindType = RemindStructs(startTime: "SmartCupStartTiemKey", endTime: "SmartCupEndTiemKey", remindInterval: "SmartCupRemindInterval", timeSender: "SmartCupRemindSender", remindNotification: "SmartCupRemind")

            break
        default:
            break
        }
        
        let starH=Int(currSetting.GetValue(key: currentRemindType.startTime, defaultValue: "\(9*3600)"))!/3600
        let starM=Int(currSetting.GetValue(key: currentRemindType.startTime, defaultValue: "\(9*3600)"))!%3600/60
        starTimeLabel.text = (starH<10 ? "0\(starH)":"\(starH)")+":"+(starM<10 ? "0\(starM)":"\(starM)")
        let endH=Int(currSetting.GetValue(key: currentRemindType.endTime, defaultValue: "\(19*3600)"))!/3600
        let endM=Int(currSetting.GetValue(key: currentRemindType.endTime, defaultValue: "\(19*3600)"))!%3600/60
        endTimeLabel.text = (endH<10 ? "0\(endH)":"\(endH)")+":"+(endM<10 ? "0\(endM)":"\(endM)")

        datePicker.date=NSDate(string: starTimeLabel.text!, formatString: "HH:mm") as Date
        currTimeLabel=starTimeLabel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
