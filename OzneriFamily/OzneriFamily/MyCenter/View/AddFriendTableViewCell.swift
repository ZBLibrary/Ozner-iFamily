//
//  AddFriendTableViewCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet var Name: UILabel!
    @IBOutlet var headImage: UIImageView!
    @IBOutlet var AddFriendButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AddFriendButton.setTitle(loadLanguage("添加"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
