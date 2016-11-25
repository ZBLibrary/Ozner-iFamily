//
//  WaterReplenishSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/1.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterReplenishSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBAction func deleteClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAndAttrLabel.text=self.getNameAndAttr()
        // Do any additional setup after loading the view.
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
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutWaterReplenish"]?.stringValue)!, Type: 0)
        }
        if segue.identifier=="showSetTime" {
            let VC=segue.destination as!  SetReplenishTimeController
            VC.currSetting=self.deviceSetting
        }
        if segue.identifier=="showSetSex" {
            let VC=segue.destination as!  ReplenishSexController
            VC.currSetting=self.deviceSetting
        }
    }
    

}
