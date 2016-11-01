//
//  User+CoreDataClass.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
let UserDefaultsUserTokenKey = "usertoken"
let UserDefaultsUserIDKey = "userid"
let CurrentUserDidChangeNotificationName = "CurrentUserDidChangeNotificationName"

public class User: BaseDataObject {

    static var currentUser: User? = nil {
        didSet {
            if oldValue != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CurrentUserDidChangeNotificationName), object: nil)
            }
        }
    }
    //检查是否需要自动登录
    class func loginWithLocalUserInfo(success: ((User) -> Void), failure: ((NSError) -> Void)) {
        
        let UserToken = UserDefaults.standard.object(forKey: UserDefaultsUserTokenKey) as? NSString
        let UserID = UserDefaults.standard.object(forKey: UserDefaultsUserIDKey) as? NSString
        var error: NSError? = nil
        if UserToken == nil || UserID==nil  {
            failure(NSError())
        } else {
            if let user = CoreDataManager.defaultManager.fetch(entityName: "User", ID: UserID!, error: &error) as? User {
                User.currentUser=user
                success(user)
            } else {
                let userInfo: NSMutableDictionary = [
                    NSLocalizedDescriptionKey: "数据库用户信息不存在",
                    NSLocalizedFailureReasonErrorKey: "",
                    NSLocalizedRecoverySuggestionErrorKey: ""
                ]
                
                if error != nil {
                    userInfo[NSUnderlyingErrorKey] = error
                }
                failure(NSError(
                    domain: (NetworkManager.defaultManager?.RootAdress)!,
                    code: 404,
                    userInfo: userInfo as [NSObject: AnyObject]))
            }
        }
    }
    //获取手机验证码
    class func GetPhoneCode(phone:String,success:@escaping (()->Void),failure:@escaping ((Error)->Void)){
        self.fetchData(key: "GetPhoneCode", parameters: ["phone": phone], success: { (json) in
            success()
            }, failure: failure)
    }
    //获取语音验证码
    class func GetVoicePhoneCode(phone:String,success:@escaping (()->Void),failure:@escaping ((Error)->Void)){
        self.fetchData(key: "GetVoicePhoneCode",
                                              parameters: [
                                                "phone": phone
            ],
                                              success: {
                                                data in
                                                success()
            },
                                              failure: failure)
    }
    //手机登录
    class func loginWithPhone(phone: String, phonecode: String, success: @escaping ((User) -> Void), failure: @escaping ((Error) -> Void)) {
        NetworkManager.clearCookies()
        
        self.fetchDataWithProgress(key: "Login",
                       parameters: [
                        "UserName": phone,
                        "PassWord": phonecode,
                        "miei": (UIDevice.current.identifierForVendor?.uuidString)!,
                        "devicename": UIDevice.current.name
            ],
                       success: {
                        data in
                        let defaults = UserDefaults.standard
                        defaults.set(data["usertoken"].stringValue, forKey: UserDefaultsUserTokenKey)
                        defaults.set(data["userid"].stringValue, forKey: UserDefaultsUserIDKey)
                        
                        let user = User.cachedObjectWithID(ID: data["userid"].stringValue as NSString)
                        user.phone = phone
                        user.id =  data["userid"].stringValue
                        user.usertoken = data["usertoken"].stringValue     
                        defaults.synchronize()
                        loginWithLocalUserInfo(success: success, failure: failure)
                        
            },
                       failure: failure)
    }
    //获取用户信息1
    class func GetUserInfo(){
        self.fetchData(key: "GetUserInfo", parameters: [:], success: { (json) in
            let userInfo=json["userinfo"].dictionary
            User.currentUser?.username=userInfo?["Nickname"]?.stringValue
            User.currentUser?.score=userInfo?["Score"]?.stringValue
            User.currentUser?.headimage=userInfo?["Icon"]?.stringValue
            User.currentUser?.gradename=userInfo?["GradeName"]?.stringValue
        }) { (error) in
        }
    }
    //获取用户信息1
