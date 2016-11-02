//
//  MyFriendsVC.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class FriendModel: NSObject {
    var nickName:String?
    var iconImage:String?
    var chatNum:String?
    var chatFriendTel:String?
    var friendID: String?
    //判断cell是否折叠
    var isBool: Bool?
    
}

class ChatModel: NSObject {
    var chatStr:String?
    var chatTime:String?
    var chatNickName:String?
    
    var chatSendId:String?
}

class MyFriendsVC: UIViewController {

    var tableView: UITableView!

    var bootomRecentView: FriendRecentView!
    //多少组
    var dataArr:[FriendModel]? = []
    
    var chaArrs:NSMutableArray?
    
    var chatModelArr:[ChatModel]? = []
    
    var currentSecion:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        getDatas()

        
        setUI()
        
        
   
        
    }
    
    private  func getDatas() {
        SVProgressHUD.show()
        weak var weakSelf = self
        User.GetFriendList({ (responseObject) in
            SVProgressHUD.dismiss()
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            
            if isSuccess > 0 {
                print(responseObject)
                let modelArr = responseObject["friendlist"].array
                
                for item in modelArr! {
                    
                    let model = FriendModel()
                    model.nickName = item["Nickname"].stringValue
                    model.iconImage = item["Icon"].stringValue
                    model.isBool = true
                    model.chatNum = item["MessageCount"].stringValue
                    model.chatFriendTel = item["Mobile"].stringValue
                    model.friendID = item["FriendUserid"].stringValue
                    weakSelf?.dataArr?.append(model)
                    
                }
                weakSelf?.chaArrs = NSMutableArray(capacity: (weakSelf?.dataArr?.count)!)
                weakSelf?.tableView.reloadData()

            }
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error)
        }

        
    }

    private  func setUI() {
        
        tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: width_screen, height: height_screen), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        //        let nofriend = UINib(nibName: "FriendZeroBgView", bundle: nil).instantiate(withOwner: nil, options: nil).last as! FriendZeroBgView
        //        nofriend.frame = CGRect(x: 0, y: 49, width: width_screen, height: height_screen-height_navBar)
        //        tableView.backgroundView = nofriend
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "FriendChatCell", bundle: nil), forCellReuseIdentifier: "FriendChatID")
        tableView.register(UINib.init(nibName: "MyFriendCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "FriendHeadID")
        tableView.reloadData()
        
        bootomRecentView = UINib.init(nibName: "FriendRecentView", bundle: nil).instantiate(withOwner: nil, options: nil).last as! FriendRecentView
        bootomRecentView.frame = CGRect(x: 0, y: height_screen - 46 - height_navBar, width: width_screen, height: 46)
        bootomRecentView.sendBtn.addTarget(self, action: #selector(MyFriendsVC.sendMessageAction), for: UIControlEvents.touchUpInside)
        bootomRecentView.isHidden = true
        view.addSubview(bootomRecentView)
        
        
    }
    
    func sendMessageAction() {
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - height_screen
        print(changeY)
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            
            self.bootomRecentView.transform = CGAffineTransform(translationX: 0, y: changeY)
            
        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo

        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            //还原位置
            self.bootomRecentView.transform = CGAffineTransform.identity
        }
    }
    

    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension MyFriendsVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let friendMolde = (dataArr?[section])! as FriendModel
        
        if friendMolde.isBool! {
            return 0
        }
        
        guard friendMolde.chatNum != "0" else {
            return 0
        }
        
        if section == currentSecion {
            return chatModelArr?.count ?? 0
        } else {
            return 0
        }
//        let model = (chaArrs?[section])! as! [ChatModel]
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendChatID", for: indexPath) as! FriendChatCell
        let model = (chatModelArr?[indexPath.row])! as ChatModel
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(colorLiteralRed: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        cell.reloadUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendHeadID") as! MyFriendCell
        
        headCell.tag = 666 + section
        headCell.contentView.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFold(_:)))
        let model = (dataArr?[section])! as FriendModel
        
//        headCell.contentView.addGestureRecognizer(tap)
        headCell.addGestureRecognizer(tap)
        headCell.reloadUI(model: model)
        return headCell
        
    }
    
    func tapFold(_ tap: UITapGestureRecognizer) {
        
        let tagIndex = (tap.view?.tag)! - 666
        
        let model = (dataArr?[tagIndex])! as FriendModel
        model.isBool = !model.isBool!
        chatModelArr?.removeAll()
        currentSecion = tagIndex
        guard !model.isBool! else {
            bootomRecentView.isHidden = true
            tableView.reloadData()
            return
        }
        bootomRecentView.isHidden = false
        let group = DispatchGroup.init()
        SVProgressHUD.show()
        group.enter()
        weak var weakSelf = self
        print(model.friendID)
        User.GetHistoryMessage(["otheruserid":model.friendID!], { (responseObject) in
            print(responseObject)
            
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            
            if isSuccess > 0 {
                
                let modelArr = responseObject["data"].array
               
                for item in modelArr! {
                    
                    let model1 = ChatModel()
                    model1.chatNickName = item["Nickname"].stringValue
                    model1.chatTime = item["stime"].stringValue
                    model1.chatSendId = item["senduserid"].stringValue
                    if model1.chatSendId == model.friendID {
                      model1.chatStr = "我:" + item["message"].stringValue
                    } else {
                        model1.chatStr = (model1.chatNickName ?? "") + "回复我" + ":" + item["message"].stringValue
                    }
                    
                    weakSelf?.chatModelArr?.append(model1)
                }
            }
            
            SVProgressHUD.dismiss()
            group.leave()
            }) { (error) in
                
        }
        
        group.notify(queue: DispatchQueue.main) { 
            
//         weakSelf?.tableView.reloadSections(NSIndexSet.init(index: tagIndex) as IndexSet, with: UITableViewRowAnimation.automatic)
            weakSelf?.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 63
    }
    

}
