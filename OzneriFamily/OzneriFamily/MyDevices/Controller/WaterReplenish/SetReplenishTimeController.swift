//
//  SetReplenishTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SetReplenishTimeController: UIViewController {

    var currSetting:DeviceSetting!
    
    @IBAction func saveClick(_ sender: AnyObject) {
        currSetting.put("checktime1", value: timeLabel1.text!)
        currSetting.put("checktime2", value: timeLabel2.text!)
        currSetting.put("checktime3", value: timeLabel3.text!)
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
        timeImg1.isHidden = sender.view?.tag != 0
        timeImg2.isHidden = sender.view?.tag != 1
        timeImg3.isHidden = sender.view?.tag != 2
        currTimeLabel=[timeLabel1,timeLabel2,timeLabel3][(sender.view?.tag)!]
        datePicker.date=NSDate(string: currTimeLabel.text!, formatString: "hh:mm") as Date
    }
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker, forEvent event: UIEvent) {
        currTimeLabel.text=(sender.date as NSDate).formattedDate(withFormat: "hh:mm")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel1.text = currSetting.get("checktime1", default: "08:00") as! String?
        timeLabel2.text = currSetting.get("checktime2", default: "14:30") as! String?
        timeLabel3.text = currSetting.get("checktime3", default: "21:00") as! String?
         datePicker.date=NSDate(string: timeLabel1.text!, formatString: "hh:mm") as Date
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
