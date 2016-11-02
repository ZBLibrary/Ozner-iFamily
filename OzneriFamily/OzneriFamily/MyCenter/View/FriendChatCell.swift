//
//  FriendChatCell.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import DateTools

class FriendChatCell: UITableViewCell {

    @IBOutlet weak var chatLab: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func reloadUI(model:ChatModel) {
        chatLab.text = model.chatStr
        
        if model.chatTime! == "刚刚" {
            timeLb.text = "刚刚"
        } else {
        
        model.chatTime = model.chatTime?.replacingOccurrences(of: "/Date(", with: "")
        model.chatTime = model.chatTime?.replacingOccurrences(of: ")/", with: "")
        timeLb.text = NSDate.dateWithStr(time: model.chatTime!).descDate
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
