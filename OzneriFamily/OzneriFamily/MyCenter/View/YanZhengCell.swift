//
//  YanZhengCell.swift
//  My
//
//  Created by test on 15/11/25.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
import WebImage

class YanZhengCell: UITableViewCell {

    @IBOutlet var AddButton: UIButton!
    
    @IBOutlet var headimage: UIImageView!
    
    @IBOutlet var YZmess: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet weak var label: UILabel!
    //@IBOutlet weak var message: UILabel!
 
    
    var viaildModel:YZNewsModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        AddButton.titleLabel?.text = loadLanguage("添加");
        
        label.text = loadLanguage("验证消息");
        
//        YZmess.text = loadLanguage("我是你好友,加我,谢谢");
        
    }
    
    func reloadUI(model:YZNewsModel) {
        
        viaildModel = model
        switch model.vivalState! {
        case .Wait:
            AddButton.setTitle(loadLanguage("添加"), for: UIControlState.normal)
        case .Agree:
//            AddButton.titleLabel?.text = loadLanguage("已添加")r
            AddButton.setTitle(loadLanguage("已添加"), for: UIControlState.normal)
            AddButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            AddButton.isEnabled = false
            AddButton.backgroundColor = UIColor.white
        case .Refused:
            AddButton.setTitle(loadLanguage("添加"), for: UIControlState.normal)
//            AddButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
//            AddButton.isEnabled = false
//            AddButton.backgroundColor = UIColor.white

        }

        YZmess.text = model.vivalMessage
        headimage.sd_setImage(with: URL(string: model.iconImage!))
        name.text = model.nickName
        
    }

    @IBAction func addFriendAction(_ sender: AnyObject) {
        
       
        weak var weakSelf = self
        
        let params:NSDictionary = ["id":viaildModel.vialID!]
        
        User.AcceptUserVerif(params,{ (responseObject) in
            
            print(responseObject)
            
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            
                if isSuccess > 0 {
                
                    weakSelf?.AddButton.setTitle(loadLanguage("已添加"), for: UIControlState.normal)
                    weakSelf?.AddButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                    weakSelf?.AddButton.isEnabled = false
                    weakSelf?.AddButton.backgroundColor = UIColor.white
                }
       
            
        }) { (error) in
            
            print(error)
            
        }

        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
