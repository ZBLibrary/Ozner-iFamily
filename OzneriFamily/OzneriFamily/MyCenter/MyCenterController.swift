//
//  MyCenterController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import WebImage

class MyCenterController: UIViewController {

    var tableView: UITableView!
    
    var headView: UIView!
    
    var dataArr: NSMutableArray?
    
    var webViewType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        
        setData()
        
    }
    
    func setupUI() {
        
        
        let infoHeadView = UINib.init(nibName: "MyInfoHeadView", bundle: nil).instantiate(withOwner: self, options: nil).first as! MyInfoHeadView
        
        infoHeadView.frame = CGRect(x: 0, y: 0, width: width_screen, height: (height_screen  - 64) * (3.3/7))
        
        infoHeadView.iconImage.layer.cornerRadius = 37.5
        infoHeadView.iconImage.layer.masksToBounds = true
        
        infoHeadView.myDeviceNumBtn.addTarget(self, action: #selector(MyCenterController.myDeviceNumBtnAction), for: UIControlEvents.touchUpInside)
        
        infoHeadView.myMoneyBtn.addTarget(self, action: #selector(MyCenterController.myMoneyBtnAction), for: UIControlEvents.touchUpInside)
        
        if User.currentUser?.headimage == "" || User.currentUser?.headimage == nil {
            
        } else {
        infoHeadView.iconImage.sd_setImage(with: URL(string: (User.currentUser?.headimage)!))
        }
        infoHeadView.nameLb.text = (User.currentUser?.username)! == "" ? (User.currentUser?.phone)! : (User.currentUser?.username)!
        //会员等级
        if (User.currentUser?.gradename)! == "" {
            infoHeadView.leaveLb.text = ""
        } else {
            let leaveStr = User.currentUser?.gradename?.replacingOccurrences(of: "会员", with: "代理会员")
            infoHeadView.leaveLb.text = leaveStr
            
        }
        infoHeadView.moneyLb.text = User.currentUser?.score
        headView = infoHeadView
        
        tableView = UITableView(frame: CGRect(x: 0, y: -20, width: width_screen, height: (height_screen + 20 )))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headView
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "MyInfoCell", bundle: nil), forCellReuseIdentifier: "cellID")
        
        view.addSubview(tableView)
        
    }
    
    func myDeviceNumBtnAction() {
        
        self.performSegue(withIdentifier: "equidDeviceNumberID", sender: nil)
    }
    
    func myMoneyBtnAction() {
        webViewType = "我的小金库"
        self.performSegue(withIdentifier: "MyInfoSegueId", sender: nil)
        
    }
    
    func setData() {
        dataArr = NSMutableArray(capacity: 7)
        
        let one = MyInfoStrcut.init(imageName: "My_share", nameLb: loadLanguage("我的订单"))
        let two = MyInfoStrcut.init(imageName: "My_huiyuan", nameLb: loadLanguage("领红包"))
        let three = MyInfoStrcut.init(imageName: "My_zhongjiang", nameLb: loadLanguage("我的券"))
        let four = MyInfoStrcut.init(imageName: "My_friends", nameLb: loadLanguage("我的好友"))
        let five = MyInfoStrcut.init(imageName: "My_baogao", nameLb: loadLanguage("查看水质检测报告"))
        let six = MyInfoStrcut.init(imageName: "My_suggest", nameLb: loadLanguage("我要提意见"))
        let seven = MyInfoStrcut.init(imageName: "My_set", nameLb: loadLanguage("设置"))
        
        
        dataArr!.add(one)
        dataArr!.add(two)
        dataArr!.add(three)
        dataArr!.add(four)
        dataArr!.add(five)
        dataArr!.add(six)
        dataArr!.add(seven)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.mainTabBarController?.setTabBarHidden(false, animated: false)

        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "MyInfoSegueId" {
            let pair = segue.destination as! BaseWebView
            
            pair.webViewType = self.webViewType!
        }
        
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension MyCenterController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! MyInfoCell
        
        cell.selectionStyle = .none
        cell.reloadUI(infoStruct: dataArr![indexPath.row] as! MyCenterController.MyInfoStrcut)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr?[indexPath.row] as! MyInfoStrcut
        
        webViewType = model.nameLb
        
        
        switch webViewType! {
        case "我的订单","领红包","我的券","查看水质检测报告":
            self.performSegue(withIdentifier: "MyInfoSegueId", sender: nil)
            break
        case "设置":
            self.performSegue(withIdentifier: "settingSegueID", sender: nil)
            break
        case "我要提意见":
            self.performSegue(withIdentifier: "sugesstsegueID", sender: nil)
        case "我的好友":
            self.performSegue(withIdentifier: "MyFriendSegueID", sender: nil)
        default:
            break
        }

       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (height_screen - 64) * (3.7/7) / 7
    }
    
}

extension MyCenterController {
    
    struct MyInfoStrcut {
        let imageName:String
        let nameLb:String
        
    }
    
}
