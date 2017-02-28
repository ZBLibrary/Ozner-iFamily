//
//  TDSPanSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/1.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class TDSPanSettingController: DeviceSettingController {

   
    @IBAction func backClick(_ sender: AnyObject) {
        super.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        super.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBAction func deleteClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("设置")
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showAboutDevice" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutTDSPan"]?.stringValue)!, Type: 0)
        }
    }
    

}
