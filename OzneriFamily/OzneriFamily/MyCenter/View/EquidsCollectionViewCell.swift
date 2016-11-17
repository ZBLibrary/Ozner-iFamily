//
//  EquidsCollectionViewCell.swift
//  My
//
//  Created by test on 15/11/24.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class EquidsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var equipNameLabel: UILabel!
    @IBOutlet var equipImage: UIImageView!
    @IBOutlet var right_up: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
         equipNameLabel.text = loadLanguage("智能水杯");
         right_up.setTitle(loadLanguage("活动"), for: UIControlState.normal)
        right_up.setTitleColor(UIColor.white, for: UIControlState.normal)
        
    
    
    }
    func update()
    {
        
    }
}
