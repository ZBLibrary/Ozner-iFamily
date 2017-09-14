//
//  WashDush_Wifi.swift
//  OznerLibrarySwiftyDemo
//
//  Created by ZGY on 2017/8/9.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/8/9  上午10:33
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class WashDush_Wifi: OznerBaseDevice {
    //添加个性字段
    //对外只读，对内可读写
    private(set) var sensor:(ErrorState:Int,WashState:Int,RemindTime:Int,RemindPercent:Int,Temperature:Int,lastWashData:Data)=(0,0,-1,-1,-1,Data()){
        didSet{
            if sensor != oldValue {
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    //控制开关、模式
    private(set) var status:(Power:Bool,OnOff:Bool,Lock:Bool,NewTrend:Bool,Door:Bool,WashModel:Int)=(false,false,false,false,false,0){
        didSet{
            if status != oldValue {
                self.delegate?.OznerDeviceStatusUpdate!(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    //耗材、预约
    private(set) var filterStatus:(jingshui:Int,ruanshui:Int,jingjie:Int,liangdie:Int,AppointTime:Int,AppointModel:Int) = (-1,-1,-1,-1,-1,-1){
        didSet{
            if filterStatus != oldValue {
                self.delegate?.OznerDevicefilterUpdate?(identifier: self.deviceInfo.deviceID)
            }
            
        }
    }
    func setControl(controlkey:Int,callBack:((_ error:Error?)->Void)) {
        let controlID=UInt8([1:0x01,2:0x02,3:0x0D,4:0x04][controlkey]!)
         let controlValue = !([1:status.Power,2:status.OnOff,3:status.Lock,4:status.NewTrend][controlkey]!)
        var data = Data.init(bytes: [controlID,0x01,UInt8(controlValue.hashValue)])
        
        if controlkey == 4 {
            data.append(UInt8(0))
            data.append(UInt8(0))
        }
        setProperty(data: data, propertyCount: 1)
    }
    func setModel(Model:Int,callBack:((_ error:Error?)->Void)) {
        let needModel = Model==status.WashModel ? 0:Model
        setProperty(data: Data.init(bytes: [0x03,0x01,UInt8(needModel)]), propertyCount: 1)
    }
    func setAppoint(IsOpen:Bool,time:Int,model:Int,callBack:((_ error:Error?)->Void)) {
        setProperty(data: Data.init(bytes: [0x05,0x04,UInt8(IsOpen.hashValue),UInt8(time%60),UInt8(time/60),UInt8(model)]), propertyCount: 1)
    }

    override func OznerBaseIORecvData(recvData: Data) {
        //解析数据并更新个性字段
        requestCount=0
        if self.connectStatus != .Connected
        {
            self.connectStatus = .Connected
        }
        if (UInt8(recvData[0]) != 0xFB )
        {
            return
        }
        if Int(recvData[1])+Int(recvData[2])*256<=13 {
            return
        }
        var tmpStatus = status
        var tmpSensor = sensor
        var tmpFilterStatus = filterStatus
        tmpSensor.WashState = Int(recvData[recvData.count-5])//state
        tmpStatus.Power = (tmpSensor.WashState != 0)
        
        tmpStatus.WashModel=Int(recvData[recvData.count-4])%8//8自定义洗还没有//program
        var flage = Int(recvData[recvData.count-3])//flage
        tmpStatus.NewTrend = flage%2 != 0
        flage=flage-flage%2
        tmpStatus.Lock = flage%4 != 0
        flage=flage-flage%4
        tmpStatus.Door = flage%8 != 0
        flage=flage-flage%8
        tmpStatus.OnOff = flage%16 != 0
        
        
        if UInt8(recvData[11]) == 0xB0 {
            print(recvData)
        }
        if UInt8(recvData[11]) == 0xB1 {
            
            var p = 13
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
                case 0x0C://耗材状态
                    tmpFilterStatus.jingshui=0
                    tmpFilterStatus.ruanshui=0
                    tmpFilterStatus.jingjie=0
                    tmpFilterStatus.liangdie=0
                    var tmpFilter=Int(valueData[0])
                    if tmpFilter%2 == 0 {
                        tmpFilterStatus.jingshui=Int(valueData[1])
                    }
                    tmpFilter=tmpFilter-tmpFilter%2
                    
                    if tmpFilter%4 == 0 {
                        tmpFilterStatus.ruanshui=Int(valueData[2])
                    }
                    tmpFilter=tmpFilter-tmpFilter%4
                    
                    if tmpFilter%8 == 0 {
                        tmpFilterStatus.jingjie=Int(valueData[3])
                    }
                    tmpFilter=tmpFilter-tmpFilter%8
                    
                    if tmpFilter%16 == 0 {
                        tmpFilterStatus.jingjie=Int(valueData[4])
                    }
                    break
                //case 0x04://保管功能
                    //tmpStatus.Power=(Int(valueData[0]) != 0)
//                case 0x12:////门状态：bit_0:0-关闭，bit_0:1-打开
//                    break
                case 0x06://完成时间
                    tmpSensor.RemindTime=Int(valueData[0])
                    tmpSensor.RemindPercent=Int(valueData[1])*5
                    break
                case 0x05://预约功能
                    tmpFilterStatus.AppointTime = -1
                    tmpFilterStatus.AppointModel = -1
                    if Int(valueData[0])==1 {
                        tmpFilterStatus.AppointTime = Int(valueData[1])+Int(valueData[2])*60
                        tmpFilterStatus.AppointModel = Int(valueData[3])
                    }
                    break
                case 0x0F://洗涤温度
                    tmpSensor.Temperature=Int(valueData[0])
                    break
                case 0x10://单次洗涤结束时状态
                    tmpSensor.lastWashData=valueData
                    break
                case 0x11://错误代码
                    tmpSensor.ErrorState=Int(valueData[0])+Int(valueData[4])*256
                    break
                default:
                    break
                }
                
            }
            
            status = tmpStatus
            sensor = tmpSensor
            filterStatus = tmpFilterStatus
        }
        
        
    }
    
    //data数据处理
    private func setProperty(data:Data,propertyCount:Int)
    {
        let len = 15+data.count
        var dataNeed = Data.init(bytes: [0xfa,UInt8(len%256),UInt8(len/256),0xD0])
        let macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        dataNeed.append(macData!)
        dataNeed.insert(0x01, at: 10)
        dataNeed.insert(0xB0, at: 11)
        dataNeed.insert(UInt8(propertyCount), at: 12)
        dataNeed.append(data)
        dataNeed.append(UInt8(arc4random()%255))
        let pbuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: len-1)
        for index in 0...(len-2)
        {
            pbuffer[index] = dataNeed[index]
        }
        let lastByte=Helper.crc8(pbuffer, inLen: UInt16(len-1))
        dataNeed.append(lastByte)
        self.SendDataToDevice(sendData: dataNeed, CallBack: nil)
    }
    
    
    override func doWillInit() {
        //self.setTime()
        sleep(1)
        self.reqesutProperty()
    }
    var requestCount = 0//请求三次没反应代表机器断网
    override func repeatFunc() {
        if Int(arc4random()%2)==0 {
            self.reqesutProperty()
            requestCount=(requestCount+1)
            if requestCount>=3 {
                self.connectStatus = .Disconnect
            }
        }
    }
    private func reqesutProperty()
    {
        let data = Data.init(bytes: [0x04,0x03,0x06,0x05,0x0D,0x02,0x01,0x0E,0x0F,0x0B,0x10,0x12,0x11])
        
        let len = 15+data.count
        var dataNeed = Data.init(bytes: [0xfa,UInt8(len%256),UInt8(len/256),0xD0])
        let macData=Helper.string(toHexData: self.deviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
        dataNeed.append(macData!)
        dataNeed.insert(0x01, at: 10)
        dataNeed.insert(0xB1, at: 11)
        dataNeed.insert(UInt8(data.count), at: 12)
        dataNeed.append(data)
        dataNeed.append(UInt8(arc4random()%255))
        let pbuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: len-1)
        for index in 0...(len-2)
        {
            pbuffer[index] = dataNeed[index]
        }
        let lastByte=Helper.crc8(pbuffer, inLen: UInt16(len-1))
        dataNeed.append(lastByte)
        self.SendDataToDevice(sendData: dataNeed, CallBack: nil)
    }
    override func describe() -> String {
        return ""
        //return "name:\(self.settings.name!)\n connectStatus:\(self.connectStatus)\n TotalClean:\(self.sensor.TotalClean),Temperature:\(self.sensor.Temperature),PM25:\(self.sensor.PM25),Humidity:\(self.sensor.Humidity),VOC:\(self.sensor.VOC)\n 电源:\(self.status.Power)\n,童锁:\(self.status.Lock)\n,风速:\(self.status.Speed)\n 滤芯:\(self.filterStatus)\n"
    }
}
