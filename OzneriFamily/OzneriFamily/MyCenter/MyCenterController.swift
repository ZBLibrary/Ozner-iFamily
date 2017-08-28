//
//  MyCenterController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SDWebImage

class MyCenterController: BaseViewController {

    var tableView: UITableView!
    
    var headView: MyInfoHeadView!

    var dataArr: NSMutableArray?
    
    var webViewType:String?
    lazy var shareView:ShareMoneyToWeChat = {
        let tmpView=Bundle.main.loadNibNamed("ShareMoneyToWeChat", owner: self, options: nil)?.last as! ShareMoneyToWeChat
        tmpView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        tmpView.backgroundColor=UIColor.black.withAlphaComponent(0.3)
        return tmpView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setData()
        
    }
    
    func setupUI() {
        
        let infoHeadView = UINib.init(nibName: "MyInfoHeadView", bundle: nil).instantiate(withOwner: self, options: nil).first as! MyInfoHeadView
        
        infoHeadView.frame = CGRect(x: 0, y: 0, width: width_screen, height: (height_screen  - 64) * (3.3/7))
        
        //
        if LoginManager.instance.currentLoginType == .ByPhoneNumber {
            infoHeadView.hideView.isHidden = true
            var frame = infoHeadView.hideView.frame
            frame.size.height = 0
            infoHeadView.hideView.frame = frame
        }
        
        infoHeadView.iconImage.layer.cornerRadius = 37.5
        infoHeadView.iconImage.layer.masksToBounds = true
        
        infoHeadView.myDeviceNumBtn.addTarget(self, action: #selector(MyCenterController.myDeviceNumBtnAction), for: UIControlEvents.touchUpInside)
        
        infoHeadView.myMoneyBtn.addTarget(self, action: #selector(MyCenterController.myMoneyBtnAction), for: UIControlEvents.touchUpInside)
        
        if User.currentUser?.headimage == "" || User.currentUser?.headimage == nil {
            infoHeadView.iconImage.image = UIImage(named:"My_Unlogin_head")
        } else {
        infoHeadView.iconImage.sd_setImage(with: URL(string: (User.currentUser?.headimage)!))
        }
        //TODO: -
        infoHeadView.nameLb.text = User.currentUser?.username == "" ? (User.currentUser?.phone) ?? "Ozner" : (User.currentUser?.username) ?? "Ozner"
        //会员等级
        if User.currentUser?.gradename == "" {
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
        webViewType = loadLanguage("我的小金库")
        self.performSegue(withIdentifier: "MyInfoSegueId", sender: nil)
        
    }
    
    func setData() {
        switch LoginManager.instance.currentLoginType! {
        case .ByEmail:
            
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
            
        case .ByPhoneNumber:
            dataArr = NSMutableArray(capacity: 3)
            let one = MyInfoStrcut.init(imageName: "My_share", nameLb: loadLanguage("我的设备"))
            let six = MyInfoStrcut.init(imageName: "My_suggest", nameLb: loadLanguage("我要提意见"))
            let seven = MyInfoStrcut.init(imageName: "My_set", nameLb: loadLanguage("设置"))
            dataArr!.add(one)
            dataArr!.add(six)
            dataArr!.add(seven)
            headView.nameLb.text = User.currentUser?.phone
        }
     
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)

        switch LoginManager.instance.currentLoginType! {
        case .ByEmail:
            navigationController?.setNavigationBarHidden(true, animated: animated)
        case .ByPhoneNumber:
            navigationController?.navigationBar.isHidden = false
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"fanhui"), style: UIBarButtonItemStyle.done, target: self, action: #selector(MyCenterController.backAction))
        }
        
        let devices=OznerManager.instance.getAllDevices()
        headView.infoNumLb.text="\(Int((devices?.count)!))"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: animated)
    }
    override func backAction() {
        LoginManager.instance.setTabbarSelected(index: 0)
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
        
        switch LoginManager.instance.currentLoginType! {
        case .ByEmail:
            return 7
        case .ByPhoneNumber:
            return 3
        }
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
        case loadLanguage("我的订单"),loadLanguage("我的券"),loadLanguage("查看水质检测报告"):
            self.performSegue(withIdentifier: "MyInfoSegueId", sender: nil)
            
        case loadLanguage("领红包"):
            appDelegate.window?.addSubview(shareView)
           
        case loadLanguage("设置"):
            self.performSegue(withIdentifier: "settingSegueID", sender: nil)
            
        case  loadLanguage("我要提意见"):
            self.performSegue(withIdentifier: "sugesstsegueID", sender: nil)
        case loadLanguage("我的好友"):
            self.performSegue(withIdentifier: "MyFriendSegueID", sender: nil)
        case loadLanguage("我的设备"):
            self.performSegue(withIdentifier: "equidDeviceNumberID", sender: nil)
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch LoginManager.instance.currentLoginType! {
        case .ByEmail:
            return (height_screen - 64) * (3.7/7) / 7
        case .ByPhoneNumber:
            return 50
        }
        
    }
    
}

extension MyCenterController {
    
    struct MyInfoStrcut {
        let imageName:String
        let nameLb:String
        
    }
    
}
