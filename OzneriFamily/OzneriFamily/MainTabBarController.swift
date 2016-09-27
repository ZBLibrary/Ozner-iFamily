//
//  MainTabBarController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadTabBar() {
        let mainViewController = UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "MyDevicesController") as! MyDevicesController
        let leftViewController = UIStoryboard(name: "LeftMenu", bundle: nil).instantiateInitialViewController() as! LeftMenuController
        
        leftViewController.mainViewController=mainViewController
        let nvc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.delegate = mainViewController
        
        slideMenuController.tabBarItem.title="我的设备"
        slideMenuController.tabBarItem.image=UIImage(named: "bar_normal_0")
        slideMenuController.tabBarItem.selectedImage=UIImage(named: "bar_select_0")
        
        
        
        let c2=WebShopController()
        c2.tabBarItem.title="商城"
        c2.tabBarItem.image=UIImage(named: "bar_normal_1")
        c2.tabBarItem.selectedImage=UIImage(named: "bar_select_1")
        
        let c3 = CounselingController()
        c3.tabBarItem.title="咨询"
        c3.tabBarItem.image=UIImage(named: "bar_normal_2")
        c3.tabBarItem.selectedImage=UIImage(named: "bar_select_2")
        
        
        let c4=UIStoryboard(name: "MyCenter", bundle: nil).instantiateInitialViewController() as!MyCenterController
        c4.tabBarItem.title="我"
        c4.tabBarItem.image=UIImage(named: "bar_normal_3")
        c4.tabBarItem.selectedImage=UIImage(named: "bar_select_3")
        let nav4=UINavigationController(rootViewController: c4)
        
        self.viewControllers=[slideMenuController,c2,c3,nav4]
        
        
    }
    // MARK: - Navigation
    
    override func viewWillLayoutSubviews() {
        let height:CGFloat = CGFloat(LoginManager.isChinese_Simplified ? height_tabBar:0)
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        self.tabBar.frame = tabFrame
        if height==0 {
            self.tabBar.isHidden=true
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
