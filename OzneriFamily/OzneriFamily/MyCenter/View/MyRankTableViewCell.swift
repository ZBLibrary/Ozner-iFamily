//
//  MyRankTableViewCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MyRankTableViewCell: UITableViewCell {

    @IBOutlet var LookZanMeButton: UIButton!
    
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
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    rankTitle.text = loadLanguage("水探头水质纯净值");
    
    PaimingLable.text = loadLanguage("排名");
    todaytext.text = loadLanguage( "您今日最佳");
    
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
