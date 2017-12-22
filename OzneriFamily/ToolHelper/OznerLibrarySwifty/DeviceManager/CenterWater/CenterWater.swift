//
//  CenterWater.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/11/6.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/6  上午9:07
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import SwiftyJSON

class CenterWater: OznerBaseDevice {

    private(set) var centerInfo:(todayW:Int,sumW:Int,filter:Int,userMode:Int,Cmd_CtrlDevice:Int,Flowstatus:Int,WashTimeInterval:Int) = (0,0,0,0,1,-1,0){
        
        didSet {
            if centerInfo != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
//                self.delegate?.OznerDevicefilterUpdate!(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    
    private(set) var centerConfig:(HomeWashCycle:Int,TravelWashCycle:Int,WaterLimit_1Cycle:Int,HomeNtvTime:Int,HomePtvTime:Int,TravelPtvTime:Int,TravelNtvTime:Int,WashTimeNode:Int) = (0,0,0,0,0,0,0,0) {
        
        didSet {
            if centerConfig != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
            }
        }

    }
    
    override func OznerBaseIORecvData(recvData: Data) {
        super.OznerBaseIORecvData(recvData: recvData)
        
        guard self.deviceInfo.wifiVersion == 3 else {
            return
        }
        
        //接受并解析数据
        var tmpCenter = centerInfo
        var tmpConfig = centerConfig
        
        let recvDic = try! JSONSerialization.jsonObject(with: recvData, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, Any>]
        
        var FilterLifeInit:Float = 0
        var FilterUsageAmount:Float = 0
        
        for item in JSON.init(recvDic).arrayValue {
            switch item["key"].stringValue {
            case "WashTimeInterval":
                tmpCenter.WashTimeInterval = item["value"].intValue
                break

            case "WaterUsageCnt":
                //                    tmpSensor.PM25 = item["value"].intValue
                tmpCenter.todayW = item["value"].intValue
                break
            case "WaterTotalAmount":
                tmpCenter.sumW = item["value"].intValue
                break
            case "Online":
                self.connectStatus = item["value"].boolValue ? OznerConnectStatus.Connected:OznerConnectStatus.Disconnect
                break
//            case "Cmd_CtrlDevice":
//                tmpCenter.Cmd_CtrlDevice = item["value"].intValue
//                break
            case "UserMode":
                tmpCenter.userMode =  item["value"].intValue
                break
            case "HomeWashCycle":
                tmpConfig.HomeWashCycle = item["value"].intValue
                break
            case "TravelWashCycle":
                tmpConfig.TravelWashCycle = item["value"].intValue
                break
            case "WaterLimit_1Cycle":
                tmpConfig.WaterLimit_1Cycle = item["value"].intValue
                break
            case "WashTimeNode":
                tmpConfig.WashTimeNode = item["value"].intValue
                break
            case "HomeNtvTime":
                tmpConfig.HomeNtvTime = item["value"].intValue
                break
            case "HomePtvTime":
                tmpConfig.HomePtvTime = item["value"].intValue
                break
            case "TravelNtvTime":
                tmpConfig.TravelNtvTime = item["value"].intValue
                break
            case "TravelPtvTime":
                tmpConfig.TravelPtvTime = item["value"].intValue
                break
            case "FilterLifeInit":
                FilterLifeInit = Float(item["value"].intValue)
                break
            case "FilterUsageAmount":
                FilterUsageAmount = Float(item["value"].intValue)
                break
            case "Flowstatus":
                tmpCenter.Flowstatus = item["value"].intValue
                break
                //                case "POWER":
                //                    tmpStatus.Power = item["value"].intValue==1
            //                    break
            case "SystemStatus":
                tmpCenter.Cmd_CtrlDevice = item["value"].intValue
                break
          
            default:
                break
            }
        }
        
        if FilterLifeInit != 0 {
           
            tmpCenter.filter =  Int((Double(1 - FilterUsageAmount/FilterLifeInit)).roundTo(2) * 100)
        }
        
        centerInfo = tmpCenter
        centerConfig = tmpConfig
    }
    
    override func SendDataToDevice(sendData: Data, CallBack callback: ((Error?) -> Void)?) {
        super.SendDataToDevice(sendData: sendData, CallBack: callback)
        
    }
    
    override func doWillInit() {
        super.doWillInit()
        self.connectStatus = .Connecting
        
        User.getGPRSInfo(deviceType: "Test_CentralPurifier", deviceID: self.deviceInfo.deviceID, success: { (data) in
            
            let json = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            print(json)
            let needData = try! JSONSerialization.data(withJSONObject: json["values"] ?? "", options: JSONSerialization.WritingOptions.prettyPrinted)
            self.OznerBaseIORecvData(recvData: needData)
            
        }, failure: { (error) in
            
            DispatchQueue.main.async {
                appDelegate.window?.noticeOnlyText("请求失败请重试")
            }
            
        })
    
        
    }

    

}
