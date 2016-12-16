//
//  NetWorkHelper.swift
//  StandardProject
//
//  Created by 赵兵 on 16/8/3.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFNetworking

/// 网络访问类封装
class NetworkManager:NSObject{
    required init?(NetworkConfig: NSDictionary) {
        self.NetworkConfig = JSON(NetworkConfig)
        super.init()
        if self.NetworkConfig["RootAddress"].stringValue == ""
        {
            return nil
        }
       
    }
    static var defaultManager = NetworkManager(NetworkConfig: NSDictionary(contentsOfFile: Bundle.main.path(forResource: "NetworkConfig", ofType: "plist")!)!)
    
    
    func POST(key: String,
              parameters: NSDictionary?,
              success: ((JSON) -> Void)?,
              failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        return request(key: key,
                       POSTParameters: parameters,
                       constructingBodyWithBlock: nil,
                       progress:nil,
                       success: success,
                       failure: failure)
    }
    func ChatPost(_ url:String,method:ChatHttpMethod,parameters: NSDictionary?,success:successJsonBlock?,failure:failureBlock?) -> URLSessionDataTask? {
        
        return request(url: url,method:method, POSTParameters: parameters, constructingBodyWithBlock: nil, progress: nil, success: success, failure: failure)
        
    }
    func POST(key: String,
              parameters: NSDictionary?,
              constructingBodyWithBlock block: ((AFMultipartFormData?) -> Void)?,
              success: ((JSON) -> Void)?,
              failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        return request(key: key,
                       POSTParameters: parameters,
                       constructingBodyWithBlock: block,
                       progress:nil,
                       success: success,
                       failure: failure)
    }
    func POST(key: String,
              parameters: NSDictionary?,
              progress:((Progress) -> Void)?,
              success: ((JSON) -> Void)?,
              failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        return request(key: key,
                       POSTParameters: parameters,
                       constructingBodyWithBlock: nil,
                       progress:progress,
                       success: success,
                       failure: failure)
    }
    func POST(key: String,
              parameters: NSDictionary?,
              constructingBodyWithBlock block: ((AFMultipartFormData?) -> Void)?,
              progress:((Progress) -> Void)?,
              success: ((JSON) -> Void)?,
              failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        return request(key: key,
                       POSTParameters: parameters,
                       constructingBodyWithBlock: block,
                       progress:progress,
                       success: success,
                       failure: failure)
    }
    private func request(key: String,
                 
                 POSTParameters: NSDictionary?,
                 constructingBodyWithBlock block: ((AFMultipartFormData?) -> Void)?,
                                           progress:((Progress) -> Void)?,
                                           success: ((JSON) -> Void)?,
                                           failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        // 添加固定参数token
        let tmpParameters = NSMutableDictionary(dictionary: POSTParameters ?? NSDictionary())
        if userToken != nil {
            tmpParameters.setValue(userToken, forKey: "usertoken")
        }
        return manager.post(RootAdress+(SubAddress![key]?.stringValue)!, parameters: tmpParameters, constructingBodyWith: block, progress: progress, success: { (operation, data) in
            self.handleSuccess(operation: operation, data: data as! Data, success: success, failure: failure)
            }) { (operation, error) in
                failure?(error)
        }

        
        
    }
    private func request(url: String,method:ChatHttpMethod,
                         
                         POSTParameters: NSDictionary?,
                         constructingBodyWithBlock block: ((AFMultipartFormData?) -> Void)?,
                         progress:((Progress) -> Void)?,
                         success: ((JSON) -> Void)?,
                         failure: ((Error) -> Void)?) -> URLSessionDataTask? {
        
        
        //        return manager.get(url, parameters: POSTParameters, progress: progress, success: { (operation, data) in
        //            self.handleSuccess(operation: operation, data: data, success: success, failure: failure)
        //            }, failure: { (operation, error) in
        //                failure?(error)
        //        })
        //
        switch method {
        case .GET:
            return manager.get(url, parameters: POSTParameters, progress: nil, success: { (operation, data) in
                self.handleSuccess(operation: operation, data: data as! Data, success: success, failure: failure)
                }, failure: { (operation, error) in
                    failure?(error)
            })
        case .POST:
            return manager.post(url, parameters: POSTParameters, constructingBodyWith: block, progress: progress, success: { (operation, data) in
                self.handleSuccess(operation: operation, data: data as! Data, success: success, failure: failure)
            }) { (operation, error) in
                failure?(error)
            }
        }
        
        
        
    }

