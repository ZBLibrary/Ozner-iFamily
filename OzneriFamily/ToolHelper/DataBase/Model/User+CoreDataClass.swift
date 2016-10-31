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

typealias successJsonBlock = (JSON) -> Void
typealias successVoidBlock = ()->Void
typealias failureBlock = (_ error:Error?)->Void

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
                        user.email = ""
                        defaults.synchronize()
                        loginWithLocalUserInfo(success: success, failure: failure)
                        
            },
                       failure: failure)
    }
    //邮箱登录
    class func loginWithEmail(_ params: NSDictionary,_ sucess:@escaping ((User) -> Void),failure: @escaping ((Error) ->Void)) {
        NetworkManager.clearCookies()
        self.fetchDataWithProgress(key: "MailLogin", parameters: params, success: { (data) in
            let defaults = UserDefaults.standard
            
            defaults.set(data["usertoken"].stringValue, forKey: UserDefaultsUserTokenKey)
            defaults.set(data["userid"].stringValue, forKey: UserDefaultsUserIDKey)
            
            let user = User.cachedObjectWithID(ID: data["userid"].stringValue as NSString)
            user.phone = ""
            user.email = params["username"] as? String
            user.id =  data["userid"].stringValue
            user.usertoken = data["usertoken"].stringValue
            defaults.synchronize()
            loginWithLocalUserInfo(success: sucess, failure: failure)
            
            }) { (error) in
                
              failure(error)
        }
        
        
    }
    //邮箱注册
    class func registerByEmail(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void) ) {
        self.fetchDataWithProgress(key: "MailRegister", parameters: params, success: { (data) in
            sucess()
            }) { (error) in
            failure(error)
        }
    }
    //获取邮箱验证码
    class func getEmailVaildCode(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void)) {
        
        self.fetchDataWithProgress(key: "GetEmailCode", parameters: params, success: { (data) in
            sucess()
        }) { (error) in
            failure(error)
        }
        
    }
     //重置邮箱密码
    class func ResetPasswordByEmail(_ params: NSDictionary,_ sucess: @escaping (() -> Void),failure:@escaping ((Error) ->Void) ) {
        self.fetchDataWithProgress(key: "ResetPassword", parameters: params, success: { (data) in
            sucess()
        }) { (error) in
            failure(error)
        }
    }
   
    class func GetUserInfo(){
        self.fetchData(key: "GetUserInfo", parameters: [:], success: { (json) in
            let userInfo=json["userinfo"].dictionary
            
            User.currentUser?.username=userInfo?["Nickname"]?.stringValue
            User.currentUser?.score=userInfo?["Score"]?.stringValue
            User.currentUser?.headimage=userInfo?["Icon"]?.stringValue
            User.currentUser?.gradename=userInfo?["GradeName"]?.stringValue
            print(User.currentUser)
        }) { (error) in
        }
    }
    //更新用户信息
    class func UpdateUserInfo(){
        self.fetchData(key: "UpdateUserInfo", parameters: ["device_id":BPush.getChannelId()], success: { (json) in
            User.GetUserInfo()
            }) { (error) in
                print("")
        }
    }
    //获取用户头像 GetUserNickImage
    class func GetUserAllInfo() {
        
    }
    
    
    //我
    //提意见
    class func commitSugesstion(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        
        self.fetchData(key: "SubmitOpinion", parameters: params, success: { (data) in
            
            sucess(data)
            }) { (error) in
            faliure(error)
        }
        
    }
    
    
}
