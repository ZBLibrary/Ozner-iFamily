//
//  FriendSearch.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class FriendSearch: UIView {

    
    @IBOutlet var SearchTextFD: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SearchTextFD.placeholder = loadLanguage("请输入手机号")
        
    }
}
