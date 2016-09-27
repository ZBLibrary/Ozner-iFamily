//
//  NetworkManager.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/26.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFNetworking
class NetworkManager {
    func name()  {
        let af = AFNetworkReachabilityManager()
        print(af.isReachable)
    }
}
