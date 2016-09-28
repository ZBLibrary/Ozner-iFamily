//
//  CounselingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CounselingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initNavarionBar()
        

    }
    
    private func initNavarionBar() {
        
        self.title = "咨询"
        self.view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"CallPhoneImage"), style: UIBarButtonItemStyle.done, target: self, action: #selector(CounselingController.phoneCallAction))
        
    }
    
    func phoneCallAction() {
        
        //直接拨打
//        UIApplication.shared.openURL(URL(string: "tel:4008202667")!)
        
        let callWebView = UIWebView()
        
        callWebView.loadRequest(URLRequest(url: URL(string: "tel:4008202667")!))
        
        view.addSubview(callWebView)
        
        
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
