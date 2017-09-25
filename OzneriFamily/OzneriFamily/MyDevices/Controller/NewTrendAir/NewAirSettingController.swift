//
//  TapSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class NewAirSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
  
    @IBAction func deleteDeviceClick(_ sender: AnyObject) {
        super.deleteDevice()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        self.title = loadLanguage("设置")

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showAboutDevice" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutTap"]?.stringValue)!, Type: 0)
        }
    }
    

}
