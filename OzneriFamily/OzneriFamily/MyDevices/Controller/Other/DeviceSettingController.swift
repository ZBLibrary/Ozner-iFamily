//
//  DeviceSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class DeviceSettingController: BaseViewController {


    var deviceSetting:DeviceSetting!
    override func viewDidLoad() {
        super.viewDidLoad()
        let device=LoginManager.instance.currentDevice
        
        
        switch OznerDeviceType.getType(type: device.type) {
        case OznerDeviceType.Cup:
            deviceSetting=CupSettings(json: device.settings.toJSON())
        case OznerDeviceType.Tap,OznerDeviceType.TDSPan:
            deviceSetting=TapSettings(json: device.settings.toJSON())
        default:
            deviceSetting=DeviceSetting(json: device.settings.toJSON())
        }
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
        deviceSetting.put("usingSite", value: attr)
    }
    func getNameAndAttr() -> String {
        return deviceSetting.name+"("+(deviceSetting.get("usingSite", default:loadLanguage("办公室")) as! String)+")"
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
            let device=LoginManager.instance.currentDevice
            LoginManager.instance.currentDeviceIdentifier=nil
            OznerManager.instance().remove(device)
            
            //删除服务器设备
            LoginManager.instance.showHud()
            User.DeleteDevice(mac: device.identifier, success: {
                SVProgressHUD.dismiss()
            }, failure: { (error) in
                SVProgressHUD.dismiss()
            })
            
            _=self.navigationController?.popViewController(animated: true)
        }
        _=alert.showInfo("", subTitle: loadLanguage("删除此设备"))
        
    }
    
    func back() {
        let device=LoginManager.instance.currentDevice
        if deviceSetting.toJSON()==device.settings.toJSON()
        {
            _=self.navigationController?.popViewController(animated: true)
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
                _=self.navigationController?.popViewController(animated: true)
            }
            _=alert.showInfo("", subTitle: loadLanguage("是否保存？"))
        }
    }
    func saveDevice() {
        
        let device=LoginManager.instance.currentDevice
            device.settings=deviceSetting
        OznerManager.instance().save(device)
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
