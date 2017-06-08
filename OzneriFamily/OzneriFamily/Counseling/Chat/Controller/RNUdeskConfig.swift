//
//  RNUdeskConfig.swift
//  OzneriFamily
//
//  Created by 婉卿容若 on 2017/6/7.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import Foundation

class RNUdeskConfig: NSObject {
    
    typealias LeaveMessageBlock = (UIViewController) -> ()
    
    var leaveMessageBlock: LeaveMessageBlock
    
    init(leaveMessageBlock: @escaping LeaveMessageBlock) {
        self.leaveMessageBlock = leaveMessageBlock
    }
    
    func shareInstance() -> UdeskSDKManager?{
        
        var userDic = [String: String]()
        // 初始化客户信息
        let userID = UserDefaults.standard.value(forKey: UserDefaultsUserIDKey) ?? User.currentUser?.username ?? String(describing: Date())
        userDic["sdk_token"] = userID as? String
        
        if let username = User.currentUser?.username, username != "" {
            userDic["nick_name"] = username
        }else{
            userDic["nick_name"] = "未知"
        }
        
        if let phone = User.currentUser?.phone, phone != "" {
            userDic["cellphone"] = phone
        }
        
        if let email = User.currentUser?.email, email != "" {
            userDic["email"] = email
        }
        
        if let scope = User.currentUser?.username, scope != "" {
            userDic["description"] = scope
        }else{
            userDic["description"] = "无具体描述"
        }
        
        let params = ["user": userDic]
        UdeskManager.createCustomer(withCustomerInfo: params)
        
        // 咨询对象
        // let requestDic = ["productTitle": "台式空净", "productDetail": "$88888888", "productURL": "www.baidu.com"]
        
        let chatViewManager = UdeskSDKManager.init(sdkStyle: UdeskSDKStyle.default())
        chatViewManager?.leaveMessageButtonAction({ (vc) in
            
            // 留言回调 vc = UdeskChatViewController
            if let v = vc {
                self.leaveMessageBlock(v)
            }
            
        })
        // chatViewManager?.setProductMessage(requestDic)
        
        return chatViewManager
    }
}
