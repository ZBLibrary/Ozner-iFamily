//
//  AirPurfierSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/1.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class AirPurfierSettingController: DeviceSettingController {

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
            VC.setLoadContent(content: LoginManager.instance.currentDevice.type==OznerDeviceType.Air_Blue.rawValue ? "airOperation_small":"airOperation_big", isUrl: false)
            VC.title="空气净化器使用说明"
        }
        if segue.identifier=="showCommonQestion" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: LoginManager.instance.currentDevice.type==OznerDeviceType.Air_Blue.rawValue ? "airProblem_small":"airProblem_big", isUrl: false)
            VC.title="常见问题"
            
        }
    }
    

}
