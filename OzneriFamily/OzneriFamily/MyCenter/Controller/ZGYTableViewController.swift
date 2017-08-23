//
//  ZGYTableViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/11/3.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

import SDWebImage
import SVProgressHUD

//添加好友
//struct myFriend {
//    var isExist=false
//    var Name=""
//    var imgUrl=""
//    var status = -10014  //－10014不是浩泽用户 0没关系 1"已发送" 2"已添加"
//    var phone=""
//    var messageCount=0
//}

class ZGYTableViewController: UITableViewController ,UITextFieldDelegate{

    var sendPhone=""
    var seachResult=myFriend()
    var bookPhone:[myFriend] = []
    //NSMutableArray
    var tabelHeaderView:FriendSearch!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title=loadLanguage("添加好友")
        
        let backBtn = UIButton()
        
        backBtn.setImage(UIImage(named: "backBg"), for: UIControlState.normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        backBtn.addTarget(self, action: #selector(BaseViewController.backAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView.rowHeight = 44
        tableView.register(UINib.init(nibName: "AddFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "AddFriendTableViewCellid")
        tabelHeaderView = Bundle.main.loadNibNamed("FriendSearch", owner: self, options: nil)?.last as! FriendSearch
        tabelHeaderView.searchButton.addTarget(self, action: #selector(SearchPhone), for: .touchUpInside)
        tabelHeaderView.SearchTextFD.delegate=self
        self.tableView.tableHeaderView=tabelHeaderView
        self.tableView.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(addfriendSuccess), name: NSNotification.Name(rawValue: "sendAddFriendMesSuccess"), object: nil)
        Tongxunlu()
    }
    
    func backAction() {
        
        _=self.navigationController?.popViewController(animated: true)
        
    }
    
    func Tongxunlu()
    {
        let gyConact = GYConactBook()
        
        
        let friends:String=gyConact.getAllPerson()!
        
        getTXFriends(TXLfriends: friends)
        
    }

    func getTXFriends(TXLfriends:String){
        if TXLfriends==""
        {
            return
        }
        let str = TXLfriends.replacingOccurrences(of: "<null>", with: "")
        let params:NSDictionary = ["jsonmobile":str]
        
        weak var weakSelf = self
        
        LoginManager.instance.showHud()
        User.GetUserNickImage(params, { (responseObject) in
            SVProgressHUD.dismiss()
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            print(responseObject)
            //-10013
            if isSuccess > 0 {
                self.bookPhone.removeAll()
                let arr = responseObject.dictionary?["data"]?.array
                
                for i in 0...(arr!.count - 1) {
                    
                    var friendtmp=myFriend()
                    friendtmp.isExist=true
                    friendtmp.status=(arr?[i].dictionary?["Status"]?.intValue)!
                    if (friendtmp.status+10013)<=0
                    {
                        continue
                    }
                    
                    if (arr?[i].dictionary?["headimg"]?.stringValue != nil) {
                        friendtmp.imgUrl = (arr?[i].dictionary?["headimg"]?.stringValue)!
                    } else {
                        friendtmp.imgUrl = ""
                    }
                    
                    
                    friendtmp.Name=(arr?[i].dictionary?["nickname"]?.stringValue)!
                    friendtmp.phone=(arr?[i].dictionary?["mobile"]?.stringValue)!
                    
                    friendtmp.Name=friendtmp.Name.characters.count==0 ? friendtmp.phone: friendtmp.Name
                    
                    self.bookPhone.append(friendtmp)
                }

                weakSelf?.tableView.reloadData()
            } else {
                
            }
            }) { (error) in
            SVProgressHUD.dismiss()
            
            
            let alertView = SCLAlertView()
            _ = alertView.addButton(loadLanguage("确定"), action: {})
            _ = alertView.showError(loadLanguage("温馨提示"), subTitle:(error?.localizedDescription)!)
            
        }

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

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 2

    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionview=UIView(frame: CGRect(x: 0, y: 0, width: width_screen, height: 49))
        sectionview.backgroundColor=UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
        let sectionlabel=UILabel(frame: CGRect(x: 15, y: 24, width: 100, height: 12))
        sectionlabel.textAlignment=NSTextAlignment.left
        sectionlabel.text=section==0 ? loadLanguage("搜索结果" ):loadLanguage("通讯录好友")
        sectionlabel.font=UIFont.systemFont(ofSize: 12)
        sectionlabel.textColor=UIColor(red: 135/255, green: 136/255, blue: 137/255, alpha: 1)
        sectionview.addSubview(sectionlabel)
        return sectionview
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0&&self.seachResult.isExist==false
        {
            return 0
        }
        return 49
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0&&self.seachResult.isExist==false
        {
            return 0
        }
        if section==0
        {
            return 1
        }
        else
        {
            return bookPhone.count - 1//通讯录好友数量
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTableViewCellid",for:indexPath as IndexPath) as! AddFriendTableViewCell
        
        cell.AddFriendButton.addTarget(self, action: #selector(toAddFriend(_:)), for: .touchUpInside)
        // Configure the cell...
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.AddFriendButton.tag=indexPath.section+indexPath.row
        if indexPath.section == 0{
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
        } else {
//            if bookPhone[indexPath.row] {
//                
//            }
            switch (bookPhone[indexPath.row].status)
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
            
            cell.headImage.image=bookPhone[indexPath.row].imgUrl=="" ? UIImage(named: "DefaultHeadImage") : UIImage(data: NSData(contentsOf: NSURL(string: bookPhone[indexPath.row].imgUrl)! as URL)! as Data)
            cell.Name.text=bookPhone[indexPath.row].Name
            
        }

        return cell

    }
    
    func toAddFriend(_ button:UIButton)
    {
        if button.tag==0
        {
            sendPhone=seachResult.phone
        } else{
            sendPhone=bookPhone[button.tag - 1].phone
        }
        print(sendPhone)
        self.performSegue(withIdentifier: "toAddFriendGYID", sender: nil)
    }
    
    // MARK: - Navigation
    
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
       
        if  MyRegex("^1[0-9]{10}$").match(input: phonestr)==false {
            
            let alert = UIAlertView(title: "", message:loadLanguage("请输入正确的手机号"), delegate: self, cancelButtonTitle: "ok")
            alert.show()
            return
            
        }
        let params:NSDictionary = ["jsonmobile":phonestr]
        
        weak var weakSelf = self
        
        LoginManager.instance.showHud()
        User.GetUserNickImage(params, { (responseObject) in
            SVProgressHUD.dismiss()
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            print(responseObject)
            //-10013
            if isSuccess > 0 {
                
                let arr = responseObject.dictionary?["data"]?.array?.first
                
                if arr?["Status"].intValue == -10013 {
                    
                    let alertView=SCLAlertView()
                    _ = alertView.addButton(loadLanguage("确定"), action: {})
                    _ = alertView.showSuccess(loadLanguage("温馨提示"), subTitle: loadLanguage("非浩泽用户!"))
                    return
                    
                }
                
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
            _ = alertView.showError(loadLanguage("温馨提示"), subTitle:(error?.localizedDescription)!)

        }

        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toAddFriendGYID"
        {
            let page=segue.destination as! SendYanZHViewController
            page.sendphone=sendPhone
        }
    }
 

}
