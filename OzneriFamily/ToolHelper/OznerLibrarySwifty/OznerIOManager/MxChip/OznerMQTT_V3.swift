//
//  OzneMQTTGprs.swift
//  OznerLibrarySwiftyDemo
//
//  Created by ZGY on 2017/9/19.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/9/19  下午3:52
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import MQTTKit


class OznerMQTT_V3: NSObject {
    
    private var mqttClient:MQTTClient!
    
    static let `instance`: OznerMQTT_V3 = OznerMQTT_V3()
    
    typealias dataCallBlock = (dataCallBack:((Data)->Void),statusCallBack:((OznerConnectStatus)->Void))
    
    private var SubscribeTopics:[String:dataCallBlock]!
    
    override init() {
        
        super.init()
        
        SubscribeTopics=[String:dataCallBlock]()
        
        mqttClient = MQTTClient(clientId: User.currentUser?.phone ?? ("v1-app-" + rndString(len: 12)))
        mqttClient.port=1884
        
        mqttClient.username=User.currentUser?.phone//手机号
        var token = "12345678" + "@\(mqttClient.username!)" + "@\(mqttClient.clientID!)"
        
        token = Helper.gprsEncryption(token)
//        print("加密后的password:\(token)")
        mqttClient.password=token//token
        mqttClient.keepAlive=60
        
        mqttClient.cleanSession=false
        
        //http://iot.ozner.net:1884 (内网地址请使用192.168.173.21:1884)
        DispatchQueue.main.async { [weak self] ()->Void in
            self?.mqttClient.connect(toHost: "iot.ozner.net") { (code) in
                
                switch code {
                case ConnectionAccepted:
                    
                    print("连接成功!")
                    
                    for (key,value) in self!.SubscribeTopics {
                        self?.mqttClient.subscribe(key, withQos: AtLeastOnce, completionHandler: { (_) in
                        })
                        value.statusCallBack(OznerConnectStatus.Connected)
                    }
                    
                default:
                    for item in self!.SubscribeTopics {
                        item.value.statusCallBack(OznerConnectStatus.Disconnect)
                    }
                }
                
            }
        }
        
        mqttClient.messageHandler = { (message) in
            if let callback = self.SubscribeTopics[message?.topic ?? "none"] {
                
                if let playData = message?.payload {
                    
                    callback.dataCallBack(playData)
                    
                }
                
            }
            print(message?.payloadString() ?? "")
            
        }

    }
    
    
    func sendData(data:Data,toTopic:String,callback:((Int32)->Void)!)  {
        mqttClient.publishData(data, toTopic: toTopic, withQos: AtMostOnce, retain: true, completionHandler: callback)
    }
    
    func subscribeTopic(topic:String,messageHandler:(dataCallBack:((Data)->Void),statusCallBack:((OznerConnectStatus)->Void))) {
        
        mqttClient.subscribe(topic, withQos: AtLeastOnce) { (_) in
        }
        
        SubscribeTopics[topic]=messageHandler
        
    }
    
    func unSubscribeTopic(topic:String) {
        SubscribeTopics.removeValue(forKey: topic)
        mqttClient.unsubscribe(topic) {
        }
    }
    
    private func rndString(len:Int) -> String {
        let  HexString = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        var str = ""
        for _ in 0..<len {
            let temp = Int(arc4random()%16)
            str+=HexString[temp]
        }
        return str
    }
}
