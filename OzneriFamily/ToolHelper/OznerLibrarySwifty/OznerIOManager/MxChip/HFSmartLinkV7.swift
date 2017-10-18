//
//  HFSmartLinkV7.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/10/17.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class HFSmartLinkV7: NSObject {
    var deviceInfo:OznerDeviceInfo!
    private static var _instance: HFSmartLinkV7! = nil
    static var instance: HFSmartLinkV7! {
        get {
            if _instance == nil {
                
                _instance = HFSmartLinkV7()
            }
            return _instance
        }
        set {
            _instance = newValue
        }
    }
    private var smtlk:HFSmartLink!
    required  override init() {
        super.init()
        if( smtlk == nil){
            smtlk = HFSmartLink.shareInstence()
            smtlk.isConfigOneDevice = true;
            smtlk.waitTimers = 30;
        }
    }
    
    //private var hostIP = ""
    //private var gcdAsyncSocket:GCDAsyncSocket!
    //private var starTime:Date!
    //private var pairOutTime = 0
    private var DeviceClass:OZDeviceClass!
    private var SuccessBlock:((OznerDeviceInfo)->Void)!
    private var FailedBlock:((Error)->Void)!
    
    func starPair(deviceClass:OZDeviceClass,ssid:String?,password:String?,timeOut:Int,successBlock:((OznerDeviceInfo)->Void)!,failedBlock:((Error)->Void)!) {//开始配对
        //初始化参数
        DeviceClass=deviceClass
        SuccessBlock=successBlock
        FailedBlock=failedBlock
        smtlk.waitTimers = timeOut
        deviceInfo=OznerDeviceInfo.init()
        deviceInfo.wifiVersion=3
        //starTime = Date()
        //启动配网
        print("启动配网2.0")
        smtlk.start(withSSID: ssid, key: password, withV3x: true, processblock: { (progress) in
            print(progress)
        }, successBlock: { (device) in
            print(device ?? "device")
        }, fail: { (fail) in
            print(fail ?? "fail")
        }) { (end) in
            print(end ?? "end")
        }
    }
    
    func canclePair() {//取消配对
        smtlk.stop { (stopMsg, isOk) in
            print("stop:"+stopMsg!+"isOk:\(isOk)")
        }
    }
    @objc private func pairFailed() {
        canclePair()
        FailedBlock(NSError.init(domain: "配网失败", code: 0, userInfo: nil))
    }
    private func pairSuccess() {
        canclePair()
        SuccessBlock(deviceInfo)
    }
    
}
