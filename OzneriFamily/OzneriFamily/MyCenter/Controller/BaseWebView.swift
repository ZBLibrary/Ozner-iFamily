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
            tmpURL = (NetworkManager.defaultManager?.UrlNameWithRoot("MyCoffers"))!
            
            //我的订单
        case loadLanguage("我的订单"):
            tmpURL = (NetworkManager.defaultManager?.UrlNameWithRoot("OrderList"))!//GoUrlBefore(url: "http://www.oznerwater.com/lktnew/wapnew/Orders/OrderList.aspx")
            //我的券
        case loadLanguage("我的券"):
            tmpURL = (NetworkManager.defaultManager?.UrlNameWithRoot("AwardList"))!
            //查看水质检测报告
        case loadLanguage("查看水质检测报告"):
            tmpURL = "http://erweima.ozner.net:85/index.aspx?tel="+(User.currentUser?.phone!)!
        default:
            break
      
        }
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen - 64))
        view.addSubview(webView)
        webView.scalesPageToFit = true
        webView.loadRequest(URLRequest(url: URL(string: tmpURL)!))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
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
