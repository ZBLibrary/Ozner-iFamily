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
    
    //咨询
    //获取聊天Token
    
    class func GetAccesstoken() {
        
        var getpar:String = "appid=hzapi"
        getpar = getpar + "&appsecret=8af0134asdffe12"
        let sign_News = getpar.MD5
        let urlStr = "http://dkf.ozner.net/api" + "/token.ashx"
        
        let params:NSDictionary = ["appid":"hzapi","appsecret":"8af0134asdffe12","sign":sign_News!]
        
        self.chatData(urlStr,method: .GET, parameters: params, success: { (json) in
            acsstoken_News = json.dictionary?["result"]?.dictionaryValue["access_token"]?.stringValue ?? ""
            self.GetUserInfoFunc()
            }) { (error) in
            print(error)
        }
        
    }
    //获取用户信息
    class func GetUserInfoFunc() {
        
        let tmpPhone = User.currentUser?.phone
        guard tmpPhone != nil else {
            let alertView = SCLAlertView()
            
            _ = alertView.addButton(loadLanguage("确定"), action: {})
            _ = alertView.showInfo(loadLanguage("温馨提示"), subTitle: loadLanguage("请登录"))
            return
        }
        
        sign_News = "access_token=" + acsstoken_News
        sign_News += appidandsecret
        
        var urlStr = NEWS_URL + "/member.ashx?access_token="
        urlStr += acsstoken_News + "&sign=" + sign_News.MD5
        
        let params:NSDictionary = ["mobile":tmpPhone!]
        
        let mansger = AFHTTPSessionManager()
        mansger.requestSerializer = AFHTTPRequestSerializer.init()
        
        mansger.post(urlStr, parameters: params, constructingBodyWith: { (_) in
            
            }, progress: { (_) in
                
            }, success: { (task, data) in
                print(data)
            }) { (task, error) in
                print(error)
        }
        
        
        self.chatData(urlStr,method:.POST,parameters: params, success: { (data) in
            print(data)
            }) { (error) in
                print(error)
        }
        
        
    }
    //获取历史信息接口
    class  func GetHistoryRecord() {
    
    let getUrl = "http://dkf.ozner.net/api" + "/historyrecord.ashx?access_token=" + ""
    
    
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
    //获取用户的朋友列表
    class func GetFriendList(_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetFriendList", parameters: [:], success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //获取好友历史留言
    class func GetHistoryMessage(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "GetHistoryMessage", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }
    //留言
    class func LeaveMessage(_ params:NSDictionary,_ sucess: @escaping successJsonBlock,faliure:@escaping failureBlock) {
        self.fetchData(key: "LeaveMessage", parameters:params, success: { (data) in
            
            sucess(data)
            
        }) { (error) in
            
            faliure(error)
            
        }
    }


    
    
}
