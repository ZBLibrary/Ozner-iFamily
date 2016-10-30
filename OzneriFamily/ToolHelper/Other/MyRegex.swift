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
