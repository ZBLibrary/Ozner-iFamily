//
//  AppDelegate.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import IQKeyboardManager
import UserNotifications
import WebImage
import SwiftyJSON
import CoreLocation
import JSPatchPlatform

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    private var locateManage:CLLocationManager?
    private var currentCoordinate: CLLocationCoordinate2D?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        window?.backgroundColor = UIColor.white
        
        User.loginWithLocalUserInfo(success: { (user) in
            LoginManager.instance.mainTabBarController = MainTabBarController()
            LoginManager.instance.mainTabBarController?.loadTabBar()
            LoginManager.instance.mainTabBarController?.modalTransitionStyle = .crossDissolve
            window?.rootViewController = LoginManager.instance.mainTabBarController
            
        }) { (error) in
            window?.rootViewController = LoginManager.instance.loginViewController
            
        }
        
        window!.makeKeyAndVisible()
        //开启IQKEyBoard
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        //百度推送
        var myTypes=UIUserNotificationType()
        myTypes.insert(UIUserNotificationType.sound)
        myTypes.insert(UIUserNotificationType.badge)
        myTypes.insert(UIUserNotificationType.alert)
        
        //        if #available(iOS 10.0, *) {
        //            let notifiCenter = UNUserNotificationCenter.current()
        //            notifiCenter.delegate = self
        //            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        //            notifiCenter.requestAuthorization(options: types) { (flag, error) in
        //                if flag {
        //                   print("iOS request notification success")
        //                }else{
        //                    print(" iOS 10 request notification fail")
        //                }
        //            }
        //        } else { //iOS8,iOS9注册通知
        let setting = UIUserNotificationSettings(types: [UIUserNotificationType.alert,UIUserNotificationType.sound,UIUserNotificationType.badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(setting)
        //        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        locateManage = CLLocationManager()
        
        locateManage?.delegate = self
        currentCoordinate = CLLocationCoordinate2D()
        
        if ((locateManage?.requestWhenInUseAuthorization()) == nil) {
            locateManage?.requestWhenInUseAuthorization()
        }
        
        locateManage?.desiredAccuracy = kCLLocationAccuracyBest
        locateManage?.startUpdatingHeading()
        
        //        let userSetting = UIUserNotificationSettings(types:myTypes, categories:nil)
        //        UIApplication.shared.registerUserNotificationSettings(userSetting)
        Bugly.start(withAppId: "78bbbe1a43")
        BPush.disableLbs()//禁用地理位置
        BPush.registerChannel(launchOptions, apiKey: "7nGBGzSxkIgjpEHHusrgdobS", pushMode: BPushMode.production, withFirstAction: nil, withSecondAction: nil, withCategory: nil, useBehaviorTextInput: false, isDebug: false)
        BPush.description()
        //        BPush.debugDescription()
        //注册微信//
        WXApi.registerApp("wx45a8cc642a2295b5", withDescription: "haoze")
        
        JSPatch.start(withAppKey: "c37296b9783bbf81")
        JSPatch.sync()
        
        updateversion()
        Thread.sleep(forTimeInterval: 2)
        return true
    }
    //微信 delegate---->
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return  WXApi.handleOpen(url, delegate: self)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let isSuc = WXApi.handleOpen(url, delegate: self)
        print("url \(url) isSuc \(isSuc == true ? 1 : 0)")
        return  isSuc
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    
    
    func onReq(_ req: BaseReq!) {
        
        if(req.isKind(of: GetMessageFromWXReq.classForCoder()))
        {
            // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
            let strTitle = loadLanguage("微信请求App提供内容")
            let strMsg = loadLanguage("微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信")
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
            
        }
        else if(req.isKind(of: ShowMessageFromWXReq.classForCoder()))
        {
            let temp = req as! ShowMessageFromWXReq
            let msg:WXMediaMessage = temp.message
            
            //显示微信传过来的内容
            let obj = msg.mediaObject as! WXAppExtendObject
            
            let strTitle = loadLanguage("微信请求App显示内容")
            let strMsg = "\(loadLanguage("标题："))\(msg.title) \n \(loadLanguage("内容: "))：\(msg.title) \n \(loadLanguage("附带信息："))\(msg.description)\n \(loadLanguage("缩略图:"))\(msg.thumbData.count) bytes\n\n\(obj)"
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
            
        }
        else if(req.isKind(of: LaunchFromWXReq.classForCoder()))
        {
            //从微信启动App
            let strTitle = loadLanguage("从微信启动")
            let strMsg = loadLanguage("这是从微信启动的消息")
            
            let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "ok")
            
            alert.show()
        }
        
    }
    
    //微信 delegate<--------
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BPush.registerDeviceToken(deviceToken)// 必须
        print(deviceToken)
        
        BPush.bindChannel(completeHandler: { (result, error) -> Void in
            
            if ((result) != nil) {
                
                BPush.setTag("GYMytag", withCompleteHandler: { (result, error) in
                    if (result != nil) {
                        print("设置tag成功")
                    }
                })
            }
        })
    }
    // 当 DeviceToken 获取失败时，系统会回调此方法
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DeviceToken 获取失败:\(error)")
    }
    
    
    //iOS 8/9
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        BPush.handleNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
        let WaterJson = userInfo as! [String: AnyObject]
        
        var action_baidu:String?
        var data_baidu:String?
        
        for (k,v) in WaterJson {
            
            if k == "action" {
                action_baidu = v as? String ?? ""
            }
            
            if k == "data" {
                data_baidu = v as? String ?? ""
            }
            
        }
        
        if action_baidu == "chat" {
            AudioServicesPlaySystemSound(1007)
            loadKeFuMessage(data_baidu!)
            
        }
        
        //        if application.applicationState ==  UIApplicationState.active {
        //            //不做任何处理
        //            if action_baidu == "chat" {
        //                AudioServicesPlaySystemSound(1007)
        //                loadKeFuMessage(data_baidu!)
        //
        //            }
        //
        //        }  else {
        //
        //            if action_baidu == "chat" {
        //                UIApplication.shared.applicationIconBadgeNumber = 1
        //                loadKeFuMessage(data_baidu!)
        //                //跳转聊天界面
        //                DispatchQueue.main.async {
        //
        //                    let alert = SCLAlertView()
        //                    _ = alert.addButton("跳转吧", action: {})
        //                    _ = alert.showInfo("点击了", subTitle: "123")
        ////                    LoginManager.instance.mainTabBarController?.selectedIndex = 2
        //                }
        //            }
        //
        //        }
        
        if action_baidu == "NewFriend" {
            //别人接受我的请求－－－－通知
        }
        
        if action_baidu == "NewFriendVF"{
            //别人请求添加我为好友 －－－通知
            
        }
        
        if action_baidu == "NewMessage" {
            //个人中心新留言通知
            
        }
        
        //个人中心有新排名通知
        if action_baidu=="NewRank"
        {
            
        }
        
        //有登录通知
        if action_baidu=="LoginNotify"
        {
            if User.currentUser?.usertoken==nil
            {
                return
            }
            if data_baidu!.contains((User.currentUser?.usertoken)!)
            {
                
            }
            else
            {
                //账号被人登录了
                let alert=UIAlertView(title: loadLanguage("提示"), message: loadLanguage("账号在另一台设备上登录了，请重新登录"), delegate: self, cancelButtonTitle: loadLanguage("确定"))
                alert.show()
            }
            
        }
        
    }
    
    
    func loadKeFuMessage(_ str:String){
        
        let msg = str
        
        if !msg.contains("<div style=") {
            
            let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
            
            conModel.type = ChatType.Content.rawValue
            conModel.userId = "0"
            conModel.content = msg
            CoreDataManager.defaultManager.saveChanges()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
            return
            
        }
        
        
        if msg.contains("<div style=") && !msg.contains("src=") {
            
            let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
            
            conModel.type = ChatType.Content.rawValue
            conModel.userId = "0"
            
            let range1 = msg.range(of: "雅黑\">")
            let range2 = msg.range(of: "</div>")
            conModel.content = msg.substring(with: (range1?.upperBound)!..<(range2?.lowerBound)!)
            
            CoreDataManager.defaultManager.saveChanges()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
            return
            
        }
        
        if msg.contains("<div style=") && msg.contains("src=") {
            
            var imageStr = ""
            if msg.contains(".gif") {
                //                        let range1 = msg.range(of: "http")
                //                        let range2 = msg.range(of: ".gif")
                //                        imageStr = msg.substring(with: (range1?.lowerBound)!..<(range2?.upperBound)!)
                let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                conModel.content =  msg
                conModel.type = ChatType.Content.rawValue
                conModel.userId = "0"
                CoreDataManager.defaultManager.saveChanges()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
                return
            }
            let arrStr = msg.components(separatedBy: "http")
            
            //如果只有一个url
            if arrStr.count == 2 {
                
                if  msg.contains("<img id=\"imgUpload\"") && msg.contains("微软雅黑\"><img") && msg.contains("\"></div>") {
                    
                    let range1 = msg.range(of: "http")
                    let range2 = msg.range(of: "\"></div>")
                    imageStr = msg.substring(with: (range1?.lowerBound)!..<(range2?.lowerBound)!)
                    
                    let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                    conModel.content =  imageStr
                    conModel.type = ChatType.IMAGE.rawValue
                    conModel.userId = "0"
                    
                    CoreDataManager.defaultManager.saveChanges()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
                    return
                    
                }
                
            }
            
            if arrStr.count > 2 {
                
                let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                conModel.content =  msg
                conModel.type = ChatType.Content.rawValue
                conModel.userId = "0"
                
                CoreDataManager.defaultManager.saveChanges()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
                
            }
            
        }
        
    }
    
    
    /*
     @available(iOS 10.0, *)//前台
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     print(notification.request.content.userInfo)
     completionHandler([.sound,.alert])
     DispatchQueue.main.async {
     
     let alert = SCLAlertView()
     
     _ = alert.showInfo("shoudaol", subTitle: "123")
     
     _ = alert.addButton("ahode", action: {})
     
     
     }
     }
     
     @available(iOS 10.0, *)//后台点击
     private func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void){
     let userInfo = response.notification.request.content.userInfo
     print("userInfo10:\(userInfo)")
     completionHandler()
     
     DispatchQueue.main.async {
     
     let alert = SCLAlertView()
     
     _ = alert.showInfo("shoudaol", subTitle: "123")
     
     _ = alert.addButton("ahode", action: {})
     
     
     }
     
     
     }
     
     */
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
        print(userInfo)
        
        
    }
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(error)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if UserDefaults.standard.value(forKey: UserDefaultsUserIDKey) != nil {
            
            CoreDataManager.defaultManager.saveChanges()
        }
    }
    
    // 版本更新提示
    func updateversion(){
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.github.com/repos/ozner-app-ios-org/updateApi/contents/InesUpdateFile/inse.json")!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, resopnse, error) in
            
            guard let _ = data else{
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                let str = ((json as! [String:AnyObject])["content"] as! String).replacingOccurrences(of: "\n", with: "")
                
                //解码
                let edcodeData = Data(base64Encoded: str, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                let decodedString = String(data: edcodeData!, encoding: String.Encoding.utf8)
                
                let data2 = decodedString?.data(using: String.Encoding.utf8)
                
                
                let dic = JSON(data: data2!)
                let versionsInAppStore = dic["result"]["version"].stringValue
                let desc = dic["result"]["updateDesc"].stringValue
                let updateType = dic["result"]["updateType"].stringValue
                let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                
                // 相同也算升序
                if versionsInAppStore.compare(currentVersion!) != ComparisonResult.orderedAscending {
                    
                    if updateType == "optional"{
                        
                        DispatchQueue.main.async(execute: {
                            let alertView = SCLAlertView()
                            alertView.addButton("前往更新 ", action: {
                                let url = "https://itunes.apple.com/cn/app/fm-lu-xing-jie-ban-lu-xing/id1153485553?mt=8";
                                UIApplication.shared.openURL(URL(string: url)!)
                                
                            })
                            alertView.addButton("取消", action: {})
                            
                            alertView.showInfo("发现新版本" + versionsInAppStore, subTitle: desc)
                        })
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertView = SCLAlertView()
                            alertView.addButton("前往更新 ", action: {
                                let url = "https://itunes.apple.com/cn/app/fm-lu-xing-jie-ban-lu-xing/id1153485553?mt=8";
                                UIApplication.shared.openURL(URL(string: url)!)
                                
                            })
                            
                            alertView.showInfo("发现新版本" + versionsInAppStore, subTitle: desc)
                            
                        })
                    }
                    
                } else {
                    
                    
                }
                
                
            }
            catch let error1 as NSError{
                print(error1)
            }
        })
        
        task.resume()
        
        
    }
    
    // MARK: - 定位
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newloca = locations.last {
            
            CLGeocoder().reverseGeocodeLocation(newloca, completionHandler: { (pms, error) in
                
                if !(error != nil) {
                    
                    if let _ = pms?.last?.location?.coordinate {
                        
                        manager.startUpdatingHeading()
                        
                        let placemark: CLPlacemark? = pms?.last
                        
                        if let mark = placemark {
                            
                            let locality = mark.locality ?? ""
                            
                            //保存定位地址
                            if locality.contains("市") {
                                
                                let str = locality.replacingOccurrences(of: "市", with: "")
                                
                                UserDefaults.standard.setValue(str, forKey: "GYCITY")
                                UserDefaults.standard.synchronize()
                            } else {
                                
                                UserDefaults.standard.setValue(locality, forKey: "GYCITY")
                                UserDefaults.standard.synchronize()
                            }
                            
                            self.locateManage?.stopUpdatingLocation()
                        }
                        
                    }
                    
                    
                }
                
            })
            
        }
        
    }
    
    
    
    
}

