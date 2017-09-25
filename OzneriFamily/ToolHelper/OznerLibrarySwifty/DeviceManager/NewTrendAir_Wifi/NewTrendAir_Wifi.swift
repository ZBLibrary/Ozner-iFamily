//
//  AirPurifier_Wifi.swift
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2016/12/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class NewTrendAir_Wifi: OznerBaseDevice {

    //添加个性字段
    //对外只读，对内可读写
    private(set) var sensor:(Temperature:Int,Humidity:Int,PM25_In:Int,PM25_Out:Int,CO2:Int,TVOC:Int,TotalClean:Int)=(0,0,0,0,0,0,0){
        didSet{
            //if sensor != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
            //}
        }
    }
    private(set) var status:(Power:Bool,Lock:Bool,AirAndSpeed:Int,NewAndSpeed:Int)=(false,false,0,0){
        didSet{
            //if status != oldValue {
                self.delegate?.OznerDeviceStatusUpdate!(identifier: self.deviceInfo.deviceID)
            //}
        }
    }
    private(set) var filterStatus:(starDate:Date,stopDate:Date,workTime:Int,maxWorkTime:Int) = (Date(timeIntervalSinceNow: 0),Date(timeIntervalSinceNow: 0),0,129600){
        didSet{
            //if filterStatus != oldValue {
                self.delegate?.OznerDevicefilterUpdate?(identifier: self.deviceInfo.deviceID)
            //}
            
        }
    }
    private(set) var appointTime:(onOffType:Int,onEveryDay:Int,offEveryDay:Int,offOnce:Int) = (0,0,0,0){
        didSet{
            //if filterStatus != oldValue {
            self.delegate?.OznerDevicefilterUpdate?(identifier: self.deviceInfo.deviceID)
            //}
            
        }
    }
    //0电源开关,1空净风速开关,2新风风速开关,3童锁开关
    func setControl(key:Int,callBack:((_ error:Error?)->Void)) {
        if key>3 || key<0{
            return
        }
        if self.connectStatus != .Connected {
            callBack(NSError.init(domain: "设备已断开连接", code: -1, userInfo: nil))
            return
        }
        if key != 0 && status.Power==false{
            callBack(NSError.init(domain: "电源开关未打开", code: -2, userInfo: nil))
            return
        }
        
        var data=Data()
        switch key {
        case 0:
            let value = !(status.Power)
            data.append(UInt8(value.hashValue))
        case 3:
            let value = !(status.Lock)
            data.append(UInt8(value.hashValue))
        case 1:
            let value = !Bool.init(NSNumber.init(value: status.AirAndSpeed))
            data.append(UInt8(value.hashValue))
            data.append(UInt8(status.NewAndSpeed))
        case 2:
            let value = !Bool.init(NSNumber.init(value: status.NewAndSpeed))
            data.append(UInt8(status.AirAndSpeed))
            data.append(UInt8(value.hashValue))
        default:
            break
        }
        setSwitchData(code: [0x00,0x29,0x29,0x03][key], data: data)
    }
    //0空净风速  ,1新风风速
    func setSpeed(key:Int,value:Int,callBack:((_ error:Error?)->Void)) {
        if key>1 || key<0{
            return
        }
        if self.connectStatus != .Connected {
            callBack(NSError.init(domain: "设备已断开连接", code: -1, userInfo: nil))
            return
        }
        if status.Power==false{
            callBack(NSError.init(domain: "电源开关未打开", code: -2, userInfo: nil))
            return
        }
        var currValue=[status.AirAndSpeed,status.NewAndSpeed][key]+value
        currValue=max(1, currValue)
        var data=Data()
        if key == 0 && status.AirAndSpeed==0{
            callBack(NSError.init(domain: "净化开关未打开", code: -3, userInfo: nil))
            return
        }else{
            currValue=min(3, currValue)
            data.append(UInt8(currValue))
            data.append(UInt8(status.NewAndSpeed))
        }
        if key == 1 && status.NewAndSpeed==0{
            callBack(NSError.init(domain: "新风开关未打开", code: -4, userInfo: nil))
            return
        }else{
            currValue=min(2, currValue)
            data.append(UInt8(status.AirAndSpeed))
            data.append(UInt8(currValue))
        }
        
        setSwitchData(code: 0x29, data: data)
    }
    //设置开关机时间,Type:0单次，1每天
    func setAppoint(onOffType:Int,onEveryDay:Int,offEveryDay:Int,offOnce:Int,callBack:((_ error:Error?)->Void)) {
        if self.connectStatus != .Connected {
            callBack(NSError.init(domain: "设备已断开连接", code: -1, userInfo: nil))
            return
        }
        if status.Power==false{
            callBack(NSError.init(domain: "电源开关未打开", code: -2, userInfo: nil))
            return
        }
        var data = Data.init(bytes: [UInt8(onOffType)])
        data.append(OznerTools.dataFromInt(number: CLongLong(onEveryDay), length: 2))
        data.append(OznerTools.dataFromInt(number: CLongLong(offEveryDay), length: 2))
        data.append(OznerTools.dataFromInt(number: CLongLong(offOnce), length: 2))
        setSwitchData(code: 0x04, data:data)
    }
    private func setSwitchData(code:UInt8,data:Data) {
        self.SendDataToDevice(sendData: setProperty(code: code, data: data), CallBack: nil)
        self.reqesutProperty(data: Data.init(bytes: [0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03,0x19,0x26,0x27,0x28,0x29,0x2A,0x2B,0x04]))
    }
    override func OznerBaseIORecvData(recvData: Data) {
        super.OznerBaseIORecvData(recvData: recvData)
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
            var tmpStatus = status
            var tmpSensor = sensor
            var tmpFilterStatus = filterStatus
            var tmpAppointTime = appointTime
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
                let valueData=recvData.subData(starIndex: p, count: size)
                p+=size
                if valueData.count<=0 {
                    continue
                }
                switch keyOfData {
                case 0x04://PROPERTY_POWER_TIMER
                    tmpAppointTime.onOffType=Int(valueData[0])
                    tmpAppointTime.onEveryDay=valueData.subInt(starIndex: 1, count: 2)
                    tmpAppointTime.offEveryDay=valueData.subInt(starIndex: 3, count: 2)
                    tmpAppointTime.offOnce=valueData.subInt(starIndex: 5, count: 2)
                    break
                case 0x00://PROPERTY_POWER
                    tmpStatus.Power=(Int(valueData[0]) != 0)
                case 0x02://PROPERTY_LIGHT
                    break
                case 0x03://PROPERTY_LOCK
                    tmpStatus.Lock=(Int(valueData[0]) != 0)
                    
//                case 0x01://PROPERTY_SPEED
//                    tmpStatus.Speed_Air=Int(valueData[0])

                case 0x15://PROPERTY_FILTER
                    if valueData.count>=16 {
                        tmpFilterStatus.starDate=Date(timeIntervalSince1970: TimeInterval(Int(valueData[0])+256*Int(valueData[1])+256*256*Int(valueData[2])+256*256*256*Int(valueData[3])))
                        tmpFilterStatus.workTime=Int(valueData[4])+256*Int(valueData[5])+256*256*Int(valueData[6])+256*256*256*Int(valueData[7])
                        tmpFilterStatus.stopDate=Date(timeIntervalSince1970: TimeInterval(Int(valueData[8])+256*Int(valueData[9])+256*256*Int(valueData[10])+256*256*256*Int(valueData[11])))
                        tmpFilterStatus.maxWorkTime=Int(valueData[12])+256*Int(valueData[13])+256*256*Int(valueData[14])+256*256*256*Int(valueData[15])
                    }
                case 0x11://PROPERTY_PM25
                    tmpSensor.PM25_In=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.PM25_In = tmpSensor.PM25_In==65535 ? 0:tmpSensor.PM25_In
                    tmpSensor.PM25_In=min(999, tmpSensor.PM25_In)
                case 0x12://PROPERTY_TEMPERATURE
                    tmpSensor.Temperature=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.Temperature = tmpSensor.Temperature==65535 ? 0:tmpSensor.Temperature
                case 0x13://PROPERTY_VOC
                    tmpSensor.TVOC=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.TVOC = tmpSensor.TVOC==65535 ? 0:tmpSensor.TVOC
                case 0x18://PROPERTY_HUMIDITY
                    tmpSensor.Humidity=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.Humidity = tmpSensor.Humidity==65535 ? 0:tmpSensor.Humidity
                case 0x14://PROPERTY_LIGHT_SENSOR
                    break
                case 0x19://PROPERTY_TOTAL_CLEAN
                    tmpSensor.TotalClean=(Int(valueData[0])+256*Int(valueData[1])+256*256*Int(valueData[2])+256*256*256*Int(valueData[3]))/1000
                case 0x27://
                    tmpSensor.PM25_Out=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.PM25_Out = tmpSensor.PM25_Out==65535 ? 0:tmpSensor.PM25_Out
                case 0x28://
                    tmpSensor.CO2=Int(valueData[0])+256*Int(valueData[1])
                    tmpSensor.CO2 = tmpSensor.CO2==65535 ? 0:tmpSensor.CO2
                case 0x29:
                    if valueData.count>=2
                    {
                        tmpStatus.AirAndSpeed=Int(valueData[0])
                        tmpStatus.NewAndSpeed=Int(valueData[1])
                    }
                    
    
//                case 0x2A://
//                    tmpStatus.Power_New=Int(valueData[0])==1
//                case 0x2B://
//                    tmpStatus.Speed_New=Int(valueData[0])
                default:
                    break
                }
                
            }
            if tmpStatus.Power==false {
                tmpStatus=(false,false,0,0)
            }
            appointTime = tmpAppointTime
            status = tmpStatus
            sensor = tmpSensor
            filterStatus = tmpFilterStatus
        }
        
        
    }
    override func doWillInit() {
        super.doWillInit()
        self.setTime()
        sleep(1)
        let data = Data.init(bytes: [0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03,0x19,0x26,0x27,0x28,0x29,0x2A,0x2B,0x04])
        self.reqesutProperty(data: data)
    }
    var requestCount = 0//请求三次没反应代表机器断网
    override func repeatFunc() {
        
        if Int(arc4random()%2)==0 {
            self.reqesutProperty(data: Data.init(bytes: [0x15,0x11,0x14,0x12,0x13,0x18,0x00,0x01,0x02,0x03,0x19,0x26,0x27,0x28,0x29,0x2A,0x2B,0x04]))
            requestCount=(requestCount+1)
            if requestCount>=3 {
                self.connectStatus = .Disconnect
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
        return "name:\(self.settings.name!)\n connectStatus:\(self.connectStatus)\n TotalClean:\(self.sensor.TotalClean),Temperature:\(self.sensor.Temperature),PM25:\(self.sensor.PM25_In),Humidity:\(self.sensor.Humidity),VOC:\(self.sensor.TVOC)\n,童锁:\(self.status.Lock)\n,控制:\(self.status)\n 滤芯:\(self.filterStatus)\n"
    }
}
