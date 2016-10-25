//
//  ZanMeTableViewCell.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class ZanMeTableViewCell: UITableViewCell {

    @IBOutlet var zanMeImage: UIImageView!
    @IBOutlet var zanMeName: UILabel!
    @IBOutlet var zanMeTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
