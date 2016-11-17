//
//  AddFriendsTableViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI
//import WebImage
////添加好友
//struct myFriend {
//    var isExist=false
//    var Name=""
//    var imgUrl=""
//    var status = -10014  //－10014不是浩泽用户 0没关系 1"已发送" 2"已添加"
//    var phone=""
//    var messageCount=0
//}

class AddFriendsTableViewController: UITableViewController,UITextFieldDelegate {

    
    var sendPhone=""
    var seachResult=myFriend( )
    //NSMutableArray
    var tabelHeaderView:FriendSearch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=loadLanguage("添加好友")

        self.tableView.rowHeight = 44
        tableView.register(UINib.init(nibName: "AddFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendTableViewCellid")
        tabelHeaderView = Bundle.main.loadNibNamed("FriendSearch", owner: self, options: nil)?.last as! FriendSearch
        tabelHeaderView.searchButton.addTarget(self, action: #selector(SearchPhone), for: .touchUpInside)
        tabelHeaderView.SearchTextFD.delegate=self
        self.tableView.tableHeaderView=tabelHeaderView
//        tableView.delegate = self
//        tableView.dataSource = self
//        NotificationCenter.default.addObserver(self, selector: #selector(addfriendSuccess), name: NSNotification.Name(rawValue: "sendAddFriendMesSuccess"), object: nil)
        
    }

    func addfriendSuccess()
    {
        if seachResult.isExist==true&&seachResult.phone==sendPhone
        {
            seachResult.status=1
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.seachResult.isExist==false {
            return 1
        } else {
        return 1
        }
    
        
    }
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionview=UIView(frame: CGRect(x: 0, y: 0, width: width_screen, height: 49))
//        sectionview.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
        sectionview.backgroundColor = UIColor.blue
        let sectionlabel=UILabel(frame: CGRect(x: 15, y: 24, width: 100, height: 12))
        sectionlabel.textAlignment=NSTextAlignment.left
        sectionlabel.text = loadLanguage("搜索结果" )
        sectionlabel.font=UIFont.systemFont(ofSize: 12)
        sectionlabel.textColor=UIColor(red: 135/255, green: 136/255, blue: 137/255, alpha: 1)
        sectionview.addSubview(sectionlabel)
        return sectionview
    }
//
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0&&self.seachResult.isExist==false
        {
            return 100
        }
        return 49
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.seachResult.isExist==false
        {
            return 0
        } else {
            return 1
        }
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = Bundle.main.loadNibNamed("AddFriendTableViewCell", owner: nil, options: nil)?.last as! AddFriendTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTableViewCellid",for:indexPath as IndexPath) as! AddFriendTableViewCell
        /*
        cell.AddFriendButton.addTarget(self, action: #selector(toAddFriend), for: .touchUpInside)
        // Configure the cell...
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.AddFriendButton.tag=indexPath.section+indexPath.row

            if seachResult.isExist==true
            {
                switch (seachResult.status)
                {
                case 0:
                    cell.AddFriendButton.isEnabled=true
                    cell.AddFriendButton.setTitle(loadLanguage("添加"), for: .normal)
                    break
                case 1:
                    cell.AddFriendButton.isEnabled=false
                    cell.AddFriendButton.setTitle(loadLanguage("已发送"), for: .normal)
                    cell.AddFriendButton.backgroundColor=UIColor.clear
                    cell.AddFriendButton.setTitleColor(UIColor.gray, for: .normal)
                    break
                case 2:
                    cell.AddFriendButton.isEnabled=false
                    cell.AddFriendButton.setTitle(loadLanguage("已添加"), for: .normal)
                    cell.AddFriendButton.backgroundColor=UIColor.clear
                    cell.AddFriendButton.setTitleColor(UIColor.gray, for: .normal)
                    break
                default:
                    break
                    
                }
                if seachResult.imgUrl == "" {
                    cell.headImage.image = UIImage(named: "DefaultHeadImage")
                } else {
                    cell.headImage.sd_setImage(with: URL(string:seachResult.imgUrl ))
                }
                
                cell.Name.text=seachResult.Name
            }

     */
        return cell
    }
    
    func toAddFriend(button:UIButton)
    {
        if button.tag==0
        {
            sendPhone=seachResult.phone
        }
        self.performSegue(withIdentifier: "showSendYanZH", sender: self)
    }
    
    // MARK: - Navigation

     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier=="showSendYanZH"
//        {
//            let page=segue.destinationViewController as! SendYanZHViewController
//            page.sendphone=sendPhone
//        }

    }


    //数据访问
    func SearchPhone()
    {
        tabelHeaderView.SearchTextFD.resignFirstResponder()
        let phonestr=tabelHeaderView.SearchTextFD.text!
        if phonestr==""
        {
            let alert=UIAlertView(title: "", message:loadLanguage("输入信息不能为空！"), delegate: self, cancelButtonTitle: "ok")
            alert.show()
            return
        }
        
        if MyRegex("^1[0-9]{10}$").match(input: phonestr)==false {
            
            let alert = UIAlertView(title: "", message:loadLanguage("请输入正确的手机号"), delegate: self, cancelButtonTitle: "ok")
            alert.show()
            return
            
        }
        let params:NSDictionary = ["jsonmobile":phonestr]
        
        weak var weakSelf = self
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
//        SVProgressHUD.setViewForExtension(self.view)
        SVProgressHUD.show()
        User.GetUserNickImage(params, { (responseObject) in
            SVProgressHUD.dismiss()
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            
            if isSuccess > 0 {

                let arr = responseObject.dictionary?["data"]?.array?.first
                weakSelf?.seachResult.imgUrl = (arr?["headimg"].stringValue)!
                weakSelf?.seachResult.isExist = true
                weakSelf?.seachResult.status = (arr?["Status"].intValue)!
                weakSelf?.seachResult.Name = (arr?["nickname"].stringValue)!
                weakSelf?.seachResult.phone = (arr?["mobile"].stringValue)!
                weakSelf?.tableView.reloadData()
            } else {
//                self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
            }
            
            }) { (error) in
                SVProgressHUD.dismiss()
                
                let alertView = SCLAlertView()
                _ = alertView.addButton(loadLanguage("确定"), action: {})
                _ = alertView.showError(loadLanguage("温馨提示"), subTitle:error?.localizedDescription == "" ? "加载失败" : (error?.localizedDescription)! )
        }
        
//        User.SearchFriend(params, { (responseObject) in
//            print(responseObject)
// 
//            if responseObject["userinfo"].isEmpty {
//                
//                let alert = UIAlertView(title: "", message:loadLanguage("非浩泽用户"), delegate: self, cancelButtonTitle: "ok")
//                alert.show()
//                return
//                
//            } else {
//                let dic = responseObject["userinfo"].dictionary
////                seachResult.imgUrl = dic[""]
//           
//            }
//            
//            }) { (error) in
//                print(error)
//        }
    
    }
    
    
    

 }
