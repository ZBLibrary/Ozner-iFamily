//
//  CenterWaterView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/11/2.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/2  上午9:12
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class CenterWaterView: OznerDeviceView{

    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var leftWaveView: ASongWaterWaveView!
    
    @IBOutlet weak var rightWaveView: ASongWaterWaveView!
    
    
    @IBOutlet weak var outLb: UILabel!
    @IBOutlet weak var outImage: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var homeMode: UILabel!
    
    var currentMode:Int = 666
    var isWash:Int = 888
    override func awakeFromNib() {
        super.awakeFromNib()

        leftWaveView.layer.cornerRadius = leftWaveView.frame.width/2
        leftWaveView.layer.masksToBounds = true
        
        rightWaveView.layer.cornerRadius = leftWaveView.frame.width/2
        rightWaveView.layer.masksToBounds = true
   
        centerBtnBlueBg(true)
        
    }
    
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        let device = self.currentDevice as? CenterWater
        guard self.currentDevice?.connectStatus == .Connected else {
            self.noticeOnlyText("请检查设备连接状态")
            return
        }
        
        switch sender.tag {
        case 665:
            if isWash == 899 {
//                self.noticeOnlyText("当前正在进行冲洗")
               self.noticeOnlyText("当前状态无法设置")
                return
            }
            
            let model = MqttSendStruct(key: "Cmd_CtrlDevice", value: 1, type: "Integer")
            self.currentDevice?.SendDataToDevice(sendData: OznerTools.mqttModelToData([model]), CallBack: { (error) in

            })
            self.noticeOnlyText("已发送")
            return
        case 666:
            if currentMode == 666 {
                self.noticeOnlyText("当前模式已为居家模式")
                return
            }
            
            break
        case 667:
            if currentMode == 667 {
                self.noticeOnlyText("当前模式已为出差模式")
                return
            }
            if device?.centerInfo.Flowstatus == 1 {
                self.noticeOnlyText("通水状态下无法设置")
                return
            }
            break
        default:
            break
        }
        let value = sender.tag == 666 ? 0 : 1
        
        let model = MqttSendStruct(key: "UserMode", value: value, type: "Integer")

        device?.SendDataToDevice(sendData: OznerTools.mqttModelToData([model]), CallBack: { (error) in
            print(error)
        })
        self.noticeOnlyText("已发送")

        
    }
    
    override func SensorUpdate(identifier: String) {
        super.SensorUpdate(identifier: identifier)
        
        let device = self.currentDevice as? CenterWater
        leftWaveView.asongLabel.text = String(describing: (device?.centerInfo.todayW) ?? 0) + "L"
        rightWaveView.asongLabel.text = String(describing: (device?.centerInfo.sumW) ?? 0) + "L"
//        centerBtn.backgroundColor = (device?.centerInfo.Cmd_CtrlDevice == 0) ? UIColor.blue : UIColor.white
        centerBtnBlueBg(device?.centerInfo.Cmd_CtrlDevice == 1)
        
        modeIsTrue(device?.centerInfo.userMode == 0)
        
    }
    
    fileprivate func modeIsTrue(_ isBool:Bool) {
        
        currentMode = isBool ? 666 : 667
        
        homeImage.image = isBool ? UIImage(named: "居家模式") : UIImage(named: "居家模式-二态")
        outImage.image = isBool ? UIImage(named: "出差模式-二态"): UIImage(named: "居家模式")
        homeMode.textColor = isBool ? UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0) :  UIColor(red: 170 / 255.0, green: 170 / 255.0, blue: 170 / 255.0, alpha: 1.0)
        outLb.textColor = isBool ? UIColor(red: 170 / 255.0, green: 170 / 255.0, blue: 170 / 255.0, alpha: 1.0) : UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
        
    }
    
    fileprivate func centerBtnBlueBg(_ isBLue:Bool) {
        
        isWash = isBLue ? 888 : 899
        centerBtn.layer.cornerRadius = 23
        centerBtn.layer.masksToBounds = true

        if !isBLue {
            
            centerBtn.backgroundColor = UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
            centerBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            let device = self.currentDevice as? CenterWater
            
            guard device != nil else {
                return
            }
            
            var stateStr = "正在冲洗"
            switch device!.centerInfo.Cmd_CtrlDevice {
                case 2,3,4,5,6:
                    break
                case 0:
                    stateStr = "休眠中"
                    break
                default:
                    break
            }
            
            centerBtn.setTitle(stateStr, for: UIControlState.normal)
            return
        }
        
        centerBtn.layer.borderColor = UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0).cgColor
        centerBtn.setTitleColor(UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0), for: UIControlState.normal)
        centerBtn.setTitle("立即启动冲洗", for: UIControlState.normal)
        centerBtn.backgroundColor = UIColor.white
        centerBtn.layer.borderWidth = 2
        
    }
    
}
