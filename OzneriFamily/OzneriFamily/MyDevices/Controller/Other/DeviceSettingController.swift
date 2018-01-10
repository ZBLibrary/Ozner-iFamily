//
//  DeviceSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SVProgressHUD


class DeviceSettingController: BaseViewController {


    var deviceSetting:BaseDeviceSetting!
    override func viewDidLoad() {
        super.viewDidLoad()
        let device=OznerManager.instance.currentDevice
        deviceSetting=BaseDeviceSetting(json: device?.settings.toJsonString())
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
        deviceSetting.name=name
        deviceSetting.SetValue(key: "usingSite", value: attr)
    }
    func getNameAndAttr() -> String {
        
        return deviceSetting.name+"("+deviceSetting.GetValue(key: "usingSite", defaultValue: loadLanguage("办公室"))+")"
    }
    func deleteDevice()
    {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
        let alert=SCLAlertView(appearance: appearance)
        _=alert.addButton(loadLanguage("否")) {
        }
        _=alert.addButton(loadLanguage("是")) {
            let device=OznerManager.instance.currentDevice
            
            OznerManager.instance.deleteDevice(device: device!)
            
            //删除服务器设备
            LoginManager.instance.showHud()
            User.DeleteDevice(mac: (device?.deviceInfo.deviceMac)!, success: {
                SVProgressHUD.dismiss()
            }, failure: { (error) in
                SVProgressHUD.dismiss()
            })
            
            _=self.navigationController?.popViewController(animated: true)
        }
        _=alert.showInfo("", subTitle: loadLanguage("删除此设备"))
        
    }
    
    func back() {
        let device=OznerManager.instance.currentDevice
        if deviceSetting.toJsonString()==device?.settings.toJsonString()
        {
            _=self.navigationController?.popViewController(animated:  false)
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                dynamicAnimatorActive: true
            )
            let alert=SCLAlertView(appearance: appearance)
            _=alert.addButton("是") {
                self.saveDevice()
            }
            _=alert.addButton("否") {
                _=self.navigationController?.popViewController(animated: false)
            }
            _=alert.showInfo("", subTitle: loadLanguage("是否保存？"))
        }
    }
    func saveDevice() {
        
        let device=OznerManager.instance.currentDevice
            device?.settings=deviceSetting
        OznerManager.instance.saveDevice(device: device!)
        _=self.navigationController?.popViewController(animated: true)
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
