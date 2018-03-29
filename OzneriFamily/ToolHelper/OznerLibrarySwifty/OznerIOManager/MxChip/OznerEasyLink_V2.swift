//
//  OznerEasyLink_V2.swift
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2017/5/15.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit



class OznerEasyLink_V2: NSObject,ZBBonjourServiceDelegate,GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate {
    
    var deviceInfo:OznerDeviceInfo!
    private static var _instance: OznerEasyLink_V2! = nil
    static var instance: OznerEasyLink_V2! {
        get {
            if _instance == nil {
                
                _instance = OznerEasyLink_V2()
            }
            return _instance
        }
        set {
            _instance = newValue
        }
    }
    required  override init() {
        
    }
    
    private var hostIP = ""
    private var gcdAsyncSocket:GCDAsyncSocket!
    private var starTime:Date!
    private var pairOutTime = 0
    private var DeviceClass:OZDeviceClass!
    private var SuccessBlock:((OznerDeviceInfo)->Void)!
    private var FailedBlock:((Error)->Void)!
    
    func starPair(deviceClass:OZDeviceClass,password:String?,outTime:Int,successBlock:((OznerDeviceInfo)->Void)!,failedBlock:((Error)->Void)!) {
        //初始化参数
        DeviceClass=deviceClass
        SuccessBlock=successBlock
        FailedBlock=failedBlock
        pairOutTime=outTime
        deviceInfo=OznerDeviceInfo.init()
        deviceInfo.wifiVersion=2
        starTime = Date()
        //启动配网
        print("启动配网2.0")
        ZBBonjourService.sharedInstance().stopSearchDevice()
        ZBBonjourService.sharedInstance().delegate=self
        ZBBonjourService.sharedInstance().startSearchDevice()
        setUDP()
        

    }
    var udpSocket: GCDAsyncUdpSocket?
    func setUDP() {
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.global())
        do {
            try udpSocket?.enableBroadcast(true)
            try udpSocket?.bind(toPort: 8000)
            try udpSocket?.beginReceiving()
        } catch let err as NSError {
            print(">>> Error while initializing socket: \(err.localizedDescription)")
            udpSocket?.close()
        }
    }
    deinit {
        udpSocket = nil
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket!, didReceive data: Data!, fromAddress address: Data!, withFilterContext filterContext: Any!) {
        guard let stringData = String(data: data, encoding: String.Encoding.utf8) else {
            return
        }
        print("Data received: \(stringData)")
        var tmpDeviceInfo=OznerDeviceInfo.init()
        tmpDeviceInfo.wifiVersion=2
        if stringData.contains("Product_id") {
            let tmpArr=stringData.components(separatedBy: ";")
            var Wifi版本号=""
            
            for item in tmpArr{
                let tmpItemArr = item.components(separatedBy: ":")
                switch tmpItemArr[0]
                {
                case "MAC":
                    tmpDeviceInfo.deviceMac=tmpItemArr[1]
                    
                case "Product_id":
                    tmpDeviceInfo.productID=tmpItemArr[1]
                    tmpDeviceInfo.deviceType=tmpItemArr[1]
                    if tmpDeviceInfo.productID=="e137b6e0-2668-11e7-9d95-00163e103941"{
                        print(tmpDeviceInfo.productID)
                    }
                case "Device_id":
                    tmpDeviceInfo.deviceID=tmpItemArr[1]
                case "Wifi_Version":
                    Wifi版本号 = tmpItemArr[1].components(separatedBy: "@")[1]
                default:
                    break
                }
            }
            UserDefaults.standard.set(Wifi版本号, forKey: tmpDeviceInfo.deviceMac.replacingOccurrences(of: ":", with: "").lowercased())
            if DeviceClass.pairID.contains(tmpDeviceInfo.productID) {
                if !OznerMxChipManager.instance.foundDeviceIsExist(mac: tmpDeviceInfo.deviceMac){
                    canclePair()
                    
                    SuccessBlock(tmpDeviceInfo)
                }
            }
        }
    }
    func canclePair() {//取消配对
        udpSocket?.close()
        udpSocket = nil
        ZBBonjourService.sharedInstance().stopSearchDevice()
    }
    @objc private func pairFailed() {
        canclePair()
        FailedBlock(NSError.init(domain: "配网失败", code: 0, userInfo: nil))
    }
    private func pairSuccess() {
        canclePair()
        SuccessBlock(deviceInfo)
    }
    
    func bonjourService(_ service: ZBBonjourService!, didReturnDevicesArray array: [Any]!) {
        print("=======\(array)")
        for item in array {
            if let RecordData = (item as AnyObject).object(forKey: "RecordData")
            {
                if let tmpProductID = (RecordData as AnyObject).object(forKey: "FogProductId") {
                    if !DeviceClass.pairID.contains(tmpProductID as! String) {
                        continue
                    }
                    let macAdress = (RecordData as AnyObject).object(forKey: "MAC") as! String
                    var wifi版本号 = ((RecordData as AnyObject).object(forKey: "Firmware Rev") as! String)
                    wifi版本号=wifi版本号.components(separatedBy: "@")[1]
                    UserDefaults.standard.set(wifi版本号, forKey: macAdress.replacingOccurrences(of: ":", with: "").lowercased())
                    
                    if !OznerMxChipManager.instance.foundDeviceIsExist(mac: macAdress) {
                        deviceInfo.deviceMac = macAdress
                        if let tmpHostIP=(RecordData as AnyObject).object(forKey: "IP")  {
                            hostIP=tmpHostIP as! String
                        }else{
                            continue
                        }
                        
                        deviceInfo.productID = tmpProductID as! String
                        deviceInfo.deviceType = deviceInfo.productID
                        print("\n搜索到新设备\n"+"ProductID:"+deviceInfo.deviceMac+"\nmac:"+deviceInfo.deviceType)
                        print("\n开始激活设备:\(hostIP)")
                        ZBBonjourService.sharedInstance().stopSearchDevice()
                        if gcdAsyncSocket != nil {
                            gcdAsyncSocket.setDelegate(nil, delegateQueue: nil)
                            gcdAsyncSocket.disconnect()
                            gcdAsyncSocket=nil
                        }
                        isneedReconnectHost=true
                        let myQueue = DispatchQueue.init(label: "come.ozner.GCDAsyncSocket")
                        gcdAsyncSocket=GCDAsyncSocket.init(delegate: self, delegateQueue: myQueue)
                        do {
                            print("\ngcdAsyncSocket?.connect")
                            try gcdAsyncSocket?.connect(toHost: hostIP, onPort: 8002)
                        } catch let error {
                            print("\n激活设备失败!")
                            print(error)
                            pairFailed()
                        }
                        break
                    }
                }
            }
        }
    }
    
    private var isneedReconnectHost = true
    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: Error!) {
        print("Socket 断开链接")
        if Int(Date().timeIntervalSince1970-starTime.timeIntervalSince1970)>pairOutTime {
            pairFailed()
            return
        }
        if !isneedReconnectHost {
            return
        }
        do {
            try gcdAsyncSocket?.connect(toHost: hostIP, onPort: 8002)
         
        } catch let error {
            print("\n激活设备失败!\(error)")
            pairFailed()
        }
        sleep(1)
    }
    func socket(_ sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Socket 连接成功")
        gcdAsyncSocket.readData(withTimeout: -1, tag: 200)
        // 发送消息
        let sPostURL = "POST / HTTP/1.1\r\n\r\n{\"getvercode\":\"\"}\r\n"
        let sPostdata = sPostURL.data(using: String.Encoding.utf8)
        // 开始发送消息 这里不需要知道对象的ip地址和端口
        gcdAsyncSocket?.write(sPostdata, withTimeout: 10, tag: 100)
    }
    
    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        isneedReconnectHost=false
        let stringFromData = String.init(data: data, encoding: String.Encoding.utf8)
        print(stringFromData ?? "")
        let array1=stringFromData?.components(separatedBy: ",")
        let array2=array1?[0].components(separatedBy: ":")
        deviceInfo.deviceID = (array2?.last)!
        deviceInfo.deviceID=deviceInfo.deviceID.replacingOccurrences(of: "\"", with: "")
        let useTime = Date().timeIntervalSince1970-starTime.timeIntervalSince1970
        print("\n设备激活成功(\(Date()))\n配网完成(用时:\(useTime))")
        pairSuccess()
    }
}
