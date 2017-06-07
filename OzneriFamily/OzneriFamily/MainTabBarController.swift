//
//  MainTabBarController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MainTabBarController: RDVTabBarController {

    //
    func loadTabBar() {
        let ownerStr = (LoginManager.instance.currentLoginType==OznerLoginType.ByPhoneNumber ? User.currentUser?.phone : User.currentUser?.email)
        OznerManager.instance().setOwner(ownerStr)
        sleep(UInt32(1.5))
        let c1 = UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "MyDevicesController") as! MyDevicesController
        
        let leftViewController = UIStoryboard(name: "LeftMenu", bundle: nil).instantiateInitialViewController() as! LeftMenuController
        
        let nvc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateInitialViewController() as! GYNavViewController
        leftViewController.mainViewController=nvc
        SlideMenuOptions.leftViewWidth=298*width_screen/375
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = c1
        
        let c2=WebShopController()
      
//        let group = XZGroup()
//        group.gName = "咨询"
//        let chatVc = XZChatViewController()
//        chatVc.group = group
//        group.unReadCount = 2;
//        group.lastMsgString = "你等着!"
        
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
        let requestDic = ["productTitle": "台式空净", "productDetail": "$88888888", "productURL": "www.baidu.com"]
        
        let chatViewManager = UdeskSDKManager.init(sdkStyle: UdeskSDKStyle.default())
        chatViewManager?.leaveMessageButtonAction({ (vc) in
            // vc 就是 "UdeskChatViewController.h"
            // 从聊天界面跳转转到自定义的留言界面
            //                let msgVC = RNMessageViewController()
            //                let nav = UINavigationController(rootViewController: msgVC)
            //                vc?.navigationController?.present(nav, animated: true, completion: {
            //                    //
            //                })
            
        })
        chatViewManager?.setProductMessage(requestDic)
        
        let config =  UdeskSDKConfig.init()
        let setting = UdeskSetting.init()
        
        let messageVC = RNChatViewController(sdkConfig: config, withSettings: setting)
        
       // let messageVC = RNMessageViewController()
        let nav3 = UINavigationController(rootViewController: messageVC!)
        
        let c4=UIStoryboard(name: "MainMyCenter", bundle: nil).instantiateInitialViewController() as!GYNavViewController
        
        self.viewControllers=[slideMenuController,c2,nav3,c4]
        //设置tabbar
        //自定义
        self.tabBar.isTranslucent=false
        self.tabBar.backgroundColor=UIColor.white
        var index=0
        for item in (self.tabBar.items as! [RDVTabBarItem]){
            item.title=[loadLanguage("我的设备"),loadLanguage("商城"),loadLanguage("咨询"),loadLanguage("我")][index]
            item.setBackgroundSelectedImage(UIImage(named: "bg_TabBar"), withUnselectedImage: UIImage(named: "bg_TabBar"))
            item.setFinishedSelectedImage(UIImage(named: "bar_select_\(index)"), withFinishedUnselectedImage: UIImage(named: "bar_normal_\(index)"))
            index+=1
        }
        CustomTabBarIsHidden = !(LoginManager.instance.currentLoginType==OznerLoginType.ByPhoneNumber)
        setTabBarHidden(CustomTabBarIsHidden, animated: false)
    }
    private var CustomTabBarIsHidden:Bool!//系统tabbar是不是隐藏的
    override func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        super.setTabBarHidden(CustomTabBarIsHidden||hidden, animated:animated)
    }
    

}
