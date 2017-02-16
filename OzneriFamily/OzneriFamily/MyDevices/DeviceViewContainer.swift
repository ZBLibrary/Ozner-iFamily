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
    private let DeviceNibName:[OznerDeviceType:String]=[
        OznerDeviceType.Cup:"CupMainView",
        .Tap:"TapMainView",
        .TDSPan:"TapMainView",
        .Water_Wifi:"WaterPurifierMainView",
        .Air_Blue:"Air_BlueMainView",
        .Air_Wifi:"Air_WifiMainView",
        .WaterReplenish:"WaterReplenishMainView",
        .Water_Bluetooth:"WaterPurifierMainView"
    ]
    private func SelectWitchView(device:OznerDevice?)  {
        
        
        currentDevice=device
        var deviceNibName =  "NoDeviceView"
        if device != nil  {//有设备时视图初始化
            let tmpType=OznerDeviceType.getType(type: (device?.type)!)
            deviceNibName=DeviceNibName[tmpType]!
            currentDevice?.delegate=self
            delegate.DeviceNameChange!(name: (currentDevice?.settings.name)!)
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
            
        }else{//有设备时视图初始化
            currentDeviceView.currentDevice=device
            switch  OznerDeviceType.getType(type: (currentDevice?.type)!) {
            case .Cup:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:160*k_height)
            case .Tap:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: false,BottomValue:230*k_height)
                //下载滤芯更新
                User.FilterService(deviceID: (currentDevice?.identifier)!, success: { (usedDay, _) in
                    self.LvXinValue=Int(ceil(100.0*(30.0-Float(usedDay))/30.0))
                    }, failure: { (error) in
                        print(error)
                })
            case .TDSPan:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:0)
            case .Water_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:180*k_height)
                //设置滤芯及功能
                SetWaterPurifer(devID: (currentDevice?.identifier)!)
            case .Air_Blue:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*k_height)
            case .Air_Wifi:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:210*k_height)
            case .WaterReplenish:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:170*k_height)
                
            case .Water_Bluetooth:
                delegate.WhitchCenterViewIsHiden!(SettingIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:160*k_height)
                //隐藏底部按钮
                (currentDeviceView as! WaterPurifierMainView).isBlueDevice=true
                (currentDeviceView as! WaterPurifierMainView).footerContainer.isHidden=true
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
            
            //滤芯电量或电池电量
            switch OznerDeviceType.getType(type: device.type) {
            case .Cup:
                batteryValue = Int((currentDevice as! Cup).sensor.powerPer()*100)
            case .Tap:
                batteryValue = Int((currentDevice as! Tap).sensor.powerPer()*100)
            case .TDSPan:
                batteryValue = Int((currentDevice as! Tap).sensor.powerPer()*100)
            case .Air_Blue:
                //设置滤芯
                let workTime=Int((currentDevice as! AirPurifier_Bluetooth).status.filterStatus.workTime)
                var lvxinValue=1-CGFloat(workTime)/CGFloat(60000)
                lvxinValue=min(1, lvxinValue)
                lvxinValue=max(0, lvxinValue)
                self.LvXinValue=Int(lvxinValue*100)
            case .Air_Wifi:
                if let filterStatus=(currentDevice as! AirPurifier_MxChip).status.filterStatus
                {
                    let workTime=Int(filterStatus.workTime)
                    var lvxinValue=1-CGFloat(workTime)/CGFloat(129600)
                    lvxinValue=min(1, lvxinValue)
                    lvxinValue=max(0, lvxinValue)
                    self.LvXinValue=Int(lvxinValue*100)
                }
            case .Water_Wifi:
                break
            case .WaterReplenish:
                batteryValue = Int((currentDevice as! WaterReplenishmentMeter).status.battery*100)
            case .Water_Bluetooth:
                let tmpDev=currentDevice as! ROWaterPurufier
                let lvxinValue=min(tmpDev.filterInfo.filter_A_Percentage, tmpDev.filterInfo.filter_B_Percentage, tmpDev.filterInfo.filter_C_Percentage)
                self.LvXinValue=Int(lvxinValue)
            }
        }
    }
    //连接状态变化
    func oznerDeviceStatusUpdate(_ device: OznerDevice!) {
        if CheckIsCurrentDevice(device: device) == true {
            currentDeviceView.currentDevice=device
           
            switch OznerDeviceType.getType(type: (device?.type)!) {
            case .Cup,.Tap,.TDSPan,.Air_Blue,.WaterReplenish,.Water_Bluetooth:
                //解析当前状态
                switch device.connectStatus() {
                case Connecting:
                    delegate.DeviceConnectStateChange!(stateDes: "正在连接中...")
                case Disconnect:
                    delegate.DeviceConnectStateChange!(stateDes: "设备已断开")
                case Connected:
                    delegate.DeviceConnectStateChange!(stateDes: "设备已连接")
                default://已连接
                    delegate.DeviceConnectStateChange!(stateDes: "")
                }
                
                break
            default:
                delegate.DeviceConnectStateChange!(stateDes: "")
                break
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

//    //大空净设备滤芯
//    func setBigAirLvXin() {
//        //设置滤芯
//        if let filterStatus=(currentDevice as! AirPurifier_MxChip).status.filterStatus
//        {
//            setAirLvXin(workTime: Int(filterStatus.workTime), maxTime: 129600)
//            
//        }else{
//            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(setBigAirLvXin), userInfo: nil, repeats: false)
//        }
//    }
    
    
//    //空净滤芯状态
//    func setAirLvXin(workTime:Int,maxTime:Int) {
//        var lvxinValue=1-CGFloat(workTime)/CGFloat(maxTime)
//        lvxinValue=min(1, lvxinValue)
//        lvxinValue=max(0, lvxinValue)
//        self.LvXinValue=Int(lvxinValue*100)
//    }
    //设置净水器滤芯、型号、链接地址、是否提醒
    func SetWaterPurifer(devID:String){
        weak var weakSelf=self
        User.GetMachineType(deviceID: devID, success: { (scanEnable, coolEnable, hotEnable, machineType, buyURL, alertDays) in
            let url = buyURL=="" ? NetworkManager.defaultManager?.URL?["goodsDetail9"]?.stringValue:buyURL
           
            User.GetMachineLifeOutTime(deviceID: devID, success: { (usedDays, stopDate) in
                let useValue=ceil(Double(100*(365-usedDays)/365))
                
                //TODO: Crash
                //Could not cast value of type 'OzneriFamily.TapMainView' (0x100510288) to 'OzneriFamily.WaterPurifierMainView' (0x10050e460).
                //Could not cast value of type 'OzneriFamily.Air_WifiMainView' (0x10048b9b0) to 'OzneriFamily.WaterPurifierMainView' (0x10048a4e0).
                //  2017-01-12 13:36:36.140786 OzneriFamily[10292:2525582] Could not cast value of type 'OzneriFamily.Air_WifiMainView' (0x10048b9b0) to 'OzneriFamily.WaterPurifierMainView' (0x10048a4e0).
                 (weakSelf?.currentDeviceView as? WaterPurifierMainView)?.setLvXinAndEnable(scan: scanEnable, cool: coolEnable, hot: hotEnable, buyLvXinUrl: url!, lvXinStopDate: stopDate as NSDate, lvXinUsedDays: Int(useValue))
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
                        weakSelf?.delegate.DeviceViewPerformSegue!(SegueID: "showBuyLvXin", sender: ["title":"净水器滤芯","url":NetworkManager.defaultManager?.UrlWithRoot(url!)])
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
//    func SetRoWaterPuriferLvXin()  {
//      
//        let tmpDev=currentDevice as! ROWaterPurufier
//        let lvxinValue=min(tmpDev.filterInfo.filter_A_Percentage, tmpDev.filterInfo.filter_B_Percentage, tmpDev.filterInfo.filter_C_Percentage)
//        self.LvXinValue=Int(lvxinValue)
//    }
}
