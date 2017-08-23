//
//  MyFriendCell.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SDWebImage

class MyFriendCell: UITableViewHeaderFooterView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var messageLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImage.layer.cornerRadius = 19
        iconImage.layer.masksToBounds = true
        
    }

    func reloadUI(model:FriendModel) {
        
        if model.iconImage != nil || model.iconImage != "" {
            
            iconImage.sd_setImage(with: URL(string: model.iconImage!))
        } else {
            iconImage.image = UIImage(named: "HaoZeKeFuImage")
        }
        
        nickName.text = model.nickName ?? loadLanguage("浩小泽")
        messageLb.text = model.chatNum! + loadLanguage("条留言")
        
    }
    

}
