//
//  My_Rank_TDSCell.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

@objc protocol My_Rank_TDSCellDelegate {
    
    @objc func pushToLikeAction(index:IndexPath)
}

class My_Rank_TDSCell: UITableViewCell {
    @IBOutlet var tdsrank: UILabel!

    @IBOutlet var tdsHeadImg: UIImageView!
    
    @IBOutlet var tdsName: UILabel!
    @IBOutlet var tds: UILabel!
    @IBOutlet var jinduImage: UIImageView!
    @IBOutlet var zanimg: UIImageView!
    @IBOutlet var zancount: UILabel!
    
    @IBOutlet var zanButton: UIButton!
    
    var index: IndexPath!
    var delegate: My_Rank_TDSCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadUI(index:IndexPath) {
        self.index = index
    }
    
    @IBAction func likeAction(_ sender: AnyObject) {
                
        self.delegate.pushToLikeAction(index: index)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
