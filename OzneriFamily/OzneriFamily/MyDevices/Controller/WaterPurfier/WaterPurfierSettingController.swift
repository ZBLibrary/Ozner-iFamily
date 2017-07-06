//
//  WaterPurfierSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/1.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurfierSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var macAdressLabel: GYLabel!
    @IBOutlet var waterPayViewContainer: UIView!

    @IBAction func deleteClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("设置")
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        nameAndAttrLabel.text=self.getNameAndAttr()
        waterPayViewContainer.isHidden=(ProductInfo.getCurrDeviceClass() != .WaterPurifier_Blue)
        macAdressLabel.text="mac:"+ProductInfo.getCurrDeviceMac()
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
            var url=(NetworkManager.defaultManager?.URL?["AboutWaterPurifer"]?.stringValue)!
            
            if  ProductInfo.getCurrDeviceClass() == OZDeviceClass.WaterPurifier_Blue{
                url=(NetworkManager.defaultManager?.URL?["AboutROWaterPurifer"]?.stringValue)!
            }
            VC.setLoadContent(content: url, Type: 0)
        }
    }
    

}
