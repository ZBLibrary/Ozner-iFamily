//
//  CounselingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CounselingController: ZHCMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavarionBar()        

    }
    
    // MARK: - ZHCMessagesTableViewDataSource
    
    override func senderDisplayName() -> String {
        return "Jobs"
    }
    
    override func senderId() -> String {
        return "707-8956784-57"
    }
    
//    override func tableView(_ tableView: ZHCMessagesTableView, messageDataForCellAt indexPath: IndexPath) -> ZHCMessageData {
//        
//        return ZHCMessageData.self as! ZHCMessageData
//    }
//    
    override func tableView(_ tableView: ZHCMessagesTableView, didDeleteMessageAt indexPath: IndexPath) {
        
        //删除聊天记录
        
    }
    
   
    
    override func tableView(_ tableView: ZHCMessagesTableView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
        
        
    }
    
    
    // MARK: - ZHCMessagesMoreViewDataSource
    override func messagesMoreViewTitles(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return ["相机","照片"]
    }
    
    override func messagesMoreViewImgNames(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return ["chat_bar_icons_camera","chat_bar_icons_pic"]
    }
    
    override func messagesMoreView(_ moreView: ZHCMessagesMoreView, selectedMoreViewItemWith index: Int) {
        
        switch index {
        case 0:
            print("相机")
        case 1:
            print("照片")
        default:
            break
        }
        
    }
    
    private func initNavarionBar() {
        
        self.title = "咨询"
        self.view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"CallPhoneImage"), style: UIBarButtonItemStyle.done, target: self, action: #selector(CounselingController.phoneCallAction))
        
    }
    
    func phoneCallAction() {
        
        //直接拨打
//        UIApplication.shared.openURL(URL(string: "tel:4008202667")!)
        
        let callWebView = UIWebView()
        
        callWebView.loadRequest(URLRequest(url: URL(string: "tel:4008202667")!))
        
        view.addSubview(callWebView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


