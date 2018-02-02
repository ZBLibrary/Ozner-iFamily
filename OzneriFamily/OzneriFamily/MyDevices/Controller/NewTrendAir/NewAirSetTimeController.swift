//
//  NewAirSetTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/25.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit
import PGDatePicker

class NewAirSetTimeController: BaseViewController {
    
    var appointTime:(onState:Bool,onWeekDay:Int,onTimeM:Int,onTimeH:Int,offState:Bool,offWeekDay:Int,offTimeM:Int,offTimeH:Int)=(false,0,0,0,false,0,0,0){
        didSet{
            powerOnSwitch.isOn = appointTime.onState
            viewOnContainHeight.constant = powerOnSwitch.isOn ? 80:0
            powerOffSwitch.isOn = appointTime.offState
            viewOffContainHeight.constant = powerOffSwitch.isOn ? 80:0
            
            timeOnText.text="\(appointTime.onTimeH):\(appointTime.onTimeM)"
            timeOffText.text="\(appointTime.offTimeH):\(appointTime.offTimeM)"
            var onWeekStr = ""
            var offWeekStr = ""
            for i in 0...6 {
                if Int(UInt8(appointTime.onWeekDay)>>i)%2 == 1{
                    onWeekStr = onWeekStr+["日  ","一  ","二  ","三  ","四  ","五  ","六  "][i]
                }
                if Int(UInt8(appointTime.offWeekDay)>>i)%2 == 1{
                    offWeekStr=offWeekStr+["日  ","一  ","二  ","三  ","四  ","五  ","六  "][i]
                }
            }
            weakOnText.text=onWeekStr
            weakOffText.text=offWeekStr
        }
    }
    @IBOutlet var powerOnSwitch: UISwitch!
    @IBOutlet var timeOnText: UILabel!
    @IBOutlet var weakOnText: UILabel!
    @IBAction func powerOnSwitchChange(_ sender: Any) {
        appointTime.onState=powerOnSwitch.isOn
    }
    @IBAction func powerOnTimeClick(_ sender: Any) {
        datePickerIsOn=true
        presentDatePicker()
    }
    @IBAction func poweronWeakClick(_ sender: Any) {
        weekCallBack = { value in
            print("开机设置时间\(value)")
             self.appointTime.onWeekDay=value
        }
        self.performSegue(withIdentifier: "showWeekVC", sender: ["call":weekCallBack,"week":appointTime.onWeekDay])
    }
    @IBOutlet var viewOnContainHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet var powerOffSwitch: UISwitch!
    @IBOutlet var timeOffText: UILabel!
    @IBOutlet var weakOffText: UILabel!
    @IBAction func powerOffSwitchChange(_ sender: UISwitch) {
        appointTime.offState=powerOffSwitch.isOn
    }
    @IBAction func powerOffTimeClick(_ sender: Any) {
        datePickerIsOn=false
        presentDatePicker()
    }
    var weekCallBack:((Int)->Void)!
    @IBAction func poweroffWeakClick(_ sender: Any) {
        weekCallBack = { value in
            print("关机设置时间\(value)")
            self.appointTime.offWeekDay=value
        }
        self.performSegue(withIdentifier: "showWeekVC", sender: ["call":weekCallBack,"week":appointTime.offWeekDay])
    }
    @IBOutlet var viewOffContainHeight: NSLayoutConstraint!
    

   
    @IBAction func SaveClick(_ sender: Any) {
        (OznerManager.instance.currentDevice as! NewTrendAir_Wifi).setAppoint(onState: appointTime.onState, onWeekDay: appointTime.onWeekDay, onTimeM: appointTime.onTimeM, onTimeH: appointTime.onTimeH, offState: appointTime.offState, offWeekDay: appointTime.offWeekDay, offTimeM: appointTime.offTimeM, offTimeH: appointTime.offTimeH) { (error) in
            showMSG(msg: (error! as NSError).domain)
        }
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
    var datePickerIsOn:Bool=true//true是开机 DatePicker，false 是关机
    func presentDatePicker() {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .time
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showWeekVC" {
            let vc = segue.destination as! SetNewWeekViewController
            vc.callblock=(sender as! [String:Any])["call"] as! ((Int)->Void)
            vc.weekValue=(sender as! [String:Any])["week"] as! Int
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
extension NewAirSetTimeController: PGDatePickerDelegate {
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        print("dateComponents = ", dateComponents)
        
        if let timeH=dateComponents.hour{
            if let timeM=dateComponents.minute{
                var tmpAppoint = appointTime
                if datePickerIsOn {
                    tmpAppoint.onTimeM=timeM
                    tmpAppoint.onTimeH=timeH
                    
                }else{
                    tmpAppoint.offTimeM=timeM
                    tmpAppoint.offTimeH=timeH
                }
                appointTime=tmpAppoint
            }
        }
        
        
    }
}
