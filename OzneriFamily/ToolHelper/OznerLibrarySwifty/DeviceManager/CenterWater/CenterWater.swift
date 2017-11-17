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
    
    private(set) var centerInfo:(todayW:Int,sumW:Int,filter:Int,userMode:Int,Cmd_CtrlDevice:Int) = (0,0,0,0,0){
        
        didSet {
            if centerInfo != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
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
        
        for item in JSON.init(recvDic).arrayValue {
            switch item["key"].stringValue {
            case "WaterUsageCnt":
                //                    tmpSensor.PM25 = item["value"].intValue
                tmpCenter.todayW = item["value"].intValue
                break
            case "FilterUsageAmount":
                tmpCenter.sumW = item["value"].intValue
                break
            case "Online":
                self.connectStatus = item["value"].intValue==1 ? OznerConnectStatus.Connected:OznerConnectStatus.Disconnect
                break
            case "Cmd_CtrlDevice":
                tmpCenter.Cmd_CtrlDevice = item["value"].intValue
                break
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
            case "CHILDLOCK":
                //                    tmpStatus.Lock = item["value"].intValue==1
                break
                //                case "POWER":
                //                    tmpStatus.Power = item["value"].intValue==1
            //                    break
            default:
                break
            }
        }
        
        centerInfo = tmpCenter
        centerConfig = tmpConfig
    }
    
    override func doWillInit() {
        super.doWillInit()
        
        User.getGPRSInfo(deviceType: "Test_CentralPurifier", deviceID: self.deviceInfo.deviceID) { (data) in
            //            let json = data as! [String:AnyObject]
            let json = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            print(json)
            let needData = try! JSONSerialization.data(withJSONObject: json["values"] ?? "", options: JSONSerialization.WritingOptions.prettyPrinted)
            self.OznerBaseIORecvData(recvData: needData)
        }
        
    }

}
