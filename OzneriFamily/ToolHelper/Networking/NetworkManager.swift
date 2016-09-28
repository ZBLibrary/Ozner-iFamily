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
        self.NetworkConfig = NetworkConfig
        super.init()
        if NetworkConfig["RootAdress"] as? String == nil
            || NetworkConfig["SubAdress"] as? [String: String] == nil
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
        //tmpParameters.setObject(userToken, forKey: "UserToken")
        return manager.post(RootAdress+SubAddress[key]!, parameters: tmpParameters, constructingBodyWith: block, progress: progress, success: { (operation, data) in
            self.handleSuccess(operation: operation, data: data as! Data, success: success, failure: failure)
            }) { (operation, error) in
                failure?(error)
        }

        
        
    }
    private func handleSuccess(operation: URLSessionDataTask, data: Data, success: ((JSON) -> Void)?, failure: ((NSError) -> Void)?) {
        let jsonData:JSON = JSON(data: data)
        let state = jsonData["state"].intValue
        switch true {
        case state>=0:
            success?(jsonData)
            CoreDataManager.defaultManager.saveChanges()
        case state == (NetworkConfig["TokenFailed"] as AnyObject).integerValue:
            appDelegate.LoginOut()//token失效，返回到登录界面重新登录
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
        assert(self?.RootAdress != nil, "RootAdress不能为nil")
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: (self?.RootAdress)!) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
        }()
    /**
     获取错误的中文描述
     
     - parameter state: 错误编码
     
     - returns: 中文描述信息
     */
    private func getErrorState(state:Int)->String
    {
        var errorState=""
        if (self.ErrorCode.allKeys as! [String]).contains("\(state)")
        {
            errorState=self.ErrorCode["\(state)"] as! String
        }
        return errorState
    }

    
    private let NetworkConfig: NSDictionary
    /// 根地址
    var RootAdress: String {
        return NetworkConfig["RootAdress"] as! String
    }
    /// 后缀路径地址
    private var SubAddress: [String: String] {
        return NetworkConfig["SubAddress"] as! [String: String]
    }
    
    /// 错误编码列表
    private var ErrorCode: NSDictionary {
        return NetworkConfig["ErrorCode"] as! NSDictionary
    }
    var TokenFailed: Int {
        return NetworkConfig["TokenFailed"] as! Int
    }
    //URL，静态链接网址
    var URL: NSDictionary {
        return NetworkConfig["URL"] as! NSDictionary
    }
    
    
}
