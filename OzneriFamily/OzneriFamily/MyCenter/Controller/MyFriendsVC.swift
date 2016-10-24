//
//  MyFriendsVC.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class FriendModel: NSObject {
    var nickName:String?
    
    //判断cell是否折叠
    var isBool: Bool?
    
}

class ChatModel: NSObject {
    var chatStr:String?
}

class MyFriendsVC: UIViewController {

    var tableView: UITableView!

    var bootomRecentView: FriendRecentView!
    //多少组
    var dataArr:[FriendModel]? = []
    
    var chaArrs:[[ChatModel]]? = []
    
    var chatModelArr:[ChatModel]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatas()

        setUI()
        
        
        
    }
    
    private  func getDatas() {
        for i in 0..<4 {
            
            let model = FriendModel()
            model.nickName = "Giant\(i)"
            model.isBool = true
            dataArr?.append(model)
        
        }
        
        let k = arc4random() % 4 + 2
        for _ in 0..<4 {
            for i in 0..<k {
                
                let chatModel = ChatModel()
                chatModel.chatStr = "dwaidawdjwaid帅住户驻足+\(i)"
                chatModelArr?.append(chatModel)
                
            }
            chaArrs?.append(chatModelArr!)
            chatModelArr?.removeAll()
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
        
        view.addSubview(bootomRecentView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        
        
        let model = (chaArrs?[section])! as [ChatModel]
        
        return model.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendChatID", for: indexPath) as! FriendChatCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendHeadID") as! MyFriendCell
        
        headCell.tag = 666 + section
        headCell.contentView.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFold(_:)))
    
//        headCell.contentView.addGestureRecognizer(tap)
        headCell.addGestureRecognizer(tap)
        return headCell
        
    }
    
    func tapFold(_ tap: UITapGestureRecognizer) {
        
        let tagIndex = (tap.view?.tag)! - 666
        
        let model = (dataArr?[tagIndex])! as FriendModel
        model.isBool = !model.isBool!
        
        tableView.reloadSections(NSIndexSet.init(index: tagIndex) as IndexSet, with: UITableViewRowAnimation.automatic)
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 63
    }
    

}
