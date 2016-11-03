//
//  DeviceSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class DeviceSettingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
    }
    func nameChange(name:String,attr:String) {
        print("=====\(name)=========\(attr)================success")
    }
    func deleteDevice()
    {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
        let alert=SCLAlertView(appearance: appearance)
        _=alert.addButton("否") {
            print("否")
        }
        _=alert.addButton("是") {
            let device=LoginManager.instance.currentDevice
            LoginManager.instance.currentDeviceIdentifier=nil
            OznerManager.instance().remove(device)
            _=self.navigationController?.popViewController(animated: true)
        }
        
        _=alert.showInfo("", subTitle: "删除此设备")
        
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
