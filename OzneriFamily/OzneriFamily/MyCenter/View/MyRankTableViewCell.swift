//
//  MyRankTableViewCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

@objc protocol MyRankTableViewCellDelegate {
    
    @objc optional func pushToFriendRank(index: IndexPath)
    
    @objc optional func pushToFriendLike(index: IndexPath)
    
}

class MyRankTableViewCell: UITableViewCell {

    @IBOutlet var LookZanMeButton: UIButton!
    
    @IBOutlet var pushToTDSBtn: UIButton!
    @IBOutlet var ToTDSButton: UIButton!
    
    @IBOutlet var RankValue: UILabel!
    @IBOutlet var PaimingLable: UILabel!
    @IBOutlet var NJRZJLable: UILabel!
    @IBOutlet var deviceImage: UIImageView!
    @IBOutlet var rankTitle: UILabel!
    @IBOutlet var Huozan: UILabel!
    
    @IBOutlet var todayTDS: UILabel!
    @IBOutlet var zanCount: UILabel!
    @IBOutlet var rankHead: UIImageView!
    @IBOutlet var rankState: UILabel!
 
    @IBOutlet weak var todaytext: UILabel!
    
    var delegate: MyRankTableViewCellDelegate!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    rankTitle.text = loadLanguage("水探头水质纯净值");
    
    PaimingLable.text = loadLanguage("排名");
    todaytext.text = loadLanguage( "您今日最佳");
    
        
    
    }
    
    //此处应换为model
    func loadUI(index: IndexPath) {
        
        self.indexPath = index
    }
    
    @IBAction func pushToFriendRank(_ sender: AnyObject) {
        
        delegate.pushToFriendRank!(index: indexPath)
        
    }

    @IBAction func pushToLike(_ sender: AnyObject) {
        
        delegate.pushToFriendLike!(index: indexPath)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
