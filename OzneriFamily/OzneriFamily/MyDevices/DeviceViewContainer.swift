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
    @objc optional func WhitchCenterViewIsHiden(MainIsHiden:Bool,BateryIsHiden:Bool,FilterIsHiden:Bool,BottomValue:CGFloat)->Void
    @objc optional func BateryValueChange(value:Int)->Void//0-100，<0表示无
    @objc optional func FilterValueChange(value:Int)->Void//0-100，<0表示无
    // 页面跳转
    @objc optional func DeviceViewPerformSegue(SegueID:String)->Void//跳转到storyboard 中连线的Controller
    
    
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
            LoginManager.currentDeviceIdentifier=nil
        
        }else{
            device=deviceArr.object(at: 0) as? OznerDevice
            if LoginManager.currentDeviceIdentifier != nil {
                for item in deviceArr {
                    if (item as! OznerDevice).identifier==LoginManager.currentDeviceIdentifier {
                        device=item as? OznerDevice
                        break
                    }
                }
                
            }
            //是不是当前设备
            LoginManager.currentDeviceIdentifier=device?.identifier
            if currentDevice != nil {
                if LoginManager.currentDeviceIdentifier==currentDevice?.identifier {
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
        .TDSPan:"TDSPanMainView",
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
        
        if device==nil {
            //无设备时视图初始化
            delegate.DeviceNameChange!(name: "首页")
            delegate.DeviceConnectStateChange!(stateDes: "")
            delegate.WhitchCenterViewIsHiden!(MainIsHiden: true, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
            
        }else{//有设备时视图初始化
            switch  OznerDeviceType(rawValue: (currentDevice?.type)!)! {
            case .Cup:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:160*height_screen/667)
                //(currentDeviceView as! CupMainView).circleView.updateCircleView(angle: 0.7)
                
            case .Tap:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: false,BottomValue:200*height_screen/667)
                
                //(currentDeviceView as! TapMainView).circleView.updateCircleView(angle: 0.7)
                
            case .TDSPan:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
                
            case .Water_Wifi:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:160*height_screen/667)
                
                //(currentDeviceView as! WaterPurifierMainView).circleView.updateCircleView(angleBefore: 0.7, angleAfter: 0.5)
                
            case .Air_Blue:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*height_screen/667)
                
            case .Air_Wifi:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*height_screen/667)
                
            case .WaterReplenish:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:156*height_screen/667)
                
            }
            
        }
        
    }
}
//OznerDeviceDelegate设备数据更新代理
extension DeviceViewContainer:OznerDeviceDelegate{
    //传感器数据变化
    
    func oznerDeviceSensorUpdate(_ device: OznerDevice!) {
        if CheckIsCurrentDevice(device: device) == true {
            currentDeviceView.SensorUpdate(device: device)
        }
    }
    //连接状态变化
    func oznerDeviceStatusUpdate(_ device: OznerDevice!) {
        if CheckIsCurrentDevice(device: device) == true {
            //解析当前状态
            delegate.DeviceConnectStateChange!(stateDes: "Status???")
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
