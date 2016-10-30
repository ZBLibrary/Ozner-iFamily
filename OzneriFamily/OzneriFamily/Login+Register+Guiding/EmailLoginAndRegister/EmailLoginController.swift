//
//  EmailLoginController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/30.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class EmailLoginController: UIViewController {

    
    @IBAction func login(_ sender: AnyObject) {
        presentMainViewController()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func presentMainViewController() {
        LoginManager.instance.currentLoginType=OznerLoginType.ByEmail
        LoginManager.instance.mainTabBarController = MainTabBarController()
        LoginManager.instance.mainTabBarController?.loadTabBar()
        LoginManager.instance.mainTabBarController?.modalTransitionStyle = .crossDissolve
        self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
    }
    
    var firstAppear = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            firstAppear = false
            
//            User.loginWithLocalUserInfo(
//                success: {
//                    [weak self] user in
//                    self?.presentMainViewController()
//                },
//                failure: {error in})
        }
        
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
