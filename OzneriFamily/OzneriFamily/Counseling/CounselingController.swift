//
//  CounselingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CounselingController: ZHCMessagesViewController {

    var demoData: ZHCModelData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavarionBar()
        
        demoData = ZHCModelData()
       
        
    }
    
    // MARK: - ZHCMessagesTableViewDataSource
    
    override func senderDisplayName() -> String {
        return "Jobs"
    }
    
    override func senderId() -> String {
        return "707-8956784-57"
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, messageDataForCellAt indexPath: IndexPath) -> ZHCMessageData {
        
        return demoData?.messages[indexPath.row] as! ZHCMessage
    }
    
    
    
    
    
    
    override func tableView(_ tableView: ZHCMessagesTableView, didDeleteMessageAt indexPath: IndexPath) {
        
        //删除聊天记录
        demoData?.messages.removeObject(at: indexPath.row)
        
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, messageBubbleImageDataForCellAt indexPath: IndexPath) -> ZHCMessageBubbleImageDataSource? {
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
    
        if message.isMediaMessage {
            print("is mediaMessage")
        }
        
        
        if message.senderId == self.senderId(){
            
            return self.demoData?.outgoingBubbleImageData
            
        }
        
        return self.demoData?.incomingBubbleImageData
        
    }
    
    //头像
    override func tableView(_ tableView: ZHCMessagesTableView, avatarImageDataForCellAt indexPath: IndexPath) -> ZHCMessageAvatarImageDataSource? {
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
        
        let ava = (self.demoData?.avatars as! [String:ZHCMessagesAvatarImage])[message.senderId]
        
        
        return nil
        
    }
  
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        //每隔三行显示一次时间
        if indexPath.row%3 == 0 {
            let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
            
            return ZHCMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            
        }
        return nil
    }
   
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
        
        if message.senderId == self.senderId() {
            return nil
        }
        
        if indexPath.row - 1 > 0 {
            let premessage = demoData?.messages.object(at: indexPath.row - 1) as! ZHCMessage
            
            if premessage.senderId == message.senderId {
                return nil
            }
            
        }
        
        return NSAttributedString(string: message.senderDisplayName)
        
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    
//    override func tableView(_ tableView: ZHCMessagesTableView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
//        
//        
//    }

    //MARK: - Adjusting cell label heights
    override func tableView(_ tableView: ZHCMessagesTableView, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        var labelHeight:CGFloat = 0
        
        if indexPath.item % 3 == 0 {
            labelHeight = CGFloat(kZHCMessagesTableViewCellLabelHeightDefault)
        }
        
        return labelHeight
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        var labelHeight:CGFloat = CGFloat(kZHCMessagesTableViewCellLabelHeightDefault)
        
        let currentMessage = demoData?.messages.object(at: indexPath.item) as! ZHCMessage
        
        if currentMessage.senderId == self.senderId() {
            labelHeight = 0
        }
        
        if indexPath.item - 1 > 0  {
            let previousMessage = demoData?.messages .object(at: indexPath.item - 1) as! ZHCMessage
            
            if previousMessage.senderId == currentMessage.senderId {
                labelHeight = 0
            }
            
        }
        
        return labelHeight
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat {
        
        return 0
        
    }
    
    // MARK: - ZHCMessagesTableViewDelegate
    
    override func tableView(_ tableView: ZHCMessagesTableView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
        
        super.tableView(tableView, didTapAvatarImageView: avatarImageView, at: indexPath)
        
        print("didTapAvatarImageViewIndexPath:\(indexPath.row)")
        
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, didTapMessageBubbleAt indexPath: IndexPath) {
        
        super.tableView(tableView, didTapMessageBubbleAt: indexPath)
        print("didTapMessageBubbleAtIndexPath:\(indexPath.row)")
        
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, didTapCellAt indexPath: IndexPath, touchLocation: CGPoint) {
        super.tableView(tableView, didTapCellAt: indexPath, touchLocation: touchLocation)
        
        print("didTapCellAtIndexPath:\(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        super.tableView(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
        print("performAction\(indexPath.row)")
        
    }
    
    // MARK: - TableView datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData?.messages.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! ZHCMessagesTableViewCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Configure Cell Data
    
    private func configureCell(cell: ZHCMessagesTableViewCell, indexPath: IndexPath) {
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
        
        
        if  message.isMediaMessage {
            if message.senderId == self.senderId() {
            cell.textView?.textColor = UIColor.black
            }
           
        } else {
            cell.textView?.textColor = UIColor.white
        }
                
        
        //,NSUnderlineStyle.patternSolid
        //此方法设置颜色没成功
//        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.red,
//                                             NSUnderlineStyleAttributeName: [NSUnderlineStyle.patternSolid,NSUnderlineStyle.styleSingle
//                                                ]]
        
        
    }
    
    // MARK: - Messages view controller
    
    override func didPressSend(_ button: UIButton?, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        let message = ZHCMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        demoData?.messages.add(message)
        
        self.finishSendingMessage(animated: true)
        
    }
    
    // MARK: - ZHCMessagesInputToolbarDelegate
    override func messagesInputToolbar(_ toolbar: ZHCMessagesInputToolbar, sendVoice voiceFilePath: String, seconds senconds: TimeInterval) {
        
        //将要废弃
        //拿到语音提示
//        let autioData = NSData.dataWithContentsOfMappedFile(voiceFilePath) as! NSData
//        
//        let audioItem = ZHCAudioMediaItem(data: autioData as Data)
//        
//        let audioMessage = ZHCMessage(senderId: self.senderId(), displayName: self.senderDisplayName(), media: audioItem)
//        
//        self.demoData?.messages.add(audioMessage)
//        
//        self.finishSendingMessage(animated: true)
//        
        
        
    }
    
    // MARK: - ZHCMessagesMoreViewDelegate
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
    
    
    
    // MARK: - ZHCMessagesMoreViewDataSource
    override func messagesMoreViewTitles(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return ["相机","照片"]
    }
    
    override func messagesMoreViewImgNames(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return ["chat_bar_icons_camera","chat_bar_icons_pic"]
    }
    

    
    private func initNavarionBar() {
        
        self.title = "咨询"
        self.view.backgroundColor = UIColor.white
//        navigationController?.toolbar.barTintColor = UIColor.white
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


