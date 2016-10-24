//
//  YanZhengCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class YanZhengCell: UITableViewCell {

    @IBOutlet var AddButton: UIButton!
    
    @IBOutlet var headimage: UIImageView!
    
    @IBOutlet var YZmess: UILabel!
    
    @IBOutlet var name: UILabel!
    
    //@IBOutlet weak var message: UILabel!
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    AddButton.titleLabel?.text = loadLanguage("添加");
        
  //message.text = loadLanguage("验证消息");
        
  YZmess.text = loadLanguage("我是你好友,加我,谢谢");
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
