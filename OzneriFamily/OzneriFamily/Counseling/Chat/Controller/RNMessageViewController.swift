//
//  RNMessageViewController.swift
//  OzneriFamily
//
//  Created by 婉卿容若 on 2017/6/2.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class RNMessageViewController: UIViewController {

    
    lazy var tabelView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64) , style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        return tableView
    }()
    
    lazy var dataSource: [String] = {
        
        let arr = ["客服中心", "帮助中心"]
        
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "咨询"
        view.backgroundColor = UIColor(colorLiteralRed: 239, green: 239, blue: 239, alpha: 1)
        
        setUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension RNMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
             let userDic = ["nick_name": "郑文祥", "cellphone": "18655591525", "email": "1210538084@qq.com", "description": "你猜", "sdk_token": "xxxxxxxx"]
             let params = ["user": userDic]
            UdeskManager.createCustomer(withCustomerInfo: params)
            let chatViewManager = UdeskSDKManager.init(sdkStyle: UdeskSDKStyle.default())
            chatViewManager?.pushUdeskViewController(with: UdeskType.init(1), viewController: self, completion: nil)
            
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) 
        
        if indexPath.row < dataSource.count {
            
            cell.textLabel?.text = dataSource[indexPath.row]
            cell.imageView?.image = UIImage(named: "sunnyxx")
        }
        return cell
    }
    
}


//MARK: - private methods

extension RNMessageViewController {
    
    func setUI(){
        
        view.addSubview(tabelView)
    }
    
    
}

//MARK: - event response

extension RNMessageViewController {
    
    func disMissBtn(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
}

