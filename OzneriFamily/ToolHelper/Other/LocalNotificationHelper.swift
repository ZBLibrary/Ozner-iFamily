//
//  LocalNotificationHelper.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/12/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation

class LocalNotificationHelper: NSObject {
   
    class func addCupNotice(repeatInter:Int,starTime:Int,endTime:Int) {
        if endTime<starTime
        {
            return
        }
        for i in 0...(endTime-starTime)/repeatInter{
            let tmptimeInt=starTime+i*repeatInter
            var tmptimeStr=(tmptimeInt/60<10 ? "0\(tmptimeInt/60)":"\(tmptimeInt/60)")
            tmptimeStr+=(":"+(tmptimeInt%60<10 ? "0\(tmptimeInt%60)":"\(tmptimeInt%60)"))
            let date=NSDate(string: tmptimeStr, formatString: "hh:mm")
            let notification = UILocalNotification()
            notification.fireDate = date as Date?
            // 时区
            notification.timeZone = NSTimeZone.default//[NSTimeZone defaultTimeZone];
            // 设置重复的间隔
            notification.repeatInterval = NSCalendar.Unit(rawValue: UInt(0))
            // 通知内容
            notification.alertBody =  "您的饮水时间已到，您该喝水了！"
            // 通知被触发时播放的声音
            notification.soundName = UILocalNotificationDefaultSoundName
            // 通知参数
            notification.userInfo = ["CupRemind":""]
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = NSCalendar.Unit.day
            // 执行通知注册
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
    }
    
    //补水仪
    class func removeNoticeForKey(key:String) {
        // 获取所有本地通知数组
        let localNotifications = UIApplication.shared.scheduledLocalNotifications
        for notification in localNotifications! {
            
            if let userInfo = notification.userInfo {
                // 根据设置通知参数时指定的key来获取通知参数
                // 如果找到需要取消的通知，则取消
                if userInfo[key] != nil {
                    UIApplication.shared.cancelLocalNotification(notification)
                }  
            }  
        }
    }
    class func addNoticeForKeyEveryDay(key:String,date:Date,alertBody:String) {
        let notification = UILocalNotification()
        notification.fireDate = date
        // 时区
        notification.timeZone = NSTimeZone.default//[NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = NSCalendar.Unit(rawValue: UInt(0))
        // 通知内容
        notification.alertBody =  alertBody
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName
        // 通知参数
        notification.userInfo = [key:""]
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendar.Unit.day
        // 执行通知注册
         UIApplication.shared.scheduleLocalNotification(notification)
    }
}
