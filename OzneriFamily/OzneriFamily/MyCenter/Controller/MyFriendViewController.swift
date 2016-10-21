//
//  MyFriendViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyFriendViewController: UIViewController {

    var centerView: MyFriendCenterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpUI()

    }

    
    
    
    func setUpUI() {
        
        let left1 = UIBarButtonItem(image: UIImage(named: "AddFriend"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyFriendViewController.addFriendAction))
//        let left2 = UIBarButtonItem(image: UIImage(named: "tongzhi"), style: UIBarButtonItemStyle.done, target: self, action: #selector(MyFriendViewController.emalisAction))
        let rightBtn2 = UIButton()
        rightBtn2.frame = CGRect(x:-10, y: 0, width: 40, height: 40)
        rightBtn2.setImage(UIImage(named: "tongzhi"), for: UIControlState.normal)
        rightBtn2.addTarget(self, action: #selector(MyFriendViewController.emalisAction), for: UIControlEvents.touchUpInside)
        let rightBar2 = UIBarButtonItem(customView: rightBtn2)
        self.navigationItem.setRightBarButtonItems([left1,rightBar2], animated: true)
        
        //中间
        centerView = UINib.init(nibName: "MyFriendCenterView", bundle: nil).instantiate(withOwner: nil, options: nil).last as! MyFriendCenterView
        centerView.backgroundColor = UIColor.red
        centerView.frame = CGRect(x: 0, y: 0, width: width_screen, height: 40)
        self.navigationItem.titleView = centerView
        
        
    }
    
    func addFriendAction() {
        
    }
    
    func emalisAction() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
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
