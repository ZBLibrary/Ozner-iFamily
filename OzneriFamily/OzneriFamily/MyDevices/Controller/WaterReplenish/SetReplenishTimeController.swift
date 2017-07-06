//
//  SetReplenishTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SetReplenishTimeController: BaseViewController {

    var currSetting:BaseDeviceSetting!
    //带+号表示选中状态，否则，未选中状态
    @IBAction func saveClick(_ sender: AnyObject) {
        currSetting.SetValue(key: "checktime1", value: timeLabel1.text!+(timeImg1.isHidden ? "":"+"))
        currSetting.SetValue(key: "checktime1", value: timeLabel2.text!+(timeImg2.isHidden ? "":"+"))
        currSetting.SetValue(key: "checktime3", value: timeLabel3.text!+(timeImg3.isHidden ? "":"+"))

        for i in 0...2 {
            LocalNotificationHelper.removeNoticeForKey(key: "BuShuiYi"+["checktime1","checktime2","checktime3"][i])
            if !([timeImg1,timeImg2,timeImg3][i].isHidden) {
                let tmpLabel = [timeLabel1,timeLabel2,timeLabel3][i] as UILabel
                
                let date = NSDate(string: tmpLabel.text!, formatString: "HH:mm")
                LocalNotificationHelper.addNoticeForKeyEveryDay(key: "BuShuiYi"+["checktime1","checktime2","checktime3"][i], date: date as! Date, alertBody: loadLanguage("您的补水时间已到，请及时补充水分！"))
            }
        }
        
        
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var timeLabel1: UILabel!
    @IBOutlet var timeLabel2: UILabel!
    @IBOutlet var timeLabel3: UILabel!
    @IBOutlet var timeImg1: UIImageView!
    @IBOutlet var timeImg2: UIImageView!
    @IBOutlet var timeImg3: UIImageView!
    var currTimeLabel:UILabel!
    
    @IBAction func timeTapClick(_ sender: UITapGestureRecognizer) {
        let currTimeImg=[timeImg1,timeImg2,timeImg3][(sender.view?.tag)!]
        currTimeImg?.isHidden = !(currTimeImg?.isHidden)!
        datePicker.isHidden = (currTimeImg?.isHidden)!
        
        currTimeLabel=[timeLabel1,timeLabel2,timeLabel3][(sender.view?.tag)!]
        datePicker.date=NSDate(string: currTimeLabel.text!, formatString: "HH:mm") as Date
    }
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker, forEvent event: UIEvent) {
        currTimeLabel.text=(sender.date as NSDate).formattedDate(withFormat: "HH:mm")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loadLanguage("补水提醒时间")
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        
        //带+号表示选中状态，否则，未选中状态
        let checktime1 = currSetting.GetValue(key: "checktime1", defaultValue: "08:00")
        timeImg1.isHidden = !checktime1.contains("+")
        timeLabel1.text = checktime1.replacingOccurrences(of: "+", with: "")
        
        let checktime2 = currSetting.GetValue(key: "checktime2", defaultValue: "14:30")
        timeImg2.isHidden = !checktime2.contains("+")
        timeLabel2.text = checktime2.replacingOccurrences(of: "+", with: "")
        
        let checktime3 = currSetting.GetValue(key: "checktime3", defaultValue: "21:00")
        timeImg3.isHidden = !checktime3.contains("+")
        timeLabel3.text = checktime3.replacingOccurrences(of: "+", with: "")
        
        datePicker.date=NSDate(string: timeLabel1.text!, formatString: "HH:mm") as Date
        currTimeLabel=timeLabel1
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
