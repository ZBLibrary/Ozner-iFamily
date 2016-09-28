//
//  User+CoreDataClass.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/28.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import CoreData

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
    //检查是否自动登录
    class func loginWithLocalUserInfo(success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
        
        let UserToken = UserDefaults.standard.object(forKey: UserDefaultsUserTokenKey) as? NSString
        let UserID = UserDefaults.standard.object(forKey: UserDefaultsUserIDKey) as? NSString
        var error: NSError? = nil
        if UserToken == nil || UserID==nil  {
            let userInfo = [
                NSLocalizedDescriptionKey: "本地usertoken或UserID不存在不存在",
                NSLocalizedFailureReasonErrorKey: ""
            ]
            failure?(NSError(
                domain: (NetworkManager.defaultManager?.RootAdress)!,
                code: (NetworkManager.defaultManager?.TokenFailed)!,
                userInfo: userInfo))
            
        } else {
            if let user = CoreDataManager.defaultManager.fetch(entityName: "User", ID: UserID!, error: &error) as? User {
                success?(user)
            } else {
                let userInfo: NSMutableDictionary = [
                    NSLocalizedDescriptionKey: "数据库用户信息不存在",
                    NSLocalizedFailureReasonErrorKey: "",
                    NSLocalizedRecoverySuggestionErrorKey: ""
                ]
                
                if error != nil {
                    userInfo[NSUnderlyingErrorKey] = error
                }
                failure?(NSError(
                    domain: (NetworkManager.defaultManager?.RootAdress)!,
                    code: 404,
                    userInfo: userInfo as [NSObject: AnyObject]))
            }
        }
    }
//    //登录
//    class func loginWithPhone(phone: String, password: String, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
//        NetworkManager.clearCookies()
//        NetworkManager.defaultManager!.POST("AppLogin",
//                                            parameters: [
//                                                "phone": phone,
//                                                "password": password
//            ],
//                                            success: {
//                                                data in
//                                                let defaults = NSUserDefaults.standardUserDefaults()
//                                                defaults.setObject(data["msg"].stringValue, forKey: UserDefaultsUserTokenKey)
//                                                defaults.setObject(data["data"].stringValue, forKey: UserDefaultsUserIDKey)
//                                                //保存账号密码
//                                                NSUserDefaults.standardUserDefaults().setValue(phone, forKey: "UserName")
//                                                NSUserDefaults.standardUserDefaults().setValue(password, forKey: "PassWord")
//                                                
//                                                let user = User.cachedObjectWithID(data["data"].stringValue)
//                                                user.id =  data["data"].stringValue//userId
//                                                user.usertoken = data["msg"].stringValue//usertoken
//                                                
//                                                
//                                                defaults.synchronize()
//                                                loginWithLocalUserInfo(success: success, failure: failure)
//                                                
//            },
//                                            failure: failure)
//    }
    class func phoneLogin(phone:String,code:String,success:(()->Void),failure:((Error?)->Void)){
        let phoneID = UIDevice.current.identifierForVendor?.uuidString
        let phoneName = UIDevice.current.name
        self.fetchData(key: "Login", parameters: ["UserName":phone,"PassWord":code,"miei":phoneID,"devicename":phoneName], success: { (json) in
            
            }) { (error) in
                
        }
    }
}
