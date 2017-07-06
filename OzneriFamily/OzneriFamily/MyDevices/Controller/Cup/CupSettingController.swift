//
//  CupSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/13.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import IQKeyboardManager
class CupSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var drinkingLabel: UITextField!
    
    @IBOutlet weak var deleteBtn: UIButton!
    //今日状态
    @IBOutlet var todayStateButton1: UIButton!
    @IBOutlet var todayStateButton2: UIButton!
    @IBOutlet var todayStateButton3: UIButton!
    @IBOutlet var todayStateButton4: UIButton!
    @IBOutlet var todayStateLabel1: UILabel!
    @IBOutlet var todayStateLabel2: UILabel!
    @IBOutlet var todayStateLabel3: UILabel!
    @IBOutlet var todayStateLabel4: UILabel!
    let normalcolor=UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1)
    let selectcolor=UIColor(red: 77/255, green: 145/255, blue: 250/255, alpha: 1)
    @IBAction func todayStateClick(_ sender: UIButton) {
        let buttonStateIsOn = !(self.deviceSetting.GetValue(key: "todayState\(sender.tag+1)", defaultValue: "false")=="true")
        let imgName = [false:["setmystate1","setmystate2","setmystate3","setmystate4"],
                   true:["setmystate1c","setmystate2c","setmystate3c","setmystate4c"]][buttonStateIsOn]?[sender.tag]
        
        [todayStateButton1,todayStateButton2,todayStateButton3,todayStateButton4][sender.tag]?.setImage(UIImage(named: imgName!), for: .normal)
        [todayStateLabel1,todayStateLabel2,todayStateLabel3,todayStateLabel4][sender.tag]?.textColor = buttonStateIsOn ? selectcolor:normalcolor
        self.deviceSetting.SetValue(key: "todayState\(sender.tag+1)", value: buttonStateIsOn ? "true":"false")
        let drinkValue = Int(drinkingLabel.text!)!+(buttonStateIsOn ? 50:(-50))
        drinkingLabel.text="\(drinkValue)"
        self.deviceSetting.SetValue(key: "drink", value:"\(drinkValue)")
    }
   
    //饮水时间提醒
    @IBOutlet var drinkRemaindTimeLabel: UILabel!
    @IBOutlet var drinkRemindSpaceLabel: UILabel!
    @IBAction func drinkRemindSpaceClick(_ sender: UITapGestureRecognizer) {
        let timeSpace = Int(self.deviceSetting.GetValue(key: "remindInterval", defaultValue: "15"))!
        let index=[15:0,30:1,45:2,60:3,120:4][timeSpace]
        pickDateView.setView(valueIndex: index!, OKClick: { (value) in
            self.deviceSetting.SetValue(key: "remindInterval", value: "\(value)")
            self.drinkRemindSpaceLabel.text="\(value%60+value/60)"+(value>=60 ? loadLanguage("小时"):loadLanguage("分钟"))
            self.pickDateView.removeFromSuperview()
        }) {
            self.pickDateView.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(pickDateView)
    }
    @IBAction func cupVoiceSwitch(_ sender: UISwitch) {
        self.deviceSetting.SetValue(key: "remindEnable", value: "\(sender.isOn.hashValue)")
    }
    @IBAction func phoneSwitch(_ sender: UISwitch) {
        if sender.isOn {
            let repeatInter = Int(self.deviceSetting.GetValue(key: "remindInterval", defaultValue: "15"))
            let starTime = Int(self.deviceSetting.GetValue(key: "remindStart", defaultValue: "\(9*3600)"))!/60
            let endTime = Int(self.deviceSetting.GetValue(key: "remindEnd", defaultValue: "\(9*3600)"))!/60
            LocalNotificationHelper.addCupNotice(repeatInter: repeatInter!, starTime: starTime, endTime: endTime)
        }else{
            LocalNotificationHelper.removeNoticeForKey(key: "CupRemind")
        }
    }
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        segLabel1.text = sender.selectedSegmentIndex==0 ? loadLanguage("25°C以下"):loadLanguage("健康")
        segLabel2.text = sender.selectedSegmentIndex==0 ? loadLanguage("25°C-50°C"):loadLanguage("一般")
        segLabel3.text = sender.selectedSegmentIndex==0 ? loadLanguage("50°C以上"):loadLanguage("较差")
    
    }
    @IBOutlet var segLabel1: UILabel!
    @IBOutlet var segLabel2: UILabel!
    @IBOutlet var segLabel3: UILabel!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var tempSegement: UISegmentedControl!
    @IBOutlet weak var zhuyilb: GYLabel!
    @IBAction func deletClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    var pickDateView:CupCustomPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAndAttrLabel.text=self.getNameAndAttr()
        self.title = loadLanguage("设置")
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        zhuyilb.text = loadLanguage("电池低于10%,光圈双闪")
        deleteBtn.setTitle(loadLanguage("删除此设备"), for: UIControlState.normal)
        tempSegement.setTitle(loadLanguage("饮水温度"), forSegmentAt: 0)
        tempSegement.setTitle(loadLanguage("饮水纯净指数TDS"), forSegmentAt: 1)
        weightTF.text=self.deviceSetting.GetValue(key: "weight", defaultValue: "56")
        drinkingLabel.text=self.deviceSetting.GetValue(key: "drink", defaultValue: "2000")
        
        if !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber) {
            
            aboutView.removeFromSuperview()
            
        }
        
        for i in 0...3 {
           
            let buttonStateIsOn = self.deviceSetting.GetValue(key: "todayState\(i+1)", defaultValue: "false")=="true"
            let imgName = [false:["setmystate1","setmystate2","setmystate3","setmystate4"],
                           true:["setmystate1c","setmystate2c","setmystate3c","setmystate4c"]][buttonStateIsOn]?[i]
            
            [todayStateButton1,todayStateButton2,todayStateButton3,todayStateButton4][i]?.setImage(UIImage(named: imgName!), for: .normal)
            [todayStateLabel1,todayStateLabel2,todayStateLabel3,todayStateLabel4][i]?.textColor = buttonStateIsOn ? selectcolor:normalcolor
        }
        weightTF.addDoneOnKeyboard(withTarget: self, action:  #selector(weightTFDone))
        
        let starTime=Int(self.deviceSetting.GetValue(key: "remindStart", defaultValue: "\(9*3600)"))!
        let endTime=Int(self.deviceSetting.GetValue(key: "remindEnd", defaultValue: "\(19*3600)"))!
        drinkRemaindTimeLabel.text="\(starTime/3600):\(starTime%3600/60)-\(endTime/3600):\(endTime%3600/60)"
        // Do any additional setup after loading the view.
        //饮水时间间隔
        pickDateView=Bundle.main.loadNibNamed("CupCustomPickerView", owner: nil, options: nil)?.last as! CupCustomPickerView
        pickDateView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        pickDateView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        
        let timeSpace = Int(self.deviceSetting.GetValue(key: "remindInterval", defaultValue: "15"))!
         self.drinkRemindSpaceLabel.text="\(timeSpace%60+timeSpace/60)"+(timeSpace>=60 ? loadLanguage("小时"):loadLanguage("分钟"))
    }
    func weightTFDone(){
        //体重
        let tmpWeightStr = weightTF.text!.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if tmpWeightStr=="" {
            weightTF.text="56"
            drinkingLabel.text="2000"
        }else{
            drinkingLabel.text="\(Int(tmpWeightStr)!*2000/56)"
        }
        self.deviceSetting.SetValue(key: "drink", value: drinkingLabel.text!)
        self.deviceSetting.SetValue(key: "weight", value: weightTF.text!)
        
        weightTF.resignFirstResponder()
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
        if segue.identifier=="showAboutDevice" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutCup"]?.stringValue)!, Type: 0)
        }
        if segue.identifier=="showCupSetDrinkTime" {
            let VC=segue.destination as!  CupSetDrinkTimeController
            VC.currSetting=self.deviceSetting
        }
    }
 

}
