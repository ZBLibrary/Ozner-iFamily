//
//  MyFriendCenterView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

@objc protocol MyFriendCenterViewDelegate {
    
    @objc optional func btnClick()
    
}

class MyFriendCenterView: UIView {

    @IBOutlet weak var myRank: UIButton!
    
    @IBOutlet weak var myFriend: UIButton!
    @IBOutlet weak var bootomView: UIView!
    
    @IBOutlet weak var bootomView2: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myRank.contentHorizontalAlignment = .right
        myFriend.contentHorizontalAlignment = .left
        myRank.setTitle(loadLanguage("我的排名"), for: UIControlState.normal)
        myRank.setTitle(loadLanguage("我的排名"), for: UIControlState.selected)
        myFriend.setTitle(loadLanguage("我的好友"), for: UIControlState.normal)
        myFriend.setTitle(loadLanguage("我的好友"), for: UIControlState.selected)
        myRank.isSelected = true
        bootomView2.isHidden = true
        

    }
    
 
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
