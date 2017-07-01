//
//  DeviceViewContainer.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
//一级视图代理
@objc public protocol DeviceViewContainerDelegate {
    @objc optional func PresentModelController(controller:UIViewController)->Void//弹出模态视图
    @objc optional func DeviceNameChange(name:String)->Void
    @objc optional func DeviceConnectStateChange(stateDes:String)->Void
    @objc optional func WhitchCenterViewIsHiden(SettingIsHiden:Bool,BateryIsHiden:Bool,FilterIsHiden:Bool,BottomValue:CGFloat)->Void
    @objc optional func BateryValueChange(value:Int)->Void//0-100，<0表示无
    @objc optional func FilterValueChange(value:Int)->Void//0-100，<0表示无
    // 页面跳转
    @objc optional func DeviceViewPerformSegue(SegueID:String,sender: Any?)->Void//跳转到storyboard 中连线的Controller
    
    
}


class DeviceViewContainer: UIView {

    var currentDeviceView:OznerDeviceView!
    var delegate:DeviceViewContainerDelegate!
    func SetDeviceAndView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        //添加视图
        SelectWitchView(device: OznerManager.instance.currentDevice)
        
    }
    //设置滤芯
    var LvXinValue:Int = -1{
        didSet{
            if LvXinValue != oldValue {
                delegate.FilterValueChange!(value: LvXinValue)
            }
            
        }
    }
    //设置电量
    var batteryValue:Int = -1{
        didSet{
            if batteryValue != oldValue {
                delegate.BateryValueChange!(value: batteryValue)
            }
            
        }
    }
    private let DeviceNibName:[OZDeviceClass:String]=[
        .Cup:"CupMainView",
        .Tap:"TapMainView",
        .TDSPan:"TapMainView",
        .WaterPurifier_Wifi:"WaterPurifierMainView",
        .AirPurifier_Blue:"Air_BlueMainView",
        .AirPurifier_Wifi:"Air_WifiMainView",
        .WaterReplenish:"WaterReplenishMainView",
        .WaterPurifier_Blue:"WaterPurifierMainView"
    ]
    private func SelectWitchView(device:OznerBaseDevice?)  {
        //测试
        var deviceNibName = "NoDeviceView"//"WaterPur_A8CSFFSF"//
        if device != nil  {//有设备时视图初始化
            let tmpType=ProductInfo.getCurrDeviceClass()
            deviceNibName=DeviceNibName[tmpType]!
            device?.delegate=self
            delegate.DeviceNameChange!(name: (device?.settings.name)!)
        }
        
        currentDeviceView = Bundle.main.loadNibNamed(deviceNibName, owner: nil, options: nil)?.first as! OznerDeviceView
        currentDeviceView.delegate=self.delegate
        currentDeviceView?.frame=self.frame
        self.addSubview(currentDeviceView!)
        //weak var weakSelf=self
        if device==nil {
            //无设备时视图初始化
            delegate.DeviceNameChange!(name: "首页")
            delegate.DeviceConnectStateChange!(stateDes: "")
            delegate.WhitchCenterViewIsHiden!(SettingIsHiden: true, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
            //测试
            //delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: true,BottomValue:160*k_height)
            //delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:220*k_height)
        }else{//有设备时视图初始化
            
            switch  ProductInfo.getCurrDeviceClass() {
            case .Cup:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:160*k_height)
            case .Tap:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: false,BottomValue:211*k_height)
                //下载滤芯更新
                User.FilterService(deviceID: ProductInfo.getCurrDeviceMac(), success: { (usedDay, _) in
                    self.LvXinValue=Int(ceil(100.0*(30.0-Float(usedDay))/30.0))
                    }, failure: { (error) in
                        print(error)
                })
            case .TDSPan:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:0)
            case .WaterPurifier_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:160*k_height)
                //设置滤芯及功能
                SetWaterPurifer(devID: ProductInfo.getCurrDeviceMac())
            case .AirPurifier_Blue:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*k_height)
            case .AirPurifier_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*k_height)
            case .WaterReplenish:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:156*k_height)
                
            case .WaterPurifier_Blue:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:160*k_height)
                //隐藏底部按钮
                (currentDeviceView as! WaterPurifierMainView).isBlueDevice=true
                
