//
//  SuccessPairCell.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SuccessPairCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var finishImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    func reloadUI() {
//        print("进来了")
        finishImage.isHidden = false
    }
    
    func changFinsishImageHidde() {
        finishImage.isHidden = !finishImage.isHidden
    }
}
