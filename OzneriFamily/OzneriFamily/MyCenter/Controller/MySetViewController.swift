//
//  MySetViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class MySetViewController: BaseViewController {


    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var aboutOzne: UILabel!
    @IBOutlet weak var calcuteNum: UILabel!
    @IBOutlet weak var pushLb: UILabel!
    @IBOutlet weak var pushSwitch: UISwitch!
    //退出登录
    @IBAction func logOutAction(_ sender: AnyObject) {
        
        LoginManager.instance.LoginOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loadLanguage("设置")
        pushLb.text = loadLanguage("允许推送消息")
        calcuteNum.text = loadLanguage("计量单位")
        aboutOzne.text = loadLanguage("关于浩泽伊泉净品")
        logout.setTitle(loadLanguage("退出登录"), for: UIControlState.normal)
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
       
        LoginManager.instance.mainTabBarController?.setTabBarHidden(true, animated: false)
    }
    
  
}
