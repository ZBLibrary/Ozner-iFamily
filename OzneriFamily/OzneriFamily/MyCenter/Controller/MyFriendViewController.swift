//
//  MyFriendViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyFriendViewController: UIViewController ,UIScrollViewDelegate{

    var centerView: MyFriendCenterView!
    
    var scrollerView:UIScrollView!
    
    var leftViewController: MyRankViewController!
    var rightViewController: MyFriendsVC!
    
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
        centerView.backgroundColor = UIColor.clear
        centerView.frame = CGRect(x: 0, y: 0, width: width_screen, height: 40)
        centerView.myRank.addTarget(self, action: #selector(MyFriendViewController.myRankAction), for: UIControlEvents.touchUpInside)
        centerView.myFriend.addTarget(self, action: #selector(MyFriendViewController.myFriendAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = centerView
        
        scrollerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen))
        
        scrollerView.delegate = self
        scrollerView.isPagingEnabled = true
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.bounces = false
        scrollerView.contentSize = CGSize(width: width_screen * 2, height: 0)
        
        self.view.addSubview(scrollerView)
        
        leftViewController = MyRankViewController()
        leftViewController.view.frame = CGRect(x: 0, y: 0, width: scrollerView.frame.size.width, height: scrollerView.frame.size.height)
        rightViewController = MyFriendsVC()
        rightViewController.view.frame = CGRect(x: scrollerView.frame.size.width, y: 0, width:scrollerView.frame.size.width , height: scrollerView.frame.size.height)
        self.addChildViewController(leftViewController)
        self.addChildViewController(rightViewController)
        
        scrollerView.addSubview(leftViewController.view)
        scrollerView.addSubview(rightViewController.view)
        
    }
    
    func myRankAction() -> Void {
        centerView.myRank.isSelected = true
        centerView.bootomView.isHidden = false
        centerView.myFriend.isSelected = false
        centerView.bootomView2.isHidden = true
        scrollerView.contentOffset = CGPoint(x: 0, y: -height_navBar)
    }
    
    func myFriendAction() -> Void {
        centerView.myRank.isSelected = false
        centerView.bootomView.isHidden = true
        centerView.myFriend.isSelected = true
        centerView.bootomView2.isHidden = false
        scrollerView.contentOffset = CGPoint(x: width_screen, y: -height_navBar)
    }
    

    
    func addFriendAction() {
        self.performSegue(withIdentifier: "addFriendSeguerID", sender: nil)
    }
    
    func emalisAction() {
        
    }
    
    //MARK: -scrollerViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btnSeleted: Int = Int(scrollerView.contentOffset.x / width_screen)
        
        switch btnSeleted {
        case 0:
            centerView.myRank.isSelected = true
            centerView.bootomView.isHidden = false
            centerView.myFriend.isSelected = false
            centerView.bootomView2.isHidden = true
        case 1:
            centerView.myRank.isSelected = false
            centerView.bootomView.isHidden = true
            centerView.myFriend.isSelected = true
            centerView.bootomView2.isHidden = false
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        appDelegate.mainTabBarController?.setTabBarHidden(true, animated: false)
        
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
