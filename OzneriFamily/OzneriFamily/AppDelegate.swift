//
//  AppDelegate.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //开启IQKEyBoard
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        //百度推送
        var myTypes=UIUserNotificationType()
        myTypes.insert(UIUserNotificationType.sound)
        myTypes.insert(UIUserNotificationType.badge)
        myTypes.insert(UIUserNotificationType.alert)
        let userSetting = UIUserNotificationSettings(types:myTypes, categories:nil)
        UIApplication.shared.registerUserNotificationSettings(userSetting)
        BPush.disableLbs()//禁用地理位置
        BPush.registerChannel(launchOptions, apiKey: "7nGBGzSxkIgjpEHHusrgdobS", pushMode: BPushMode.production, withFirstAction: nil, withSecondAction: nil, withCategory: nil, useBehaviorTextInput: false, isDebug: false)
        //注册微信//
        WXApi.registerApp("wx45a8cc642a2295b5", withDescription: "haoze")
        
        window?.rootViewController = LoginManager.instance.loginViewController
        window!.makeKeyAndVisible()
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
        BPush.bindChannel(completeHandler: { (result, error) -> Void in
            if ((result) != nil) {
                BPush.setTag("Mytag", withCompleteHandler: nil)
            }
        })
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BPush.handleNotification(userInfo)
        //completionHandler(UIBackgroundFetchResult.newData)
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
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

