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

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = LoginManager.instance.loginViewController
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
        
        
    
//        let userSetting = UIUserNotificationSettings(types:myTypes, categories:nil)
//        UIApplication.shared.registerUserNotificationSettings(userSetting)
        BPush.disableLbs()//禁用地理位置
        BPush.registerChannel(launchOptions, apiKey: "7nGBGzSxkIgjpEHHusrgdobS", pushMode: BPushMode.production, withFirstAction: nil, withSecondAction: nil, withCategory: nil, useBehaviorTextInput: false, isDebug: false)
        BPush.description()
//        BPush.debugDescription()
        //注册微信//
        WXApi.registerApp("wx45a8cc642a2295b5", withDescription: "haoze")
        
        
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
            print(result)
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
        print(userInfo)
        
        let alert = SCLAlertView()
        
        _ = alert.showInfo("shoudaol", subTitle: "123")
        
        _ = alert.addButton("ahode", action: {})
        
        let WaterJson = userInfo as! [String: AnyObject]
        
        do {
            let strChat = try! JSONSerialization.data(withJSONObject: WaterJson, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            DispatchQueue.main.async {
                
                let alert = SCLAlertView()
                
                _ = alert.showInfo(strChat.base64EncodedString(), subTitle: "123")
                
                _ = alert.addButton("ahode", action: {})
                
                
            }

        } catch {
            
        }
        
        
        for (k,v) in WaterJson {
        
            if k == "data" {
                let msg = v as! String
                let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                conModel.content =  msg
                conModel.type = ChatType.Content.rawValue
                conModel.userId = "468-768355-23123"
                
                if msg.contains("<div style=") {
                    conModel.content = try! NSAttributedString.init(data: msg.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil).string
                }
                
                let msS = msg as NSString
                
//                let str = msS.sub
                
                
                
                if msg.contains("<div style=") && msg.contains("src=") {
                
                do {
                    let regex = try! NSRegularExpression(pattern: "<img\\ssrc[^>]*/>", options: .allowCommentsAndWhitespace)
                    
                    let result = regex.matches(in: msg, options: .reportCompletion, range: NSMakeRange(0, msg.characters.count))
                    
                    var content = msg as NSString
                    var sourceSrcs: [String: String] = ["": ""]
                    
                    for item in result {
                        let range = item.rangeAt(0)
                        
                        let imgHtml = content.substring(with: range) as NSString
                        var array = [""]
                        
                        if imgHtml.range(of: "src=\"").location != NSNotFound {
                            array = imgHtml.components(separatedBy: "src=\"")
                        } else if imgHtml.range(of: "src=").location != NSNotFound {
                            array = imgHtml.components(separatedBy: "src=")
                        }
                        
                        if array.count >= 2 {
                            var src = array[1] as NSString
                            if src.range(of: "\"").location != NSNotFound {
                                src = src.substring(to: src.range(of: "\"").location) as NSString
                                
                                // 图片链接正确解析出来
                                print(src)
                                
                                DispatchQueue.main.async {
                                    
                                    let alert = SCLAlertView()
                                    
                                    _ = alert.showInfo(src as String, subTitle: "123")
                                    
                                    _ = alert.addButton("ahode", action: {})
                                    
                                    
                                }
                                
                                // 加载图片
                                // 这里不处理重复加载的问题，实际开发中，应该要做一下处理。
                                // 也就是先判断是否已经加载过，且未清理掉该缓存的图片。如果
                                // 已经缓存过，否则才执行下面的语句。
                                let data = try? Data(contentsOf: URL(string: src as String)!)
                                
                                conModel.type = ChatType.IMAGE.rawValue
                                conModel.content = data?.base64EncodedString()
                                
                                // 记录下原URL和本地URL
                                // 如果用异步加载图片的方式，先可以提交将每个URL起好名字，由于这里使用的是原URL的md5作为名称，
                                // 因此每个URL的名字是固定的。
                            }
                        }
                    }

                }
                }
//                if msg.contains("<div style=") && msg.contains("src=") {
//                    
//                    conModel.type = ChatType.IMAGE.rawValue
//                    
//                    let regex = try! NSRegularExpression(pattern: "<img\\ssrc[^>]*/>", options: .allowCommentsAndWhitespace)
//                    
//                    let result = regex.matches(in: msg, options: .reportCompletion, range: NSRange(location: 0,length: msg.characters.count))
//                    
//                    for item in result {
//                        
//                        _ = item.rangeAt(0)
//                        
//                        
//                    }
//                    
////                    conModel.content
//                    
//                }
   
                CoreDataManager.defaultManager.saveChanges()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeFuMessage"), object: nil)
                
                DispatchQueue.main.async {
                    
                    let alert = SCLAlertView()
                    
                    _ = alert.showInfo("搜到消息", subTitle: msg)
                    
                    _ = alert.addButton("ahode", action: {})
                    
                    
                }
                
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if UserDefaults.standard.value(forKey: UserDefaultsUserIDKey) != nil {
            
            CoreDataManager.defaultManager.saveChanges()
        }
    }


}