//    class func GetUserInfo(){
//        self.fetchData(key: "GetUserNickImage", parameters: ["jsonmobile":User.currentUser?.phone!], success: { (json) in
//            let userInfo=json["data"].dictionary
//            User.currentUser?.username=userInfo?["nickname"]?.stringValue
//            User.currentUser?.score=userInfo?["Score"]?.stringValue
//            User.currentUser?.headimage=userInfo?["headimg"]?.stringValue
//            User.currentUser?.gradename=userInfo?["GradeName"]?.stringValue.replacingOccurrences(of: "会员", with: "代理会员")
////            if (User.currentUser?.headimage?.characters.count)!<5 || !(User.currentUser?.headimage?.contains("http"))!
////            {
////                User.currentUser?.headimage=""
////            }
//            print(userInfo)
//            print(userInfo)
//        }) { (error) in
//        }
//    }
//    //获取用户信息2   "15016161314,1561212311,123423342"
//    class func GetUserNickImage(phones:String,success: @escaping (([User]) -> Void), failure: @escaping ((Error) -> Void)){
//        self.fetchData(key: "GetUserNickImage", parameters: ["jsonmobile":phones], success: { (json) in
//            var userArr=[User]()
//            for userInfo in json.array!
//            {
//                let tmpUser=User()
//                tmpUser.username=userInfo?["Nickname"]?.stringValue
//                tmpUser.score=userInfo?["Score"]?.stringValue
//                tmpUser.headimage=userInfo?["Icon"]?.stringValue
//                tmpUser.gradename=userInfo?["GradeName"]?.stringValue
//                userArr.append(tmpUser)
//            }
//            success(userArr)
//            
//        }) { (error) in
//        }
//    }
    //更新用户信息
    class func UpdateUserInfo(){
        self.fetchData(key: "UpdateUserInfo", parameters: ["device_id":BPush.getChannelId()], success: { (json) in
            User.GetUserInfo()
            }) { (error) in
                
        }
    }
    
    //---------------------------设备------------------------------
    //下载探头滤芯数据
    class func FilterService(deviceID:String,success: @escaping ((_ usedDay:Int,_ starDate:Date) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "FilterService", parameters: ["mac":deviceID], success: { (json) in
            let timeStr=json["modifytime"].string!
            let date=NSDate(string: timeStr, formatString: "yyyy-MM-dd HH:mm:ss") as Date
            success(json["useday"].int!, date)
        }, failure: failure)
        
    }

    //净水器设备型号及功能，连接地址下载
    class func GetMachineType(deviceID:String,success: @escaping ((_ ScanEnable:Bool,_ CoolEnable:Bool,_ HotEnable:Bool,_ MachineType:String,_ BuyUrl:String,_ AlertDays:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetMachineType", parameters: ["type":deviceID], success: { (json) in
            let tmpData=json["data"] as JSON
            success(
                tmpData["boolshow"].bool!,
                (tmpData["Attr"].string?.contains("cool:true"))!,
                (tmpData["Attr"].string?.contains("hot:true"))!,
                tmpData["MachineType"].string!,
                tmpData["buylinkurl"].string!,
                tmpData["days"].int!)
            }, failure: failure)
        
    }
    //净水器获取滤芯服务时间
    class func GetMachineLifeOutTime(deviceID:String,success: @escaping ((_ usedDays:Int,_ stopDate:Date) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "GetMachineLifeOutTime", parameters: ["mac":deviceID], success: { (json) in
            let endStr=json["time"].stringValue
            let nowStr=json["nowtime"].stringValue
            if endStr==""||nowStr==""
            {
               success(0, NSDate().addingYears(1))
                return
            }
            let endDate=NSDate(string: endStr, formatString: "yyyy/MM/dd HH:mm:ss")
            let nowDate=NSDate(string: nowStr, formatString: "yyyy/MM/dd HH:mm:ss")
            let tmpUseDays=365-((endDate?.timeIntervalSince1970)!-(nowDate?.timeIntervalSince1970)!)/(24*3600.0)
            success(min(365, Int(tmpUseDays)), endDate as! Date)
            }, failure: failure)
        
    }
    //上传饮水量获取排名
    class func VolumeSensor(deviceID:String,type:String,volume:Int,success: @escaping ((_ rank:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "VolumeSensor", parameters: ["mac":deviceID,"type":type,"volume":volume], success: { (json) in
            success(json["state"].int!)
            }, failure: failure)
        
    }
    ////上传TDS获取排名
    class func TDSSensor(deviceID:String,type:String,tds:Int,beforetds:Int,success: @escaping ((_ rank:Int,_ total:Int) -> Void), failure: @escaping ((Error) -> Void)){
        self.fetchData(key: "TDSSensor", parameters: ["mac":deviceID,"type":type,"tds":tds,"beforetds":beforetds], success: { (json) in
            success(json["rank"].int!,json["total"].int!)
            }, failure: failure)
    }
    
    
}
