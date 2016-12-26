//
//  MySuggestViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit
import SVProgressHUD
class MySuggestViewController: BaseViewController,UITextViewDelegate {

    @IBOutlet var messCount: UILabel!

    @IBOutlet var MessTV: UITextView!
    @IBOutlet var TiaShiButton: UIButton!
    
    @IBAction func TiShiClick(sender: AnyObject) {
        TiaShiButton.isHidden=true
        MessTV.becomeFirstResponder()
    }
    
    @IBAction func OKClick(sender: AnyObject) {
        sendsuggest(msg: MessTV.text)
        
    }
    var counttmp=0
    @IBOutlet var OKButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        TiaShiButton.setTitle(loadLanguage("如果您在使用过程中，有任何问题或建议，请留下你宝贵的意见与建议，我们会努力解决您的问题。"), for: UIControlState.normal)
        OKButton.setTitle(loadLanguage("提交"), for: .normal)
        MessTV.delegate=self
        self.automaticallyAdjustsScrollViewInsets = false
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text=="\n" {
            //sendsuggest(MessTV.text)
            textView.resignFirstResponder()
            return false
        }
        else
        {
            counttmp=MessTV.text.characters.count
            messCount.text="\(counttmp)/300"
        }
        
        return true
    }
    func sendsuggest(msg:String)
    {
        if msg==""
        {return}
        let params:NSDictionary = ["message":msg]
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
//        SVProgressHUD.setViewForExtension(self.view)
        SVProgressHUD.show()
//        weak var weakSelf = self
        User.commitSugesstion(params, { (responseObject) in
           
            let isSuccess =  responseObject.dictionary?["state"]?.intValue ?? 0
            SVProgressHUD.dismiss()
            if isSuccess > 0{
                
               let alertView=SCLAlertView()
                _ = alertView.addButton(loadLanguage("确定"), action: {})
               _ = alertView.showSuccess(loadLanguage("温馨提示"), subTitle: loadLanguage("意见已成功提交"))
                
            } else {
                let alertView = SCLAlertView()
                _ = alertView.addButton(loadLanguage("确定"), action: {})
                _ = alertView.showError(loadLanguage("温馨提示"), subTitle: loadLanguage("意见提交失败"))
            }
            
            }) { (error) in
                SVProgressHUD.dismiss()
                let alertView = SCLAlertView()
                _ = alertView.addButton(loadLanguage("确定"), action: {})
                _ = alertView.showError(loadLanguage("温馨提示"), subTitle: loadLanguage("意见提交失败"))
            }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title=loadLanguage("我要提意见")
//        self.navigationController?.navigationBar.isHidden=false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(true, animated: false)
        //self.tabBarController?.tabBar.hidden=true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
