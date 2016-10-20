//
//  MySetViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MySetViewController: UIViewController {


    @IBOutlet weak var pushSwitch: UISwitch!
    //退出登录
    @IBAction func logOutAction(_ sender: AnyObject) {
        
        appDelegate.LoginOut()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loadLanguage("设置")
        
        
    }
    
    //通知开关
    @IBAction func pushControllerAction(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            print("打开通知")
        case false:
            print("关闭通知")

        }
        
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        appDelegate.mainTabBarController?.setTabBarHidden(true, animated: false)

    }
    
  
}
