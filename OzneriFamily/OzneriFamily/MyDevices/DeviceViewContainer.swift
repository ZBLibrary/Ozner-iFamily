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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var currentDevice:OznerDevice?
    var currentDeviceView:OznerDeviceView!
    var delegate:DeviceViewContainerDelegate!
    func SetDeviceAndView() {
        var device:OznerDevice?
        let deviceArr=OznerManager.instance().getDevices() as NSArray
        if deviceArr.count==0 {
            device=nil
            LoginManager.instance.currentDeviceIdentifier=nil
        
        }else{
            device=deviceArr.object(at: 0) as? OznerDevice
            if LoginManager.instance.currentDeviceIdentifier != nil {
                for item in deviceArr {
                    if (item as! OznerDevice).identifier==LoginManager.instance.currentDeviceIdentifier {
                        device=item as? OznerDevice
                        break
                    }
                }
                
            }
            //是不是当前设备
            LoginManager.instance.currentDeviceIdentifier=device?.identifier
            if currentDevice != nil {
                if LoginManager.instance.currentDeviceIdentifier==currentDevice?.identifier {
                    delegate.DeviceNameChange!(name: (currentDevice?.settings.name)!)
                    return
                }
            }
        }
  
       //移除设备视图
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        //添加视图
        SelectWitchView(device: device)
        
    }
    private let DeviceNibName:[OznerDeviceType:String]=[
        OznerDeviceType.Cup:"CupMainView",
        .Tap:"TapMainView",
        .TDSPan:"TapMainView",
        .Water_Wifi:"WaterPurifierMainView",
        .Air_Blue:"Air_BlueMainView",
        .Air_Wifi:"Air_WifiMainView",
        .WaterReplenish:"WaterReplenishMainView"
    ]
    private func SelectWitchView(device:OznerDevice?)  {
        
        
        currentDevice=device
        var deviceNibName =  "NoDeviceView"
        if device != nil  {//有设备时视图初始化
            deviceNibName=DeviceNibName[OznerDeviceType(rawValue: (device?.type)!)!]!
            currentDevice?.delegate=self
            delegate.DeviceNameChange!(name: (currentDevice?.settings.name)!)
        }
        
        currentDeviceView = Bundle.main.loadNibNamed(deviceNibName, owner: nil, options: nil)?.first as! OznerDeviceView
        currentDeviceView.delegate=self.delegate
        currentDeviceView?.frame=self.frame
        self.addSubview(currentDeviceView!)
        weak var weakSelf=self
        if device==nil {
            //无设备时视图初始化
            delegate.DeviceNameChange!(name: "首页")
            delegate.DeviceConnectStateChange!(stateDes: "")
            delegate.WhitchCenterViewIsHiden!(SettingIsHiden: true, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
            
        }else{//有设备时视图初始化
            currentDeviceView.currentDevice=device
            switch  OznerDeviceType(rawValue: (currentDevice?.type)!)! {
            case .Cup:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:160*k_height)
                //设置电池电量
                let tmpDianLiang = (currentDevice as! Cup).sensor.powerPer()*100
                delegate.BateryValueChange!(value: Int(tmpDianLiang))
                
            case .Tap:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: false,BottomValue:211*k_height)
                //设置电池电量
                let tmpDianLiang = (currentDevice as! Tap).sensor.powerPer()*100
                delegate.BateryValueChange!(value: Int(tmpDianLiang))
                //下载滤芯更新
                User.FilterService(deviceID: (currentDevice?.identifier)!, success: { (usedDay, _) in
                    let value=ceil(100.0*(30.0-Float(usedDay))/30.0)
                    weakSelf?.delegate.FilterValueChange!(value: Int(value))
                    }, failure: { (error) in
                        print(error)
                        print(error)
                })
            case .TDSPan:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:0)
                //设置电池电量
                let tmpDianLiang = (currentDevice as! Tap).sensor.powerPer()*100
                delegate.BateryValueChange!(value: Int(tmpDianLiang))
            case .Water_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:160*k_height)
                
