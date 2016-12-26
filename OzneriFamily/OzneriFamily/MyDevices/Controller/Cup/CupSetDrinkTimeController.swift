//
//  CupSetDrinkTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupSetDrinkTimeController: BaseViewController {

    var currSetting:CupSettings!
    @IBAction func saveClick(_ sender: AnyObject) {
        let date1 = NSDate(string: starTimeLabel.text!, formatString: "hh:mm")
        let date2 = NSDate(string: endTimeLabel.text!, formatString: "hh:mm")
        let time1 = Int((date1?.hour())!)*3600+Int((date1?.minute())!)*60
        let time2 = Int((date2?.hour())!)*3600+Int((date2?.minute())!)*60
        currSetting.remindStart=uint(time1)
        currSetting.remindEnd=uint(time2)
       let vcs=self.navigationController?.viewControllers
        let vc=vcs?[(vcs?.count)!-2] as! CupSettingController
        vc.drinkRemaindTimeLabel.text=starTimeLabel.text!+"-"+endTimeLabel.text!
        _=self.navigationController?.popViewController(animated: true)
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
        datePicker.date=NSDate(string: currTimeLabel.text!, formatString: "hh:mm") as Date
    }
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        currTimeLabel.text=(sender.date as NSDate).formattedDate(withFormat: "hh:mm")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let starH=Int(currSetting.remindStart)/3600
        let starM=(Int(currSetting.remindStart)%3600)/60
        starTimeLabel.text = (starH<10 ? "0\(starH)":"\(starH)")+":"+(starM<10 ? "0\(starM)":"\(starM)")
        let endH=Int(currSetting.remindEnd)/3600
        let endM=(Int(currSetting.remindEnd)%3600)/60
        endTimeLabel.text = (endH<10 ? "0\(endH)":"\(endH)")+":"+(endM<10 ? "0\(endM)":"\(endM)")
        datePicker.date=NSDate(string: starTimeLabel.text!, formatString: "hh:mm") as Date
         currTimeLabel=starTimeLabel
        // Do any additional setup after loading the view.
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
