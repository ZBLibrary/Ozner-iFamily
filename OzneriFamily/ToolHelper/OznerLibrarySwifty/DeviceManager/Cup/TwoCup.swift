//
//  TwoCup.swift
//  OznerLibrarySwiftyDemo
//
//  Created by ZGY on 2017/9/1.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/9/1  上午10:33
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class TwoCup: OznerBaseDevice {
    
    //二代水杯
    private(set) var cupState:(isPower:Bool,Battery:Int) = (false,0) {
        
        didSet {
            
            if cupState != oldValue {
                
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
                
            }
            
        }
        
    }
    
    private(set) var senSorTwo:(TDS:Int,Temperature:Int) = (0,-1) {
        
        didSet {
            
            if senSorTwo != oldValue {
                
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
                
            }
            
        }
        
    }

    private(set) var records:OznerCupRecords!{//day:tds
        didSet{
            if records != oldValue {
                self.delegate?.OznerDeviceRecordUpdate?(identifier: self.deviceInfo.deviceID)
            }
        }
    }
    
    required init(deviceinfo: OznerDeviceInfo, Settings settings: String?) {
        super.init(deviceinfo: deviceinfo, Settings: settings)
        records=OznerCupRecords(Identifier: deviceinfo.deviceID)//初始化水杯记录
        //饮水量记录
        var tmpVolume = 0
        for item in records.getRecord(type: CupRecordType.day) {
            tmpVolume+=item.value.Volume
        }
        
    }
    
    override func OznerBaseIORecvData(recvData: Data) {
        switch UInt8(recvData[0]) {
            
        //二代 设备状态返回
        case 0x21:
            let isPower = Int(recvData[1])
            let battery = Int(recvData[2])
            
            cupState = (isPower == 0 ? false : true,battery)
            print(cupState)
            
        case 0x33://检测结果返回
            
            senSorTwo = (Int(recvData[1]) + 256 * Int(recvData[2]),Int(recvData[3]))
            print(senSorTwo)
        case 0x42://获取历史记录
            print("0x42历史记录条数\(recvData[1])")
            
            let time1 = Int(recvData[2]) + (256 * Int(recvData[3])) + (256 * 256 * Int(recvData[4]))
            
            if time1 != 0 {
                
                let timeDate = secsToData(time1  + (256 * 256 * 256 * Int(recvData[5])))
                let tds = Int(recvData[6]) + Int(recvData[7]) * 256
                let temp = Int(recvData[8])
                print("第一条数据timeDate：\(secondstoString(time1))，tds:\(tds)，temp:\(temp)")
                
                OznerDeviceRecordHelper.instance.addRecordToSQL(Identifier: self.deviceInfo.deviceID, Tdate: timeDate, Tds: tds, Temperature: temp, Volume: 0, Updated: false)
            }
            
            let time2:Int = Int(recvData[9]) + 256 * Int(recvData[10]) + 256 * 256 * Int(recvData[11])
            
            if time2 != 0 {
                
                let timeDate = secsToData(time2 + 256 * 256 * 256 * Int(recvData[12]))
                let tds = Int(recvData[13]) + 256 * Int(recvData[14])
                let temp = Int(recvData[15])
                print("第二条时间戳:\(time2)" + "时间:\(secondstoString(time2))，tds:\(tds)，temp:\(temp)")

                OznerDeviceRecordHelper.instance.addRecordToSQL(Identifier: self.deviceInfo.deviceID, Tdate: timeDate, Tds: tds, Temperature: temp, Volume: 0, Updated: false)
            }
            
//            let time3 = Int(recvData[14]) + 256 * Int(recvData[15]) + 256 * 256 * Int(recvData[16]) + 256 * 256 * 256 * Int(recvData[17])
//            
//            if time3 != 0 {
//                
//                let timeDate = secsToData(time3)
//                let tds = Int(recvData[18])
//                let temp = Int(recvData[19])
//                print("第三条时间戳:\(time3)" + "时间:\(secondstoString(time3))，tds:\(tds)，temp:\(temp)")
//
//                OznerDeviceRecordHelper.instance.addRecordToSQL(Identifier: self.deviceInfo.deviceID, Tdate: timeDate, Tds: tds, Temperature: temp, Volume: 0, Updated: false)
//            }
//            
        case 0x43://历史记录数量
            break
//            print("0x43总历史记录条数:\(Int(recvData[1]) + 256 * Int(recvData[2]) + 256 * 256 * Int(recvData[3]) + 256 * 256 * 256 * Int(recvData[4]))")

        default:
            break
            
        }
        
    }
    
    override func doWillInit() {
        
        print("智能水杯")
        readDeviceInfo()
        sleep(1)
        calibrationTime()

        sleep(1)
        getHistory()

        
    }
    
    override func repeatFunc() {
        
        readDeviceInfo()
  
    }
    
    override func describe() -> String {
        
        return "name:\(self.settings.name!)\n connectStatus:\(self.connectStatus)\n sensor:\(self.senSorTwo)\n,CupState:\(self.cupState)"
    
    }
    
    private func secsToData(_ secs:Int) -> Date {
        
        return Date.init(timeIntervalSince1970: TimeInterval(secs))
        
    }
    
    private func secondstoString(_ seconds:Int) -> String{
        
        let data = Date.init(timeIntervalSince1970: TimeInterval(seconds))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        return formatter.string(from: data)
        
    }
    

    
    
    //MARK: - 二代水杯相关
    //二代智能水杯
    private func readDeviceInfo() {
        
        let data = Data.init(bytes: [
            0x20])
        self.SendDataToDevice(sendData: data) { (error) in}
        
    }
    
    //校准时钟
    private func calibrationTime() {
        
        let time = CLongLong(Date().timeIntervalSince1970)
        
        var data = Data.init(bytes: [
            0x40])
        data.append(OznerTools.dataFromInt(number: time, length: 4))
        
        self.SendDataToDevice(sendData: data) { (error) in}
        
    }
    
    //获取历史记录
    private func getHistory() {
        
        let endtime = CLongLong(Date().timeIntervalSince1970)
        
        let startTime = CLongLong(Date().timeIntervalSince1970 - 60 * 60 * 24 * 3200)
        
        var data = Data.init(bytes: [
            0x41])
        data.append(OznerTools.dataFromInt(number: startTime, length: 4))
        data.append(OznerTools.dataFromInt(number: endtime, length: 4))
        self.SendDataToDevice(sendData: data) { (error) in}
        
    }

}
