//
//  MyRegex.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

//正则表达式
import Foundation
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                                options: [],
                                                range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
func dateStampToString(_ timeStamp:String,format:String)->NSString {
    //print(timeStamp)
    let i1 = timeStamp.unicodeScalars.index(after: timeStamp.unicodeScalars.index(of: "(")!)
    let i2 = timeStamp.unicodeScalars.index(of: ")")!
    
    let substring = timeStamp.unicodeScalars[i1..<i2]
    let tmpstr=String(describing: substring.description)
    //有问题
    let date:Date = Date(timeIntervalSince1970: Double(tmpstr)!/1000)
    let dfmatter = DateFormatter()
    dfmatter.dateFormat=format
    
    print(dfmatter.string(from: date))
    return dfmatter.string(from: date) as NSString
}
func dateFromString(_ dateStr:NSString,format:String)->Date {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat=format
    var tmpDate=dfmatter.date(from: dateStr as String)!
    tmpDate=Date(timeIntervalSince1970: tmpDate.timeIntervalSince1970+8*3600)
    print(tmpDate)
    return tmpDate
}
func stringFromDate(_ date:Date,format:String)->NSString {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat=format
    return dfmatter.string(from: date) as NSString
}