//            case .Water_Wifi_JZYA1XBA8CSFFSF:
//                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: true,BottomValue:160*k_height)
//                break
//            case .Water_Wifi_JZYA1XBA8DRF,.Water_Wifi_JZYA1XBLG_DRF:
//                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:220*k_height)
//                break
            }
            OznerDeviceSensorUpdate(identifier: OznerManager.instance.currentDevice?.deviceInfo.deviceID)//初始化设备状态
        }
        
    }
}
//OznerDeviceDelegate设备数据更新代理
extension DeviceViewContainer:OznerBaseDeviceDelegate{
    //传感器数据变化
    ////OznerBaseDeviceDelegate
    func OznerDeviceSensorUpdate(identifier: String) {
        DispatchQueue.main.async {
            self.currentDeviceView.SensorUpdate(identifier:identifier)
            //滤芯电量或电池电量
            let currentDevice=OznerManager.instance.currentDevice
            switch ProductInfo.getCurrDeviceClass() {
            case .Cup:
                self.batteryValue = Int((currentDevice as! Cup).sensor.Battery)
            case .Tap:
                self.batteryValue = Int((currentDevice as! Tap).sensor.Battery)
            case .TDSPan:
                batteryValue = Int((currentDevice as! Tap).sensor.Battery)
            case .AirPurifier_Blue:
                //设置滤芯
                let workTime=Int((currentDevice as! AirPurifier_Bluetooth).status.filterStatus.workTime)
                var lvxinValue=1-CGFloat(workTime)/CGFloat(60000)
                lvxinValue=min(1, lvxinValue)
                lvxinValue=max(0, lvxinValue)
                self.LvXinValue=Int(lvxinValue*100)
            case .AirPurifier_Wifi:
                if let filterStatus=(currentDevice as! AirPurifier_Wifi).status.filterStatus
                {
                    let workTime=Int(filterStatus.workTime)
                    var lvxinValue=1-CGFloat(workTime)/CGFloat(129600)
                    lvxinValue=min(1, lvxinValue)
                    lvxinValue=max(0, lvxinValue)
                    self.LvXinValue=Int(lvxinValue*100)
                }
            case .WaterPurifier_Wifi:
                break
            case .WaterReplenish:
                self.batteryValue = Int((currentDevice as! WaterReplenish).status.battery*100)
            case .WaterPurifier_Blue:
                let tmpDev=currentDevice as! WaterPurifier_Blue
                let lvxinValue=min(tmpDev.filterInfo.filter_A_Percentage, tmpDev.filterInfo.filter_B_Percentage, tmpDev.filterInfo.filter_C_Percentage)
                self.LvXinValue=Int(lvxinValue)
//            case .Water_Wifi_JZYA1XBA8CSFFSF,.Water_Wifi_JZYA1XBA8DRF,.Water_Wifi_JZYA1XBLG_DRF:
//                break
            }
        }
        
        
    }
    func OznerDeviceStatusUpdate(identifier: String) {
        DispatchQueue.main.async {
            //解析当前状态
            switch (OznerManager.instance.currentDevice?.connectStatus)! {
            case OznerConnectStatus.Connecting:
                self.delegate.DeviceConnectStateChange!(stateDes: loadLanguage("正在连接中..."))
            case OznerConnectStatus.Disconnect:
                self.delegate.DeviceConnectStateChange!(stateDes:loadLanguage("设备已断开"))
            case OznerConnectStatus.Connected:
                self.delegate.DeviceConnectStateChange!(stateDes: loadLanguage("设备已连接"))
            default://已连接
                self.delegate.DeviceConnectStateChange!(stateDes: "")
            }
            //设置主页
            self.currentDeviceView.StatusUpdate(identifier: identifier, status: DeviceViewStatus.Connectted)
        }
    }
    func OznerDevicefilterUpdate(identifier: String) {
        DispatchQueue.main.async {
            
        }
        
    }
    func OznerDeviceRecordUpdate(identifier: String) {
        DispatchQueue.main.async {
            
        }
    }
    
    
    
}

//从后台上传下拉数据方法
extension DeviceViewContainer{

    //设置净水器滤芯、型号、链接地址、是否提醒
    func SetWaterPurifer(devID:String){
        weak var weakSelf=self
        User.GetMachineType(deviceID: devID, success: { (scanEnable, coolEnable, hotEnable, machineType, buyURL, alertDays) in
            let url = buyURL=="" ? NetworkManager.defaultManager?.URL?["goodsDetail9"]?.stringValue:buyURL
           
            User.GetMachineLifeOutTime(deviceID: devID, success: { (usedDays, stopDate) in
                let useValue=ceil(Double(100*(365-usedDays)/365))
                
                guard (weakSelf?.currentDeviceView?.isKind(of: WaterPurifierMainView.self))! else {
                    return
                }
                
                 (weakSelf?.currentDeviceView as! WaterPurifierMainView).setLvXinAndEnable(scan: scanEnable, cool: coolEnable, hot: hotEnable, buyLvXinUrl: url!, lvXinStopDate: stopDate as NSDate, lvXinUsedDays: Int(useValue))
                self.LvXinValue=Int(useValue)
                if useValue<10//小于10%提醒及时更换滤芯
                {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false,
                        dynamicAnimatorActive: true
                    )
                    let alert=SCLAlertView(appearance: appearance)
                    _=alert.addButton(loadLanguage(loadLanguage("现在去购买滤芯"))) {
                        //跳到购买滤芯的页面
                        weakSelf?.delegate.DeviceViewPerformSegue!(SegueID: "showBuyLvXin", sender: ["title":loadLanguage("净水器滤芯"),"url":NetworkManager.defaultManager?.UrlWithRoot(url!)])
                    }
                    _=alert.addButton(loadLanguage("我知道了"), action:{})
                    _=alert.showInfo("", subTitle: loadLanguage("你的滤芯即将到期，请及时更换滤芯，以免耽误您的使用"))
                }
                }, failure: { (error) in
                    self.LvXinValue = -2
            })
            }) { (error) in
                self.LvXinValue = -2
        }
    }

}
