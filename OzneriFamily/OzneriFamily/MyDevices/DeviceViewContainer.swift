//
//  DeviceViewContainer.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
@objc public protocol DeviceViewContainerDelegate {
    @objc optional func AddNewDeviceClick()
    @objc optional func DeviceNameChange(name:String)->Void
    @objc optional func DeviceConnectStateChange(stateDes:String)->Void
    @objc optional func WhitchCenterViewIsHiden(MainIsHiden:Bool,BateryIsHiden:Bool,FilterIsHiden:Bool,BottomValue:CGFloat)->Void
    @objc optional func BateryValueChange(value:Int)->Void//0-100，<0表示无
    @objc optional func FilterValueChange(value:Int)->Void//0-100，<0表示无
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
    var delegate:DeviceViewContainerDelegate!
    func setDeviceView() {
        var device:OznerDevice?
        let deviceArr=OznerManager.instance().getDevices() as NSArray
        if deviceArr.count==0 {
            device=nil
            CurrentSelectDeviceID=nil
        }else{
            device=deviceArr.object(at: 0) as? OznerDevice
            if CurrentSelectDeviceID != nil {
                for item in deviceArr {
                    if (item as! OznerDevice).identifier==CurrentSelectDeviceID {
                        device=item as? OznerDevice
                        break
                    }
                }
                
            }
            CurrentSelectDeviceID=device?.identifier
        }
  
        
        for view in self.subviews {//移除视图
            view.removeFromSuperview()
        }
        //添加视图
        var deviceView:UIView!
        if device==nil {//无设备视图
            deviceView = Bundle.main.loadNibNamed("NoDeviceView", owner: nil, options: nil)?.first as! NoDeviceView
            (deviceView as! NoDeviceView).addDeviceClickBlock={self.delegate.AddNewDeviceClick!()}
            delegate.DeviceNameChange!(name: "首页")
            delegate.DeviceConnectStateChange!(stateDes: "")
            delegate.WhitchCenterViewIsHiden!(MainIsHiden: true, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
            
        }else{
            currentDevice=device
            currentDevice?.delegate=self
            
            delegate.DeviceNameChange!(name: (currentDevice?.settings.name)!)
            switch  OznerDeviceType(rawValue: (currentDevice?.type)!)! {
            case .Cup:
                deviceView = Bundle.main.loadNibNamed("CupMainView", owner: nil, options: nil)?.first as! CupMainView
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:160*height_screen/667)
                break
            case .Tap:
                deviceView = Bundle.main.loadNibNamed("TapMainView", owner: nil, options: nil)?.first as! TapMainView
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: false,BottomValue:211*height_screen/667)
                break
            case .TDSPan:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: true,BottomValue:0)
                break
            case .Water_Wifi:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*height_screen/667)
                break
            case .Air_Blue:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*height_screen/667)
                break
            case .Air_Wifi:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: true, FilterIsHiden: false,BottomValue:200*height_screen/667)
                break
            case .WaterReplenish:
                delegate.WhitchCenterViewIsHiden!(MainIsHiden: false, BateryIsHiden: false, FilterIsHiden: true,BottomValue:200*height_screen/667)
                break
//            default:
//                break
            }
            
        }
        deviceView.frame=self.frame
        self.addSubview(deviceView)
    }
}
extension DeviceViewContainer:OznerDeviceDelegate{
    func oznerDeviceSensorUpdate(_ device: OznerDevice!) {
        
    }
    func oznerDeviceStatusUpdate(_ device: OznerDevice!) {
        
    }
}
