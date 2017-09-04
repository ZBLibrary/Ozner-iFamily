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
    
    private(set) var senSorTwo:(TDS:Int,Temperature:Int) = (0,0) {
        
        didSet {
            
            if senSorTwo != oldValue {
                
                self.delegate?.OznerDeviceSensorUpdate?(identifier: self.deviceInfo.deviceID)
                
            }
            
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
            
            senSorTwo = (Int(recvData[1]),Int(recvData[2]))
            print(senSorTwo)
        case 0x42://获取历史记录
            print(recvData)
        case 0x43://历史记录数量
            print(recvData)

        default:
            break
            
        }
        
    }
    
    override func doWillInit() {
        
        print("智能水杯")
        readDeviceInfo()
        calibrationTime()

        
    }
    
    override func repeatFunc() {
        
        //            readDeviceInfo()
        readDeviceInfo()
        getHistory()
  
    }
    
    override func describe() -> String {
        
        return "name:\(self.settings.name!)\n connectStatus:\(self.connectStatus)\n sensor:\(self.senSorTwo)\n,CupState:\(self.cupState)"
    
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
        //        let data = Data.init(bytes: [
        //            0x40,
        //            UInt8(NSDate().year()-2000),
        //            UInt8(NSDate().month()),
        //            UInt8(NSDate().day()),
        //            UInt8(NSDate().hour()),
        //            UInt8(NSDate().minute()),
        //            UInt8(NSDate().second())])
        
        self.SendDataToDevice(sendData: data) { (error) in}
        
    }
    
    //获取历史记录
    private func getHistory() {
        
        //        let data = Data.init(bytes: [
        //            0x41,
        //            UInt8(NSDate().year()-2000),
        //            UInt8(NSDate().month()),
        //            UInt8(NSDate().day()),
        //            UInt8(NSDate().hour()),
        //            UInt8(NSDate().minute()),
        //            UInt8(NSDate().second()),
        //            UInt8(NSDate().year()-2000),
        //            UInt8(NSDate().month()),
        //            UInt8(NSDate().day() - 7),
        //            UInt8(NSDate().hour()),
        //            UInt8(NSDate().minute()),
        //            UInt8(NSDate().second())])
        //
        //        self.SendDataToDevice(sendData: data) { (error) in}
        
        let endtime = CLongLong(Date().timeIntervalSince1970)
        
        let startTime = CLongLong(Date().timeIntervalSince1970 - 60 * 60 * 24 * 7)
        
        var data = Data.init(bytes: [
            0x41])
        data.append(OznerTools.dataFromInt(number: startTime, length: 4))
        data.append(OznerTools.dataFromInt(number: endtime, length: 4))
        self.SendDataToDevice(sendData: data) { (error) in}
        
    }

}
