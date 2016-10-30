//
//  LanguageHelper.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation


func loadLanguage(_ text:String)->String
{
    return  NSLocalizedString(text, comment: "")
}
// 快捷设置多语言
extension UILabel{
    public var textWithLanguage:String{
        set{
            self.text=loadLanguage(newValue)
        }
        get{
            return self.textWithLanguage
        }
        
    }
}

extension UIButton{
    public var textWithLanguage:String{
        set{
            self.setTitle(loadLanguage(newValue), for: UIControlState.normal)
        }
        get{
            return self.textWithLanguage
        }
        
    }
}
extension UITextField{
    public var placeholderWithLanguage:String{
        set{
            self.placeholder=loadLanguage(newValue)
        }
        get{
            return self.placeholderWithLanguage
        }
        
    }
}
