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
        let c1=UIStoryboard(name: "MyDevices", bundle: nil).instantiateInitialViewController() as! MyDevicesController
        c1.tabBarItem.title="我的设备"
        c1.tabBarItem.image=UIImage(named: "bar_normal_0")
        c1.tabBarItem.selectedImage=UIImage(named: "bar_select_0")
        let nav1=UINavigationController(rootViewController: c1)
        
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
        
        self.viewControllers=[nav1,c2,c3,nav4]
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
