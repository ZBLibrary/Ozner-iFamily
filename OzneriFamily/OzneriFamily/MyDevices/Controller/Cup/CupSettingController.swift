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
        let buttonStateIsOn = !((self.deviceSetting.get("todayState\(sender.tag+1)", default: "false") as! String)=="true")
        let imgName = [false:["setmystate1","setmystate2","setmystate3","setmystate4"],
                   true:["setmystate1c","setmystate2c","setmystate3c","setmystate4c"]][buttonStateIsOn]?[sender.tag]
        
        [todayStateButton1,todayStateButton2,todayStateButton3,todayStateButton4][sender.tag]?.setImage(UIImage(named: imgName!), for: .normal)
        [todayStateLabel1,todayStateLabel2,todayStateLabel3,todayStateLabel4][sender.tag]?.textColor = buttonStateIsOn ? selectcolor:normalcolor
        self.deviceSetting.put("todayState\(sender.tag+1)", value: buttonStateIsOn ? "true":"false")
        let drinkValue = Int(drinkingLabel.text!)!+(buttonStateIsOn ? 50:(-50))
        drinkingLabel.text="\(drinkValue)"
        self.deviceSetting.put("drink", value:"\(drinkValue)")
    }
   
    //饮水时间提醒
    @IBOutlet var drinkRemaindTimeLabel: UILabel!
    @IBOutlet var drinkRemindSpaceLabel: UILabel!
    @IBAction func drinkRemindSpaceClick(_ sender: UITapGestureRecognizer) {
        let timeSpace = Int((self.deviceSetting as! CupSettings).remindInterval)
        let index=[15:0,30:1,45:2,60:3,120:4][timeSpace]
        pickDateView.setView(valueIndex: index!, OKClick: { (value) in
            (self.deviceSetting as! CupSettings).remindInterval=uint(value)
            self.drinkRemindSpaceLabel.text="\(value%60+value/60)"+(value>=60 ? "小时":"分钟")
            self.pickDateView.removeFromSuperview()
        }) {
            self.pickDateView.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(pickDateView)
    }
    @IBAction func cupVoiceSwitch(_ sender: UISwitch) {
    }
    @IBAction func phoneSwitch(_ sender: UISwitch) {
    }
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        segLabel1.text = sender.selectedSegmentIndex==0 ? "25°C以下":"健康"
        segLabel2.text = sender.selectedSegmentIndex==0 ? "25°C-50°C":"一般"
        segLabel3.text = sender.selectedSegmentIndex==0 ? "50°C以上":"较差"
    
    }
    @IBOutlet var segLabel1: UILabel!
    @IBOutlet var segLabel2: UILabel!
    @IBOutlet var segLabel3: UILabel!
    
    @IBAction func deletClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    var pickDateView:CupCustomPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAndAttrLabel.text=self.getNameAndAttr()
        weightTF.text=self.deviceSetting.get("weight", default: "56") as! String?
        drinkingLabel.text=self.deviceSetting.get("drink", default: "2000") as! String?
        for i in 0...3 {
            let buttonStateIsOn = (self.deviceSetting.get("todayState\(i+1)", default: "false") as! String)=="true"
            let imgName = [false:["setmystate1","setmystate2","setmystate3","setmystate4"],
                           true:["setmystate1c","setmystate2c","setmystate3c","setmystate4c"]][buttonStateIsOn]?[i]
            
            [todayStateButton1,todayStateButton2,todayStateButton3,todayStateButton4][i]?.setImage(UIImage(named: imgName!), for: .normal)
            [todayStateLabel1,todayStateLabel2,todayStateLabel3,todayStateLabel4][i]?.textColor = buttonStateIsOn ? selectcolor:normalcolor
        }
        weightTF.addDoneOnKeyboard(withTarget: self, action:  #selector(weightTFDone))
        
        let starTime=Int((self.deviceSetting as! CupSettings!).remindStart)
        let endTime=Int((self.deviceSetting as! CupSettings!).remindEnd)
        drinkRemaindTimeLabel.text="\(starTime/3600):\(starTime%3600/60)-\(endTime/3600):\(endTime%3600/60)"
        // Do any additional setup after loading the view.
        //饮水时间间隔
        pickDateView=Bundle.main.loadNibNamed("CupCustomPickerView", owner: nil, options: nil)?.last as! CupCustomPickerView
        pickDateView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        pickDateView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        
        let timeSpace = Int((self.deviceSetting as! CupSettings).remindInterval)
         self.drinkRemindSpaceLabel.text="\(timeSpace%60+timeSpace/60)"+(timeSpace>=60 ? "小时":"分钟")
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
        self.deviceSetting.put("drink", value: drinkingLabel.text!)
        self.deviceSetting.put("weight", value: weightTF.text!)
        
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
            VC.currSetting=self.deviceSetting as! CupSettings!
        }
    }
 

}
