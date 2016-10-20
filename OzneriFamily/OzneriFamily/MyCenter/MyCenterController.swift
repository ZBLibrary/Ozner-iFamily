//
//  MyCenterController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit


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
        
        headView = infoHeadView
        
        tableView = UITableView(frame: CGRect(x: 0, y: -20, width: width_screen, height: (height_screen + 20 )))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headView
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "MyInfoCell", bundle: nil), forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
    }
    
    func setData() {
        dataArr = NSMutableArray(capacity: 7)
        
        let one = MyInfoStrcut.init(imageName: "My_share", nameLb: "我的订单")
        let two = MyInfoStrcut.init(imageName: "My_huiyuan", nameLb: "领红包")
        let three = MyInfoStrcut.init(imageName: "My_zhongjiang", nameLb: "我的券")
        let four = MyInfoStrcut.init(imageName: "My_friends", nameLb: "我的好友")
        let five = MyInfoStrcut.init(imageName: "My_baogao", nameLb: "查看水质检测报告")
        let six = MyInfoStrcut.init(imageName: "My_suggest", nameLb: "我要提意见")
        let seven = MyInfoStrcut.init(imageName: "My_set", nameLb: "设置")
        
        
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
            self.performSegue(withIdentifier: "sugesstsegueID", sender: nil)
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
