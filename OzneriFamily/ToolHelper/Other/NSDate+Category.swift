//
//  NSDate+Category.swift
//  GiantWeibo
//
//  Created by Ginat on 16/5/10.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func  dateWithStr(time: String) -> NSDate{
        //1.将服务器返回给我们的时间字符串转换为NSDate
        //1.1创建formatter
        
        let formatter = DateFormatter()
        //1.2设置时间的格式
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        //1.3设置时间的区域（真机必须设置，否则会转换失败）
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        //1.4转换字符串，转化好的时间是去除时区的时间
//        let createdDate = formatter.date(from: time)
        
        let date = NSDate(timeIntervalSince1970: Double(time)!/1000)
        
        return date
    }
    
    /*
     刚刚(一分钟内)
     X分钟内(一小时内)
     X小时前（当天）
     昨天HH：mm（昨天）
     MM - dd HH：mm（一年内）
     YYYY-MM-dd HH：mm （更早）
     */
    var descDate:String{
        let calendar = NSCalendar.current
        //1.判断是否是今天
        if calendar.isDateInToday(self as Date) {
            //1.0 获取当前时间和系统时间之间的差距(秒数)
            let since = Int(NSDate().timeIntervalSince(self as Date))
            //1.1是否是刚刚
            if since < 60 {
                return "刚刚"
            }
            //1.2多少分钟以前
            if  since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            //1.3多少小时以前
            return "\(since / (60 * 60))小时前"
        }
        
        //2.判断是否是昨天
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self as Date) {
            //昨天：HH:mm
            formatterStr = "昨天:" + formatterStr
        } else {
            //3.处理一年以内
            formatterStr = "MM-dd " + formatterStr
            //4.处理更早时间
//           let comps = calendar.components(NSCalendar.Unit.Year, fromDate: self, toDate: NSDate(), options:  NSCalendar.Options(rawValue: 0))
            let comps = calendar.component(Calendar.Component.year, from: self as Date)
            
            
            if comps >= 1 {
                formatterStr = "yyyy-" + formatterStr
            }
        }
        
        
        //5.按照指定的格式将时间转换为字符串
        //5.1
        let formatter = DateFormatter()
        //5.2设置时间的格式
        formatter.dateFormat = formatterStr
        //5.3设置时间的区域（真机必须设置，否则会转换失败）
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        //5.4格式化
        return formatter.string(from: self as Date)
    }
}
