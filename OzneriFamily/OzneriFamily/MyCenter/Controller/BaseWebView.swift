//
//  BaseWebView.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class BaseWebView: UIViewController {

    var webViewType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        
    }
    
    func setUpUi() {
        
        self.title = webViewType

        
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
