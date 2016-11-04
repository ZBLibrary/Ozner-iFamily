//
//  BaseWebView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

enum WeiXinUrlType:String {
    case MyMony = "我的小金库"
    case ShareLika = "我的订单"
    case CallFriend = "领红包"
    case AwardInfo = "我的券"
    case WaterReport = "查看水质检测报告"
    
}

class BaseWebView: UIViewController {

    var webViewType:String?
    
    var mobile =  User.currentUser?.phone
    var UserTalkCode = User.currentUser?.usertoken
    var Language="zh"
    var Area="zh"
    var button:UIButton!
    var tmpURL=""

    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        
    }
    
    func setUpUi() {
        
        self.title = loadLanguage(webViewType!)

        switch webViewType! {
            //我的小金库
        case loadLanguage("我的小金库"):
            tmpURL = GoUrlBefore(url: "http://www.oznerwater.com/lktnew/wapnew/Member/MyCoffers.aspx")
            //我的订单
        case loadLanguage("我的订单"):
            tmpURL = GoUrlBefore(url: "http://www.oznerwater.com/lktnew/wapnew/Orders/OrderList.aspx")
        //领红包
        case loadLanguage("领红包"):
            tmpURL = GoUrlBefore(url: "http://www.oznerwater.com/lktnew/wapnew/Member/GrapRedPackages.aspx")
            //我的券
        case loadLanguage("我的券"):
            tmpURL = GoUrlBefore(url: "http://www.oznerwater.com/lktnew/wapnew/Member/AwardList.aspx")
            //查看水质检测报告
        case loadLanguage("查看水质检测报告"):
            tmpURL = "http://erweima.ozner.net:85/index.aspx?tel="+mobile!
        default:
            break
      
        }
        
        webView = UIWebView(frame: CGRect(x: 0, y: 64, width: width_screen, height: height_screen - 64))
        view.addSubview(webView)
        webView.scalesPageToFit = true
        webView.loadRequest(URLRequest(url: URL(string: tmpURL)!))
    }

    
    func GoUrlBefore(url:String)->String
    {
        
        return "http://www.oznerwater.com/lktnew/wap/app/Oauth2.aspx?mobile=" + mobile! + "&UserTalkCode=" + UserTalkCode! + "&Language=" + Language + "&Area=" + Area + "&goUrl=" + url
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        appDelegate.mainTabBarController?.setTabBarHidden(true, animated: false)
        
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
