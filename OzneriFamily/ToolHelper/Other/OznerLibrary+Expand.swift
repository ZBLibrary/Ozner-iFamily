//
//  OznerLibrary+Expand.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/3.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
//TDSPan type:SCP001
//Tap type:SC001
extension Tap{
    override open var type:String{
        set{}
        get{
            let tmpType=self.settings.get("IsTDSPan", default: "false") as! String
            return tmpType=="true" ? "SCP001":"SC001"
        }
    }
    
}

