//
//  NewAirSetTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/25.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class NewAirSetTimeController: BaseViewController {
    
    var appointTime:(onOffType:Int,onEveryDay:Int,offEveryDay:Int,offOnce:Int)=(0,0,0,0){
        didSet{
            if segmentButton.selectedSegmentIndex==0 {//单次
                containerHeight.constant=0
                let value = appointTime.offOnce
                PowerOffDatePicker.setDate(NSDate.init(string: "\(value/60):\(value%60)", formatString: "hh:mm", timeZone: TimeZone.current) as Date, animated: true)
                let isSet=appointTime.onOffType%2>0
                PowerOffButton.setTitleColor(isSet ? UIColor.gray:UIColor.blue, for: .normal)
                PowerOffDatePicker.isEnabled=isSet
            }else{//每天
                containerHeight.constant=150
                let offValue = appointTime.offEveryDay
                PowerOffDatePicker.setDate(NSDate.init(string: "\(offValue/60):\(offValue%60)", formatString: "hh:mm", timeZone: TimeZone.current) as Date, animated: true)
                let onValue = appointTime.onEveryDay
                PowerOnDatePicker.setDate(NSDate.init(string: "\(onValue/60):\(onValue%60)", formatString: "hh:mm", timeZone: TimeZone.current) as Date, animated: true)
                
                
                let onIsSet = appointTime.onOffType/2%2>0//每天开机
                let offIsSet = appointTime.onOffType/4%2>0//每天关机
                PowerOffButton.setTitleColor(offIsSet ? UIColor.gray:UIColor.blue, for: .normal)
                PowerOffDatePicker.isEnabled=offIsSet
                PowerOnButton.setTitleColor(onIsSet ? UIColor.gray:UIColor.blue, for: .normal)
                PowerOnDatePicker.isEnabled=onIsSet
            }
        }
    }
    

    @IBOutlet var segmentButton: UISegmentedControl!
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        let tmpvalue = appointTime
        appointTime=tmpvalue
        
    }
    //PowerOff
    @IBOutlet var containerHeight: NSLayoutConstraint!
    @IBOutlet var PowerOffButton: UIButton!
    @IBAction func PowerOffClick(_ sender: UIButton) {
        var tmpValue=appointTime.onOffType
        if segmentButton.selectedSegmentIndex==0 {
            tmpValue = (tmpValue%2>0 ? -1:1)
        }else{
            tmpValue=(tmpValue/4%2>0 ? -4:4)
        }
        appointTime.onOffType=appointTime.onOffType+tmpValue
    }
    @IBOutlet var PowerOffDatePicker: UIDatePicker!
    @IBAction func PowerOffDateClick(_ sender: UIDatePicker) {
        let tmpDate = sender.date as NSDate
        let tmpValue = tmpDate.hour()*60+tmpDate.minute()
        if segmentButton.selectedSegmentIndex==0 {
            appointTime.offOnce=tmpValue
        }else{
            appointTime.offEveryDay=tmpValue
        }
        
    }
    @IBAction func SaveClick(_ sender: Any) {
        (OznerManager.instance.currentDevice as! NewTrendAir_Wifi).setAppoint(onOffType: appointTime.onOffType, onEveryDay: appointTime.onEveryDay, offEveryDay: appointTime.offEveryDay, offOnce: appointTime.offOnce) { (error) in
            showMSG(msg: (error as! NSError).domain)
        }
    }
    //PowerOn
    @IBOutlet var PowerOnButton: UIButton!
    @IBAction func PowerOnClick(_ sender: UIButton) {
        var tmpValue=appointTime.onOffType
        tmpValue=(tmpValue/2%2>0 ? -2:2)
        appointTime.onOffType=appointTime.onOffType+tmpValue
    }
    
    @IBOutlet var PowerOnDatePicker: UIDatePicker!
    @IBAction func PowerOnDateClick(_ sender: UIDatePicker) {
        let tmpDate = sender.date as NSDate
        appointTime.onEveryDay=tmpDate.hour()*60+tmpDate.minute()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="预约设置"
        let device=OznerManager.instance.currentDevice as! NewTrendAir_Wifi
        appointTime=device.appointTime
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMSG(msg:String) {
        let alertView=SCLAlertView()
        _=alertView.showTitle("", subTitle: msg, duration: 2.0, completeText: "ok", style: SCLAlertViewStyle.notice)
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
