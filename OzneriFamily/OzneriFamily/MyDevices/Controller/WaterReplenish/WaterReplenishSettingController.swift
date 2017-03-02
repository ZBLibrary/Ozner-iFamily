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
    @IBOutlet weak var hideimage1: UIImageView!
    @IBOutlet weak var hideimage2: GYLabel!
    @IBOutlet weak var hideview2: UIView!
    @IBOutlet weak var hidelb2: UIImageView!
    @IBOutlet weak var hideview1: UIView!
    @IBOutlet weak var hidelb1: GYLabel!
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var sexLabel: UILabel!
    @IBAction func deleteClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("设置")
        
        if !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber ) {
            hidelb1.removeFromSuperview()
            hidelb2.removeFromSuperview()
            hideview1.removeFromSuperview()
            hideview2.removeFromSuperview()
            hideimage2.removeFromSuperview()
            hideimage1.removeFromSuperview()
        }
        
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sexLabel.text=self.deviceSetting.get("sex", default: loadLanguage("女")) as! String?
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
        
        if segue.identifier == "showBuyWater" {
            
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["buyEssenceWater"]?.stringValue)!, Type: 0)
            
        }
        
    }
    

}