//                (currentDeviceView as! WaterPurifierMainView).circleView.updateCircleView(angleBefore: 0.7, angleAfter: 0.5)
                //设置滤芯及功能
                SetWaterPurifer(devID: (currentDevice?.identifier)!)
            case .Air_Blue:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*k_height)
                //设置滤芯
                let lvXinValue=getAirLvXin(lastDate: (currentDevice as! AirPurifier_Bluetooth).status.filterStatus.lastTime, maxUseMonth: 3)
                delegate.FilterValueChange!(value: lvXinValue)
            case .Air_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*k_height)
                //设置滤芯
                if let filterStatus=(currentDevice as! AirPurifier_MxChip).status.filterStatus
                {
                    let lvxinValue=getAirLvXin(lastDate: filterStatus.lastTime, maxUseMonth: 12)
                    delegate.FilterValueChange!(value: lvxinValue)
                }else{
                    delegate.FilterValueChange!(value: 65535)
                }
                
            case .WaterReplenish:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:156*k_height)
                //设置电池电量
                let tmpDianLiang = (currentDevice as! WaterReplenishmentMeter).status.battery*100
                delegate.BateryValueChange!(value: Int(tmpDianLiang))
            }
            oznerDeviceStatusUpdate(currentDevice)//初始化设备状态
        }
        
    }
}
//OznerDeviceDelegate设备数据更新代理
extension DeviceViewContainer:OznerDeviceDelegate{
    //传感器数据变化
    
    func oznerDeviceSensorUpdate(_ device: OznerDevice!) {
        if CheckIsCurrentDevice(device: device) == true {
            currentDeviceView.currentDevice=device
            currentDeviceView.SensorUpdate(device: device)
        }
    }
    //连接状态变化
    func oznerDeviceStatusUpdate(_ device: OznerDevice!) {
        if CheckIsCurrentDevice(device: device) == true {
            currentDeviceView.currentDevice=device
            //解析当前状态
            switch device.connectStatus() {
            case Connecting:
                delegate.DeviceConnectStateChange!(stateDes: "正在连接中...")
            case Disconnect:
                delegate.DeviceConnectStateChange!(stateDes: "设备已断开")
            default://已连接
                delegate.DeviceConnectStateChange!(stateDes: "")
            }      
            //设置主页
            currentDeviceView.StatusUpdate(device: device, status: DeviceViewStatus.Connectted)
        }
    }
    //检查是不是当前设备
    private func CheckIsCurrentDevice(device: OznerDevice!)->Bool{
        if currentDevice==nil {
            return false
        }else{
            return device.identifier==currentDevice?.identifier
        }
    }
}

//从后台上传下拉数据方法
extension DeviceViewContainer{

    
    //空净滤芯状态
    func getAirLvXin(lastDate:Date?,maxUseMonth:Int) -> Int {
        if lastDate==nil{
            return -1
        }
        let nowTime=Date().timeIntervalSince1970
        let lastTime = lastDate?.timeIntervalSince1970
        let stopTime=(lastDate! as NSDate).addingMonths(maxUseMonth).timeIntervalSince1970
        if stopTime-nowTime<0
        {
            return 0
        }else{
            let tmpValue = ceil((stopTime-nowTime)/(stopTime-lastTime!)*100)
            return Int(tmpValue)
        }
       
    }
    //设置净水器滤芯、型号、链接地址、是否提醒
    func SetWaterPurifer(devID:String){
        weak var weakSelf=self
        User.GetMachineType(deviceID: devID, success: { (scanEnable, coolEnable, hotEnable, machineType, buyURL, alertDays) in
            let url = buyURL=="" ? NetworkManager.defaultManager?.URL?["goodsDetail9"]?.stringValue:buyURL
           
            User.GetMachineLifeOutTime(deviceID: devID, success: { (usedDays, stopDate) in
                let useValue=ceil(Double(100*(365-usedDays)/365))
                
                 (weakSelf?.currentDeviceView as! WaterPurifierMainView).setLvXinAndEnable(scan: scanEnable, cool: coolEnable, hot: hotEnable, buyLvXinUrl: url!, lvXinStopDate: stopDate as NSDate, lvXinUsedDays: Int(useValue))
                weakSelf?.delegate.FilterValueChange!(value: Int(useValue))
                if useValue<10//小于10%提醒及时更换滤芯
                {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false,
                        dynamicAnimatorActive: true
                    )
                    let alert=SCLAlertView(appearance: appearance)
                    _=alert.addButton(loadLanguage(loadLanguage("现在去购买滤芯"))) {
                        //跳到购买滤芯的页面
                        
                        weakSelf?.delegate.DeviceViewPerformSegue!(SegueID: "showBuyLvXin", sender: ["title":"净水器滤芯","url":NetworkManager.defaultManager?.UrlWithRoot(url!)])
                    }
                    _=alert.addButton(loadLanguage("我知道了"), action:{})
                    _=alert.showInfo("", subTitle: loadLanguage("你的滤芯即将到期，请及时更换滤芯，以免耽误您的使用"))
                    
                    
                    
                }
                
                
                }, failure: { (error) in
                    weakSelf?.delegate.FilterValueChange!(value: -1)
            })
            
            }) { (error) in
                weakSelf?.delegate.FilterValueChange!(value: -1)
        }
    }
}
