//
//  GloabConfig.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation

//登陆控制类
enum OznerLoginType:String{
    case ByPhoneNumber="ByPhoneNumber"
    case ByEmail="ByEmail"
}
// app类型
enum OznerAppType:String
{
    case OzneriFamily="浩泽净水家"
    case YiQuan="伊泉净品"
}
class LoginManager:NSObject{
    //是否是第一次登陆
    class var isFristOpenApp:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "IsFristOpenApp")
        }
        get{
            return  UserDefaults.standard.object(forKey: "IsFristOpenApp") == nil ? true:false
        }
    }
    //当前登陆方式
    class var currentLoginType:OznerLoginType{
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "currentLoginType")
        }
        get{
            let s = UserDefaults.standard.object(forKey: "currentLoginType") as! String
            return  OznerLoginType(rawValue: s)!
        }
    }
    //是不是中文简体
    static let isChinese_Simplified:Bool = {
            return  loadLanguage("isChinese_Simplified")=="true"
    }()
    //判断是不是“浩泽净水家”
    static let currentApp:OznerAppType = {
        let info = Bundle.main.infoDictionary
        let name = info?["CFBundleDisplayName"] as! String
        return OznerAppType(rawValue: name)!
    }()
}


