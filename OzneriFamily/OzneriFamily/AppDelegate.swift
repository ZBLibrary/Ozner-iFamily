//
//  AppDelegate.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        return UIWindow(frame: UIScreen.main.bounds)
    }()
    lazy var loginViewController: LoginViewController = {
        
        return    UIStoryboard(name: "Login+Register+Guiding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }()
    //主视图控制器
    var mainTabBarController: MainTabBarController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //百度推送
        var myTypes=UIUserNotificationType()
        myTypes.insert(UIUserNotificationType.sound)
        myTypes.insert(UIUserNotificationType.badge)
        myTypes.insert(UIUserNotificationType.alert)
        let userSetting = UIUserNotificationSettings(types:myTypes, categories:nil)
        UIApplication.shared.registerUserNotificationSettings(userSetting)
        BPush.registerChannel(launchOptions, apiKey: "7nGBGzSxkIgjpEHHusrgdobS", pushMode: BPushMode.production, withFirstAction: nil, withSecondAction: nil, withCategory: nil, useBehaviorTextInput: false, isDebug: false)
        //微信
        
        window?.rootViewController = LoginManager.isFristOpenApp ? JCRootViewController(last: loginViewController):loginViewController
        window!.makeKeyAndVisible()
        return true
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
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
    //退出登录
    func LoginOut()
    {
        if appDelegate.mainTabBarController != nil{
            
            appDelegate.mainTabBarController?.dismiss(animated: true, completion: nil)
            appDelegate.mainTabBarController = nil
        }
        //清理用户文件
        NetworkManager.clearCookies()
        CoreDataManager.defaultManager = nil
        
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

