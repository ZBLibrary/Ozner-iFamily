//
//  MyFriendCell.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

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


}
