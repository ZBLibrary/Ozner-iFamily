//
//  WebShopController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WebShopController: UIViewController {

    var urlstr:String!
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        urlstr=NetworkManager.defaultManager?.UrlNameWithRoot("WebStore")

        webView = UIWebView(frame: self.view.bounds)
        
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string:urlstr!)!))
         self.view.addSubview(webView)
        webView.addSubview(btn)
        btn.addTarget(self, action: #selector(WebShopController.loadAgin), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
    }
    
    
    lazy var btn: UIButton = {
       
        let btn1 = UIButton(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen - 100))
        btn1.setTitle("加载失败点击继续加载！", for: UIControlState.normal)
        btn1.setTitleColor(UIColor.black, for: UIControlState.normal)
        return btn1
    }()
    
    func loadAgin() {
        
        webView.loadRequest(URLRequest(url: URL(string:urlstr!)!))

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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

extension WebShopController: UIWebViewDelegate {
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        
//        SVProgressHUD.show()
//        return true
//    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        btn.isHidden = true
//        SVProgressHUD.show()

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        btn.isHidden = true
//        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        btn.isHidden = false
//        SVProgressHUD.dismiss()
        
        
        
    }

    
}
