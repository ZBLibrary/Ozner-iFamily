//
//  ShareMoneyToWeChat.swift
//  OZner
//
//  Created by 赵兵 on 16/8/23.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class ShareMoneyToWeChat: UIView {

    //var didRemoved:(()->Void)?
    
    //WXSceneSession  = 0,        /**< 聊天界面    */
    //WXSceneTimeline = 1,
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBAction func shareClick(_ sender: UIButton) {
        let shareStr="http://www.oznerwater.com/lktnew/wap/wxoauth.aspx?gourl=http://www.oznerwater.com/lktnew/wap/Member/InvitedMemberBrand.aspx"
        OznerShareManager.ShareLinkToWeChat(sence: [WXSceneSession,WXSceneTimeline][sender.tag], url: shareStr, title: "疯了疯了，注册浩泽会员就送微信红包", titleImg: UIImage(named: "loginLogo")!, LinkDes: "点击即可领取浩泽大红包")
        self.removeFromSuperview()
        //didRemoved!()
    }
    @IBAction func cancelClick(_ sender: AnyObject) {
        self.removeFromSuperview()
        //didRemoved!()
       
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //bottomConstraint.constant = -233*Screen_Hight/568
    }
 

    
//    func showView()  {
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(2)
//        bottomConstraint.constant = 0
//        UIView.commitAnimations()
//    }
    
}
