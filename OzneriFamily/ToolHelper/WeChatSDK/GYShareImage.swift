//
//  GYShareImage.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 2016/11/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SnapKit

class GYShareImage: UIView {

    var topView:UIView!
    var share_title:UILabel!
    var share_rank:UILabel!
    var share_value:UILabel!
    var share_beat:UILabel!
    var share_stateImage:UIImageView!
    var share_OwnerImage:UIImageView!
    var share_OwnerName:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI() {
        

        topView = UIView(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen - 150))
        let shareHeadicon = UIImageView(image: UIImage(named: "shareHeadicon"))
        shareHeadicon.frame = CGRect(origin: CGPoint(x: (width_screen - 122)/2, y: 0), size: CGSize(width: 122, height: 122))
        if #available(iOS 10.0, *) {
            topView.backgroundColor = UIColor.init(displayP3Red: 123/255.0, green: 196/255.0, blue: 251/255.0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
            topView.backgroundColor = UIColor.init(red: 123/255.0, green: 196/255.0, blue: 251/255.0, alpha: 1.0)
        }
      
        addSubview(topView)
        topView.addSubview(shareHeadicon)
        share_rank = UILabel()
        topView.addSubview(share_rank)
        
        share_rank.text = "好友排名1";
        share_rank.font = UIFont.systemFont(ofSize: 15)
        share_rank.textColor = UIColor.white
        share_rank.textAlignment = .center
        share_rank.frame = CGRect(x: shareHeadicon.frame.origin.x + 2, y: shareHeadicon.frame.size.height - 40 , width: 122 - 4, height: 20);
        share_title = UILabel(frame: CGRect(x: 0, y: shareHeadicon.frame.size.height + 20, width: width_screen, height: 20))
        share_title.textAlignment = .center
        share_title.text = "当前饮水量为"
        share_title.textColor = UIColor.white
        share_title.font = UIFont.systemFont(ofSize: 15)
        topView.addSubview(share_title)
        
        share_value = UILabel(frame: CGRect(x: 0, y: share_title.frame.origin.y + 20 + 5, width: width_screen, height: 30))
        share_value.textAlignment = .center
        share_value.text = "200ml"
        share_value.textColor = UIColor.white
        share_value.font = UIFont.systemFont(ofSize: 30)
        topView.addSubview(share_value)
        
        share_beat = UILabel(frame: CGRect(x: 0, y: share_value.frame.origin.y + 30 + 5, width: width_screen, height: 20))
        share_beat.textAlignment = .center
        share_beat.text = "击败了66%的用户"
        share_beat.textColor = UIColor.white
        share_beat.font = UIFont.systemFont(ofSize: 15)
        topView.addSubview(share_beat)
        
        share_stateImage = UIImageView(frame: CGRect(x: 0, y: share_beat.frame.origin.y + 20 + 10, width: width_screen, height: topView.frame.size.height - 35 - (share_beat.frame.origin.y + 20 + 35)))
        share_stateImage.image = UIImage(named: "share_Water1")
        topView.addSubview(share_stateImage)
        
        share_OwnerImage = UIImageView(frame: CGRect(x: (width_screen - 70)/2, y: topView.frame.size.height - 35 , width: 70, height: 70))
        share_OwnerImage.layer.cornerRadius = 35.0
        share_OwnerImage.layer.masksToBounds = true
        share_OwnerImage.image = UIImage(named: "shareOwnerimg")
        addSubview(share_OwnerImage)
        
        share_OwnerName = UILabel(frame: CGRect(x: 0, y: share_OwnerImage.frame.origin.y + 70 + 5, width: width_screen, height: 20))
        share_OwnerName.textAlignment = .center
        share_OwnerName.text = "浩小泽"
        // 48 151 243
        share_OwnerName.textColor = UIColor.init(red: 48.0/255.0, green: 151/255.0, blue: 243/255.0, alpha: 1.0)
        share_OwnerName.font = UIFont.systemFont(ofSize: 15)
        addSubview(share_OwnerName)
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"shareAppIcon"), for: UIControlState.normal)
        btn.setTitle("来自浩泽净水家", for: UIControlState.normal)
        btn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect(x: 0, y: share_OwnerName.frame.origin.y + 20, width: width_screen, height: 40)
        
        addSubview(btn)
   

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