    private func handleSuccess(operation: URLSessionDataTask, data: Data, success: ((JSON) -> Void)?, failure: ((NSError) -> Void)?) {
        let jsonData:JSON = JSON(data: data)
        let state = jsonData["state"].intValue
        switch true {
        case state>=0:
            success?(jsonData)
            CoreDataManager.defaultManager.saveChanges()
        case state == TokenFailed:
            LoginManager.instance.LoginOut()//token失效，返回到登录界面重新登录
        default:
            var userInfo = [
                NSLocalizedDescriptionKey: getErrorState(state: state),
                NSURLErrorKey: operation.response!.url!
            ] as [String : Any]
            if operation.error != nil {
                userInfo[NSUnderlyingErrorKey] = operation.error
            }
            let error = NSError(
                domain: RootAdress,
                code: state,
                userInfo: userInfo)
            failure?(error)
        }
    }
    private lazy var manager: AFHTTPSessionManager = {
        [weak self] in
        assert(self?.RootAdress != nil, "RootAddress不能为nil")
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: (self?.RootAdress)!) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer.init(writingOptions: JSONSerialization.WritingOptions.init(rawValue: 0))
        return manager
        }()
    /**
     清理cookies和当前用户信息
     */
    class func clearCookies() {
        let storage = HTTPCookieStorage.shared//as! [NSHTTPCookie]
        for cookie in (storage.cookies)! {
            storage.deleteCookie(cookie)
        }
        UserDefaults.standard.removeObject(forKey: UserDefaultsUserTokenKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsUserIDKey)
        UserDefaults.standard.synchronize()
        URLCache.shared.removeAllCachedResponses()
    }
    var userToken:String?{
        return UserDefaults.standard.object(forKey: UserDefaultsUserTokenKey) as! String?
    
    }
    /**
     获取错误的中文描述
     
     - parameter state: 错误编码
     
     - returns: 中文描述信息
     */
    private func getErrorState(state:Int)->String
    {
        var errorState=""
        for (key,value) in ErrorCode! {
            if key == "\(state)" {
                errorState=value.stringValue
            }
        }

        return errorState
    }

    
    private let NetworkConfig: JSON
    /// 根地址
    var RootAdress: String {
        return NetworkConfig["RootAddress"].stringValue
    }
    /// 后缀路径地址
    private var SubAddress: [String: JSON]? {
        return NetworkConfig["SubAddress"].dictionary
    }
    
    /// 错误编码列表
    private var ErrorCode: [String: JSON]? {
        return NetworkConfig["ErrorCode"].dictionary    }
    var TokenFailed: Int {
        return NetworkConfig["TokenFailed"].intValue
    }
    //URL，静态链接网址
    var URL: [String: JSON]? {
        return NetworkConfig["URL"].dictionary
    }
   
    func UrlNameWithRoot(_ UrlName:String)->String
    {
        var str = (URL!["UrlRoot"]?.stringValue)!
        str+="?mobile="+(User.currentUser?.phone)!
        str+="&UserTalkCode="+(User.currentUser?.usertoken!)!
        str+="&Language=zh&Area=zh&goUrl="+(URL![UrlName]?.stringValue)!
        return str
    }
    func UrlWithRoot(_ Url:String)->String
    {
        var str = (URL!["UrlRoot"]?.stringValue)!
        str+="?mobile="+(User.currentUser?.phone)!
        str+="&UserTalkCode="+(User.currentUser?.usertoken!)!
        str+="&Language=zh&Area=zh&goUrl="+Url
        return str
    }
    
}
