//
//  MyFriendCenterView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SnapKit
class MyFriendCenterView: UIView {

    @IBOutlet weak var myRank: UIButton!
    
    @IBOutlet weak var myFriend: UIButton!
    @IBOutlet weak var bootomView: UIView!
    @IBOutlet weak var bootomView_Width: NSLayoutConstraint!
    
    @IBOutlet weak var bootomView_Tralling: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        myRank.contentHorizontalAlignment = .right
        myFriend.contentHorizontalAlignment = .left
        myRank.setTitle(loadLanguage("我的排名"), for: UIControlState.normal)
        myRank.setTitle(loadLanguage("我的好友"), for: UIControlState.selected)
        bootomView_Width.constant = 10
//        bootomView_Width.
        bootomView.snp.makeConstraints { (make) in
            
            make.leading.equalTo(myFriend.snp.leading).offset(0)
            
        }
    }
    
    func cancluateWidth(str:String) -> CGFloat {
        
        
        return 0
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
