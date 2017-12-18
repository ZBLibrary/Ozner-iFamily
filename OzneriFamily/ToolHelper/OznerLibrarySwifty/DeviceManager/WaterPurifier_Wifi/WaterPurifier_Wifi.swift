//
//  WaterPurifier_Wifi.swift
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2017/1/12.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class WaterPurifier_Wifi: OznerBaseDevice {
    
    //添加个性字段
    //对外只读，对内可读写
    private(set) var sensor:(TDS_Before:Int,TDS_After:Int,Temperature:Float)=(0,0,0.0){
        didSet{
            if sensor != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    private(set) var status:(Power:Bool,Cool:Bool,Hot:Bool,Sterilization:Bool)=(false,false,false,false){
        didSet{
            if status != oldValue {
                self.delegate?.OznerDeviceStatusUpdate!(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    
    private(set) var filterStates:(filterA:Int,filterB:Int,filterC:Int,TDS_Before:Int,TDS_After:Int)=(0,0,0,0,0){
        didSet {
            if filterStates != oldValue {
                self.delegate?.OznerDeviceStatusUpdate!(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    
    func setPower(Power:Bool,callBack:((_ error:Error?)->Void)) {
        
        if self.deviceInfo.wifiVersion == 3 {
            
            DispatchQueue.main.async {
                appDelegate.window?.noticeOnlyText("此机型暂无此功能")
            }
            
        } else {
                setStatus(data: Data.init(bytes: [UInt8(status.Hot.hashValue),UInt8(status.Cool.hashValue),UInt8(Power.hashValue),UInt8(status.Sterilization.hashValue)]))
        }
        
 
    }
    func setCool(Cool:Bool,callBack:((_ error:Error?)->Void)) {
        if self.deviceInfo.wifiVersion == 3 {
            DispatchQueue.main.async {
                appDelegate.window?.noticeOnlyText("此机型暂无此功能")
            }
        } else {
        setStatus(data: Data.init(bytes: [UInt8(status.Hot.hashValue),UInt8(Cool.hashValue),UInt8(status.Power.hashValue),UInt8(status.Sterilization.hashValue)]))
        }
    }
    func setHot(Hot:Bool,callBack:((_ error:Error?)->Void)) {
        if self.deviceInfo.wifiVersion == 3 {
            DispatchQueue.main.async {
                appDelegate.window?.noticeOnlyText("此机型暂无此功能")
            }
        } else {
        setStatus(data: Data.init(bytes: [UInt8(Hot.hashValue),UInt8(status.Cool.hashValue),UInt8(status.Power.hashValue),UInt8(status.Sterilization.hashValue)]))
        }
    }
    func setSterilization(Sterilization:Bool,callBack:((_ error:Error?)->Void)) {
       setStatus(data: Data.init(bytes: [UInt8(status.Hot.hashValue),UInt8(status.Cool.hashValue),UInt8(status.Power.hashValue),UInt8(Sterilization.hashValue)]))
    }
    private func setStatus(data:Data) {
        let needData=self.MakeWoodyBytes(code: 0xfa, Opcode: 0x02, data: data)
        self.SendDataToDevice(sendData: needData, CallBack: nil)
        reqeusetStatus()
    }
    
    override func OznerBaseIORecvData(recvData: Data) {
        super.OznerBaseIORecvData(recvData: recvData)
        var tmpStatus = status
        var tmpSensor = sensor
        if self.deviceInfo.wifiVersion == 3 {//汉枫解析
            let recvDic = try! JSONSerialization.jsonObject(with: recvData, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, Any>]
            
            for item in JSON.init(recvDic).arrayValue {
                switch item["key"].stringValue {
                case "TDS1":
//                    tmpSensor.PM25 = item["value"].intValue
                    tmpSensor.TDS_Before = item["value"].intValue
                    break
                case "TDS2":
                    tmpSensor.TDS_After = item["value"].intValue
                    break
                case "Online":
                    self.connectStatus = item["value"].intValue==1 ? OznerConnectStatus.Connected:OznerConnectStatus.Disconnect
                case "APercent":
                    filterStates.filterA = item["value"].intValue
                    break
                case "BPercent":
                    filterStates.filterB = item["value"].intValue
                    break
                case "CPercent":
                    filterStates.filterC = item["value"].intValue
                    break
                case "PowerOn":
                    tmpStatus.Power = item["value"].boolValue 
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
            
            status = tmpStatus
            sensor = tmpSensor

        } else {
            //解析数据并更新个性字段
            requestCount=0
            if (recvData.count < 10 )
            {
                return
            }
            
            let group = Int(recvData[0])
            let opCode = UInt8(recvData[3])
            if group == Int(0xFB) {
               
                
                switch opCode {
                case 0x01://Opcode_RespondStatus
                    
                    tmpStatus.Hot = Int(recvData[12])==1
                    tmpStatus.Cool = Int(recvData[13])==1
                    tmpStatus.Power = Int(recvData[14])==1
                    tmpStatus.Sterilization = Int(recvData[15])==1
                    
                    var tds1 = recvData.subInt(starIndex: 16, count: 2)
                    tds1 = tds1<0||tds1==65535 ? 0:tds1
                    var tds2 = recvData.subInt(starIndex: 18, count: 2)
                    tds2 = tds2<0||tds2==65535 ? 0:tds2
                    
                    tmpSensor.TDS_Before = max(tds1, tds2)
                    tmpSensor.TDS_After = min(tds1, tds2)
                    
                    if self.deviceInfo.wifiVersion == 2 {
                        tmpSensor.TDS_Before = min(max(tds1, tds2),999)
                        tmpSensor.TDS_After = min(min(tds1, tds2),50)
                    }
                  
                    tmpSensor.Temperature = Float(recvData.subInt(starIndex: 10, count: 2))/10.0
                    
                case 0x03://Opcode_DeviceInfo
                    
                    let tds1 = Int(recvData.subInt(starIndex: 71, count: 2))
                    let tds2 = Int(recvData.subInt(starIndex: 73, count: 2))
                    filterStates = (Int(recvData[116]),Int(recvData[117]),Int(recvData[118]),max(tds1, tds2),min(tds1, tds2))
                    break
                case 0x05:
                    
                    break
                default:
                    break
                }
                status = tmpStatus
                sensor = tmpSensor
            }
        }
       
    }
    override func doWillInit() {
        super.doWillInit()
        
        if self.deviceInfo.wifiVersion == 3 {
           
            User.getGPRSInfo(deviceType: "RoWater", deviceID: self.deviceInfo.deviceID) { (data) in
                //            let json = data as! [String:AnyObject]
                let json = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                print(json)
                let needData = try! JSONSerialization.data(withJSONObject: json["values"] ?? "", options: JSONSerialization.WritingOptions.prettyPrinted)
                self.OznerBaseIORecvData(recvData: needData)
            }

        }else{
        
        let needData=self.MakeWoodyBytes(code: 0xfa, Opcode: 0x05, data: Data())
        self.SendDataToDevice(sendData: needData, CallBack: nil)
        }
    }
    var requestCount = 0//请求三次没反应代表机器断网
    override func repeatFunc() {
        if self.deviceInfo.wifiVersion == 3 {
            return
        }
        
        if Int(arc4random()%2)==0 {
            requestCount+=1
            if requestCount>=3 {
                self.connectStatus = .Disconnect
            }
            self.reqeusetStatus()
        }
    }
    func reqeusetStatus() {
        
        if self.deviceInfo.productID == "adf69dce-5baa-11e7-9baf-00163e120d98" {
            
            let needData=self.MakeWoodyBytes(code: 0xfa, Opcode: 0x03, data: Data())
            self.SendDataToDevice(sendData: needData, CallBack: nil)
            
            return
        }
        
        let needData=self.MakeWoodyBytes(code: 0xfa, Opcode: 0x01, data: Data())
        self.SendDataToDevice(sendData: needData, CallBack: nil)
    }
    
    //data数据处理
    private func MakeWoodyBytes(code:UInt8,Opcode:UInt8,data:Data)->Data
    {
        let len = 13+data.count
        var dataNeed = Data.init(bytes: [code,UInt8(len%256),UInt8(len/256),Opcode])
        let macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        
        
        dataNeed.append(macData!)
        dataNeed.insert(UInt8(0), at: 10)
        dataNeed.insert(UInt8(0), at: 11)
        dataNeed.append(data)
        
        let pbuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: len-1)
        
        for index in 0...(len-2)
        {
            
            pbuffer[index] = dataNeed[index]
            
        }
        
        let lastByte=Helper.crc8(pbuffer, inLen: UInt16(len-1))
        dataNeed.append(lastByte)
        return dataNeed
    }
    private func reqesutProperty(data:Data)
    {
        let len = 13+data.count
        var dataNeed = Data.init(bytes: [0xfa,UInt8(len%256),UInt8(len/256),0x1])
        let  macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        
        dataNeed.append(macData!)
        dataNeed.insert(UInt8(0), at: 10)
        dataNeed.insert(UInt8(0), at: 11)
        dataNeed.insert(UInt8(data.count), at: 12)
        dataNeed.append(data)
        self.SendDataToDevice(sendData: dataNeed, CallBack: nil)
    }
    override func describe() -> String {
        return "设备名称:\(self.settings.name!)\n 连接状态:\(self.connectStatus)\n 净化前TDS:\(self.sensor.TDS_Before)\n 净化后TDS:\(self.sensor.TDS_After)\n 水温:\(self.sensor.Temperature)\n 电源:\(self.status.Power)\n 加热:\(self.status.Hot)\n 制冷:\(self.status.Cool)\n"
    }
    
}
