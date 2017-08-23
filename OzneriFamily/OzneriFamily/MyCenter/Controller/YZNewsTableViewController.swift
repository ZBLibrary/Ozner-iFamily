//
//  YZNewsTableViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/24.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SVProgressHUD


enum VailedStated {
    case Refused
    case Agree
    case Wait
}

class  YZNewsModel:NSObject {
    
    var vialID:String?
    var iconImage:String?
    var nickName:String?
    var vivalMessage:String?
    var vivalState:VailedStated?
    
}

class YZNewsTableViewController: BaseViewController {

    
    var tableView: UITableView?
    
    var dataArr:[YZNewsModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        initData()
        
        
    }
    
    func initData() {
        
        weak var weakSelf = self
       LoginManager.instance.showHud()
        User.GetUserVerifMessage({ (responseObject) in
            SVProgressHUD.dismiss()
            print(responseObject)
            
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            
            if isSuccess > 0 {
                let arr = responseObject.dictionary?["msglist"]?.array
                
                for item in arr! {
                    
                    let model = YZNewsModel()
                    model.vialID = item["ID"].stringValue
                    model.iconImage = item["Icon"].stringValue
                    model.nickName = item["Nickname"].stringValue
                    model.vivalMessage = item["RequestContent"].stringValue
                    switch item["Status"].intValue {
                        case 0:
                            //添加
                            model.vivalState = VailedStated.Wait
                        case 1:
                            //已发送
                            model.vivalState = VailedStated.Refused
                        case 2:
                            model.vivalState = VailedStated.Agree
                        default:
                            model.vivalState = VailedStated.Wait
                            break
                    }
                    weakSelf?.dataArr?.append(model)
                 
                }
                   weakSelf?.tableView?.reloadData()
            }
            
            }) { (error) in
                SVProgressHUD.dismiss()
                
                let alertView = SCLAlertView()
                _ = alertView.addButton(loadLanguage("确定"), action: {})
                _ = alertView.showError(loadLanguage("温馨提示"), subTitle:error?.localizedDescription == "" ? "加载失败" : (error?.localizedDescription)! )
        }
        
    }
    
    func setUpUI() {
        tableView = UITableView(frame: self.view.bounds)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.separatorStyle = .none
        tableView?.register(UINib.init(nibName: "YanZhengCell", bundle: nil), forCellReuseIdentifier: "YanZhengCellID")
        
        view.addSubview(tableView!)

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

extension YZNewsTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YanZhengCellID", for: indexPath) as! YanZhengCell
        
        cell.selectionStyle = .none
        let model = (dataArr?[indexPath.row])! as YZNewsModel
        
        cell.reloadUI(model: model)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 102
    }
    
}
