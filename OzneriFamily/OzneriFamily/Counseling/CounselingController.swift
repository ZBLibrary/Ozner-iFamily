//
//  CounselingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

let appid_News = "hzapi"
let appsecret_News = "8af0134asdffe12"

let appidandsecret = "&appid=hzapi&appsecret=8af0134asdffe12"

let NEWS_URL = "http://dkf.ozner.net/api"

var customerid_News = 0
let ChannelID_News = 4
let ct_id = 1 //咨询类别

var deviceid_News = ""//百度推送设备号


var acsstoken_News = ""
var sign_News = ""
public enum ChatHttpMethod {
    case GET
    case POST
}
public enum ChatType:String {
    case IMAGE = "123"
    case Content = "456"
}
class CounselingController: ZHCMessagesViewController {

    var demoData: ZHCModelData? {
        
        didSet{
            messageTableView?.reloadData()
        }
        
    }
    
    var presentBool: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavarionBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CounselingController.kefuAction), name: NSNotification.Name.init(rawValue: "KeFuMessage"), object: nil)
        
        demoData = ZHCModelData()

        DispatchQueue.main.async {
            
            self.recoverMessageInputToolBar();
            
        }
        
        User.GetAccesstoken()
    }
    
    
    func kefuAction() {
        
        DispatchQueue.main.async {
            
//            let  arrs:[ConsultModel] = ConsultModel.allCachedObjects() as! [ConsultModel]
            self.demoData  = ZHCModelData()
            self.finishSendingMessage(animated: true)
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
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
    
    //MARK: -头像
    override func tableView(_ tableView: ZHCMessagesTableView, avatarImageDataForCellAt indexPath: IndexPath) -> ZHCMessageAvatarImageDataSource? {
        
        
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
        
        let ava = (self.demoData?.avatars as? [String:ZHCMessagesAvatarImage])?[message.senderId]
        if ava != nil {
            return ava
        } else {
            return nil
        }
//        return ZHCMessagesAvatarImage(avatarImage: UIImage(named:"demo_avatar_jobs"), highlightedImage: UIImage(named:"demo_avatar_jobs"), placeholderImage: UIImage(named:"demo_avatar_jobs")!) /
        
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
        
        let currentMessage = demoData?.messages.object(at: indexPath.item) as! ZHCMessage

        if currentMessage.isMediaMessage {
            UUImageAvatarBrowser.show((currentMessage.media as! ZHCPhotoMediaItem).image)
        }
        
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

//        cell.backgroundColor =  UIColor.init(colorLiteralRed: 240/255.0, green: 247/255.0, blue: 254/255.0, alpha: 1.0)
        
        return cell
    }
    
    // MARK: - Configure Cell Data
    
    private func configureCell(cell: ZHCMessagesTableViewCell, indexPath: IndexPath) {
        
        let message = demoData?.messages.object(at: indexPath.row) as! ZHCMessage
        
        //设置字体的颜色
        if  message.isMediaMessage {
            if message.senderId == self.senderId() {
            cell.textView?.textColor = UIColor.black
            }
           
        } else {
            cell.textView?.textColor = UIColor.black
        }
                
        
        //,NSUnderlineStyle.patternSolid
        //此方法设置颜色没成功
//        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.red,
//                                             NSUnderlineStyleAttributeName: [NSUnderlineStyle.patternSolid,NSUnderlineStyle.styleSingle
//                                                ]]
        
        
    }
    
    // MARK: - Messages view controller
    // 发送文字消息
    override func didPressSend(_ button: UIButton?, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
    
        //在此发送数据到服务器 成功添加 否则不添加
        var urlStr = NEWS_URL + "/customermsg.ashx?access_token="
        urlStr += acsstoken_News + "&sign=" + sign_News.MD5
        
        let params:NSDictionary = ["customer_id":customerid_News as NSNumber,"device_id":deviceid_News,"channel_id": ChannelID_News as NSNumber,"msg": text]
        
        let mansger = AFHTTPSessionManager()
        mansger.requestSerializer = AFJSONRequestSerializer.init(writingOptions: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        mansger.post(urlStr, parameters: params, success: { (_, json) in
            print(json)
            
            let customId = JSON(json)
//            let imagURL = customId.dictionary?["msg"]?.stringValue
//            if imagURL == "success" {
            
                let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                
                conModel.content =  text
                conModel.type = ChatType.Content.rawValue
                conModel.userId = senderId
                
                CoreDataManager.defaultManager.saveChanges()
                self.demoData  = ZHCModelData()
                self.finishSendingMessage(animated: true)
//                }
            
            
        }) { (_, error) in
            
            let alertView = SCLAlertView()
            _ = alertView.addButton("确定", action: {})
            _ = alertView.showInfo("信息发送失败", subTitle: "请确保网络通畅并已关注浩泽微信公众号!")
            
        }
        
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
        
        weak var weakSelf = self
        switch index {
        case 0:
            BDImagePicker.show(from: self, allowsEditing: true, finishAction: { (image) in
                guard image != nil else {
                    return
                }
                weakSelf?.addPhotoImageToMessage(image: image!)
             
                }, andCamer: true)
        case 1:
            BDImagePicker.show(from: self, allowsEditing: true, finishAction: { (image) in
                guard image != nil else {
                    return
                }
                weakSelf?.addPhotoImageToMessage(image: image!)
               
                
                }, andCamer: false)
        default:
            break
        }
        
    }
    
    // MARK: -添加图片到聊天记录
 
    func addPhotoImageToMessage(image: UIImage) {
        
        let data: Data = UIImageJPEGRepresentation(image, 1.0)!

        var urlStr = NEWS_URL + "/uploadpic.ashx?access_token="
        urlStr += acsstoken_News + "&sign=" + sign_News.MD5
        
        let mansger = AFHTTPSessionManager()
        mansger.requestSerializer = AFJSONRequestSerializer.init(writingOptions: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        mansger.post(urlStr, parameters: nil, constructingBodyWith: { (dataFormat) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyHHmmss"
            let str = formatter.string(from: Date())
            let fileName = str + ".jpg"
            dataFormat.appendPart(withFileData: data, name: str, fileName: fileName, mimeType: "image/jpeg")
            
            }, success: { (_, json) in
                print(json)
                
                let customId = JSON(json)
                let imagURL = customId.dictionary?["result"]?.dictionary?["picpath"]?.stringValue
                

                var urlStr = NEWS_URL + "/customermsg.ashx?access_token="
                urlStr += acsstoken_News + "&sign=" + sign_News.MD5
                
                let params:NSDictionary = ["customer_id":customerid_News as NSNumber,"device_id":deviceid_News,"channel_id": ChannelID_News as NSNumber,"msg":"<img height=\"260px\" src=\"" + imagURL! + "\"/>"]
                
                mansger.post(urlStr, parameters: params, success: { (_, json) in
                    print(json)
                    
                    let photoItem = ZHCPhotoMediaItem(image: image)
                    
                    //收图片 false
                    //发图片true
                    photoItem.appliesMediaViewMaskAsOutgoing = true
                    let message = ZHCMessage(senderId: kZHCDemoAvatarIdJobs, displayName: kZHCDemoAvatarDisplayNameJobs, media: photoItem)
                    
                    let conModel =  CoreDataManager.defaultManager.create(entityName: "ConsultModel") as! ConsultModel
                    
                    conModel.content =  data.base64EncodedString()
                    conModel.type = ChatType.IMAGE.rawValue
                    conModel.userId = self.senderId()
                    
                    CoreDataManager.defaultManager.saveChanges()
                    let dataARR:[ConsultModel] = ConsultModel.allCachedObjects() as! [ConsultModel]
                    print(dataARR.count)
                    self.demoData?.messages.add(message)

                    self.finishSendingMessage()

               
                }) { (_, error) in
                    print(error)
                }

                
            }) { (_, error) in
                print(error)
        }
        
    }
    
    // MARK: - ZHCMessagesMoreViewDataSource
    override func messagesMoreViewTitles(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return [loadLanguage("拍摄"),loadLanguage("照片")]
    }
    
    override func messagesMoreViewImgNames(_ moreView: ZHCMessagesMoreView) -> [Any] {
        
        return ["chat_bar_icons_camera","chat_bar_icons_pic"]
    }
    

    
    private func initNavarionBar() {
        
        self.title = loadLanguage("咨询")
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
    
    func loadMessage(_ model:ConsultModel){
        
        let avatarFactory = ZHCMessagesAvatarImageFactory(diameter: 30)
        
        let cookImage = avatarFactory?.avatarImage(with: UIImage(named: "HaoZeKeFuImage"))
        
        let data = NSData(contentsOf: URL(string:(User.currentUser?.headimage)!)!)
        
        let jobsImage = avatarFactory?.avatarImage(with: UIImage.sd_image(with: data as Data!))
        
        self.demoData?.avatars = [kZHCDemoAvatarIdCook:cookImage,kZHCDemoAvatarIdJobs:jobsImage]
        
        self.demoData?.users = [kZHCDemoAvatarIdJobs:kZHCDemoAvatarIdJobs,
                                kZHCDemoAvatarIdCook:kZHCDemoAvatarDisplayNameCook]
        
        let bubbleFactory = ZHCMessagesBubbleImageFactory()
        
        
        self.demoData?.outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.zhc_messagesBubbleBlue())
        self.demoData?.incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.zhc_messagesBubbleGreen())
        
        if model.userId == kZHCDemoAvatarIdJobs {
            let message = ZHCMessage(senderId: model.userId!, displayName: "Jobs", text: model.content!)
            
            self.demoData?.messages.add(message)
        } else {
            let message = ZHCMessage(senderId: model.userId!, displayName: "小泽妹", text: model.content!)
            self.demoData?.messages.add(message)
        }
        
    }
    
    deinit {
        
    NotificationCenter.default.removeObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


