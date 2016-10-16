//
//  MainTabBarController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/22.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MainTabBarController: RDVTabBarController {

    func loadTabBar() {
        OznerManager.instance().setOwner(User.currentUser?.phone ?? User.currentUser?.email)
        
        let c1 = UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "MyDevicesController") as! MyDevicesController
        
        
        let leftViewController = UIStoryboard(name: "LeftMenu", bundle: nil).instantiateInitialViewController() as! LeftMenuController 
        
        
        let nvc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateInitialViewController() as! UINavigationController
        leftViewController.mainViewController=nvc
        SlideMenuOptions.leftViewWidth=298*width_screen/375
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = c1
        
        let c2=WebShopController()
      
        let nav3 = UINavigationController(rootViewController: CounselingController())
        
        let c4=UIStoryboard(name: "MyCenter", bundle: nil).instantiateInitialViewController() as!MyCenterController
        let nav4=UINavigationController(rootViewController: c4)
        
        self.viewControllers=[slideMenuController,c2,nav3,nav4]
        //设置tabbar
        
        self.tabBar.isTranslucent=false
        self.tabBar.backgroundColor=UIColor.white
        var index=0
        for item in (self.tabBar.items as! [RDVTabBarItem]){
            item.title=["我的设备","商城","咨询","我"][index]
            item.setBackgroundSelectedImage(UIImage(named: "bg_TabBar"), withUnselectedImage: UIImage(named: "bg_TabBar"))
            item.setFinishedSelectedImage(UIImage(named: "bar_select_\(index)"), withFinishedUnselectedImage: UIImage(named: "bar_normal_\(index)"))
            index+=1
        }
        CustomTabBarIsHidden = !LoginManager.isChinese_Simplified
        setTabBarHidden(CustomTabBarIsHidden, animated: false)
    }
    private var CustomTabBarIsHidden:Bool!//系统tabbar是不是隐藏的
    override func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        super.setTabBarHidden(CustomTabBarIsHidden||hidden, animated:animated)
    }
    

}
