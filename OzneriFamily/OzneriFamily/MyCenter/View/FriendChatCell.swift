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
//        chatLab.text = model.chatStr
        
        var arrStr = model.chatStr!.components(separatedBy: "🐷")
        let text = NSMutableAttributedString.init(string: (arrStr[0]))
        
        text.addAttributes([NSFontAttributeName:  UIFont.boldSystemFont(ofSize: 13),NSForegroundColorAttributeName: UIColor.blue], range: NSRange(location: 0, length: text.length))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        text.addAttributes([NSParagraphStyleAttributeName:style], range: NSRange(location: 0, length: text.length))
        arrStr.remove(at: 0)
        var str = String(describing: arrStr)
        str = str.replacingOccurrences(of: "[\"", with: "")
        str = str.replacingOccurrences(of: "\"]", with: "")
        let text1 = NSMutableAttributedString.init(string: str)
        text.append(text1)
        
        chatLab.attributedText = text
        
        
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
