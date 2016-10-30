//
//  User+CoreDataClass.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData
//import SwiftyJSON
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
                print("")
        }
    }
    
}
