//
//  AirPurifier_Wifi.swift
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2016/12/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class AirPurifier_Wifi: OznerBaseDevice {

    //添加个性字段
    //对外只读，对内可读写
    private(set) var sensor:(Temperature:Int,Humidity:Int,PM25:Int,VOC:Int,TotalClean:Int)=(0,0,0,0,0){
        didSet{
            if sensor != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    private(set) var status:(Power:Bool,Lock:Bool,Speed:Int)=(false,false,0){
        didSet{
            if status != oldValue {
                self.delegate?.OznerDeviceStatusUpdate!(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    private(set) var filterStatus:(starDate:Date,stopDate:Date,workTime:Int,maxWorkTime:Int) = (Date(timeIntervalSinceNow: 0),Date(timeIntervalSinceNow: 0),0,129600){
        didSet{
            if filterStatus != oldValue {
                self.delegate?.OznerDevicefilterUpdate?(identifier: self.deviceInfo.deviceID)
            }
            
        }
    }
    func getHFData(arr:Any) -> Data {
        return try! JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
    func setPower(power:Bool,callBack:((_ error:Error?)->Void)) {
        if self.deviceInfo.wifiVersion == 3 {
            let data = getHFData(arr: [["key":"POWER","value":power,"type":"Boolean","updateTime":Date().timeIntervalSince1970]])
            
            self.SendDataToDevice(sendData: data, CallBack: nil)
        }else{
            setSwitchData(code: 0x00, data: Data.init(bytes: [UInt8(power.hashValue)]))
        }
        
    }
    
    
    //#define FAN_SPEED_AUTO      0
    //#define FAN_SPEED_HIGH      1
    //#define FAN_SPEED_MID       2
    //#define FAN_SPEED_LOW       3
    //#define FAN_SPEED_SILENT    4
    //#define FAN_SPEED_POWER     5
    func setSpeed(speed:Int,callBack:((_ error:Error?)->Void)) {
        if self.deviceInfo.wifiVersion == 3 {
            let data = getHFData(arr: [["key":"WINDSPEED","value":speed,"type":"Integer","updateTime":Date().timeIntervalSince1970]])
            
            self.SendDataToDevice(sendData: data, CallBack: nil)
        }else{
             setSwitchData(code: 0x01, data: Data.init(bytes: [UInt8(speed)]))
        }
       
    }
    func setLock(lock:Bool,callBack:((_ error:Error?)->Void)) {
        if self.deviceInfo.wifiVersion == 3 {
            let data = getHFData(arr: [["key":"CHILDLOCK","value":lock,"type":"Boolean","updateTime":Date().timeIntervalSince1970]])
            
            self.SendDataToDevice(sendData: data, CallBack: nil)
        }else{
            setSwitchData(code: 0x03, data: Data.init(bytes: [UInt8(lock.hashValue)]))
        }
        
    }
    private func setSwitchData(code:UInt8,data:Data) {
        self.SendDataToDevice(sendData: setProperty(code: code, data: data), CallBack: nil)
        self.reqesutProperty(data: Data.init(bytes: [0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03]))
    }
    override func OznerBaseIORecvData(recvData: Data) {
        super.OznerBaseIORecvData(recvData: recvData)
        var tmpStatus = status
        var tmpSensor = sensor
        var tmpFilterStatus = filterStatus
        if self.deviceInfo.wifiVersion == 3 {//汉枫解析
            let recvDic = try! JSONSerialization.jsonObject(with: recvData, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, Any>]
            
            for item in JSON.init(recvDic).arrayValue {
                switch item["key"].stringValue {
                case "PM25":
                    tmpSensor.PM25 = item["value"].intValue
                case "VOCVAL":
                    tmpSensor.VOC = item["value"].intValue
                case "Online":
                    self.connectStatus = item["value"].intValue==1 ? OznerConnectStatus.Connected:OznerConnectStatus.Disconnect
                case "TIMEFIX1":
                    //filterStatus.starDate = item["value"].intValue
                    break
                case "TEMPERATURE":
                    tmpSensor.Temperature = item["value"].intValue
                case "HUMIDITY":
                    tmpSensor.Humidity = item["value"].intValue
                case "WINDSPEED":
                    tmpStatus.Speed = item["value"].intValue
                case "CHILDLOCK":
                    tmpStatus.Lock = item["value"].intValue==1
                case "POWER":
                    tmpStatus.Power = item["value"].intValue==1
                default:
                    break
                }
            }
        }else{
            //解析数据并更新个性字段
            requestCount=0
            if (UInt8(recvData[0]) != 0xFA )
            {
                return
            }
            if Int(recvData[1])+Int(recvData[2])*256<=0 {
                return
            }
            if UInt8(recvData[3]) == 0x4 {
                var p = 13
                if recvData.count<16{
                    return
                }
                for _ in 0..<Int(recvData[12]) {
                    
                    let keyOfData = UInt8(recvData[p])
                    p+=1
                    let size = Int(recvData[p])
                    p+=1
                    if p+size>recvData.count {
                        return
                    }
                    let range1 = recvData.index(recvData.startIndex, offsetBy: p)
                    let range2 = recvData.index(recvData.startIndex, offsetBy: p+size)
                    let valueData=recvData.subdata(in: Range(range1..<range2))
                    p+=size
                    if valueData.count<=0 {
                        continue
                    }
                    switch keyOfData {
                    case 0x04://PROPERTY_POWER_TIMER
                        break
                    case 0x00://PROPERTY_POWER
                        tmpStatus.Power=(Int(valueData[0]) != 0)
                    case 0x02://PROPERTY_LIGHT
                        break
                    case 0x03://PROPERTY_LOCK
                        tmpStatus.Lock=(Int(valueData[0]) != 0)
                        break
                    case 0x01://PROPERTY_SPEED
                        tmpStatus.Speed=Int(valueData[0])
                        break
                    case 0x15://PROPERTY_FILTER
                        if valueData.count>=16 {
                            let startInt = Int(valueData[0])+256*Int(valueData[1])+256*256*Int(valueData[2])
                            tmpFilterStatus.starDate=Date(timeIntervalSince1970: TimeInterval(startInt+256*256*256*Int(valueData[3])))
                            let workTimeInt = Int(valueData[4])+256*Int(valueData[5])+256*256*Int(valueData[6])
                            tmpFilterStatus.workTime=workTimeInt+256*256*256*Int(valueData[7])
                            
                            let stopInt = Int(valueData[8])+256*Int(valueData[9])+256*256*Int(valueData[10])
                            tmpFilterStatus.stopDate=Date(timeIntervalSince1970: TimeInterval(stopInt+256*256*256*Int(valueData[11])))
                            let maxInt = Int(valueData[12])+256*Int(valueData[13])+256*256*Int(valueData[14])
                            tmpFilterStatus.maxWorkTime=maxInt+256*256*256*Int(valueData[15])
                        }
                    case 0x11://PROPERTY_PM25
                        tmpSensor.PM25=Int(valueData[0])+256*Int(valueData[1])
                    case 0x12://PROPERTY_TEMPERATURE
                        tmpSensor.Temperature=Int(valueData[0])+256*Int(valueData[1])
                    case 0x13://PROPERTY_VOC
                        tmpSensor.VOC=Int(valueData[0])+256*Int(valueData[1])
                    case 0x18://PROPERTY_HUMIDITY
                        tmpSensor.Humidity=Int(valueData[0])+256*Int(valueData[1])
                    case 0x14://PROPERTY_LIGHT_SENSOR
                        break
                    case 0x19://PROPERTY_TOTAL_CLEAN
                        let cleanValue = Int(valueData[0])+256*Int(valueData[1])+256*256*Int(valueData[2])
                        tmpSensor.TotalClean = (cleanValue+256*256*256*Int(valueData[3]))/1000
                    default:
                        break
                    }
                    
                }
 
            }
        }
        status = tmpStatus
        sensor = tmpSensor
        filterStatus = tmpFilterStatus
        
        
    }
    override func doWillInit() {
        super.doWillInit()
         if self.deviceInfo.wifiVersion == 3 {
            Helper.getHFData("http://iot.ozner.net:1885", requestParams: ["deviceType":self.deviceInfo.deviceType,"deviceId":self.deviceInfo.deviceMac.lowercased().replacingOccurrences(of: ":", with: "")], finish: { (response, data, error) in
                
                if data==nil{
                    return
                }
                let recvDic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSMutableDictionary
                print(recvDic)
                let needData = try! JSONSerialization.data(withJSONObject: recvDic["values"] ?? "", options: JSONSerialization.WritingOptions.prettyPrinted)
                self.OznerBaseIORecvData(recvData: needData)
            })
         }else{
            self.setTime()
            sleep(1)
            let data = Data.init(bytes: [0x15,0x21,0x22,0x24,0x23,0x26,0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03])
            self.reqesutProperty(data: data)
        }
        
    }
    var requestCount = 0//请求三次没反应代表机器断网
    override func repeatFunc() {
        if self.deviceInfo.wifiVersion != 3 {
            if Int(arc4random()%2)==0 {
                self.reqesutProperty(data: Data.init(bytes: [0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03,0x19,0x26]))
                requestCount=(requestCount+1)
                if requestCount>=3 {
                    self.connectStatus = .Disconnect
                }
            }
        }
        
    }
    
    
    
    private func setTime()  {
        let tmpTime = Date().timeIntervalSince1970
        let tmpData = OznerTools.dataFromInt(number: CLongLong(tmpTime), length: 4)
        let data=self.setProperty(code: 0x16, data: tmpData)//PROPERTY_TIME
        self.SendDataToDevice(sendData: data) { (error) in}
    }
    
    //data数据处理
    private func setProperty(code:UInt8,data:Data)->Data
    {
        let len = 13+data.count
        var dataNeed = Data.init(bytes: [0xfb,UInt8(len%256),UInt8(len/256),0x2])
        let macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        dataNeed.append(macData!)
        dataNeed.insert(UInt8(0), at: 10)
        dataNeed.insert(UInt8(0), at: 11)
        dataNeed.insert(code, at: 12)
        dataNeed.append(data)
        return dataNeed
    }
    private func reqesutProperty(data:Data)
    {
        let len = 13+data.count
        var dataNeed = Data.init(bytes: [0xfb,UInt8(len%256),UInt8(len/256),0x1])
        let macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        dataNeed.append(macData!)
        dataNeed.insert(UInt8(0), at: 10)
        dataNeed.insert(UInt8(0), at: 11)
        dataNeed.insert(UInt8(data.count), at: 12)
        dataNeed.append(data)
        self.SendDataToDevice(sendData: dataNeed, CallBack: nil)
    }
    override func describe() -> String {
        return "name:\(self.settings.name!)\n connectStatus:\(self.connectStatus)\n TotalClean:\(self.sensor.TotalClean),Temperature:\(self.sensor.Temperature),PM25:\(self.sensor.PM25),Humidity:\(self.sensor.Humidity),VOC:\(self.sensor.VOC)\n 电源:\(self.status.Power)\n,童锁:\(self.status.Lock)\n,风速:\(self.status.Speed)\n 滤芯:\(self.filterStatus)\n"
    }
}
