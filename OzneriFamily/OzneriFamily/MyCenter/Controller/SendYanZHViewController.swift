//
//  SendYanZHViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class SendYanZHViewController: BaseViewController,UITextFieldDelegate {

    var sendphone=""
    @IBAction func CancelClick(sender: AnyObject) {
        _=navigationController?.popViewController(animated: true)
    }
    @IBAction func SendClick(sender: AnyObject) {
        SendMess(messstring: MessTF.text!)
        
    }
    @IBOutlet var MessTF: UITextField!
    
    @IBOutlet weak var left: UIBarButtonItem!
    @IBOutlet weak var right: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessTF.delegate=self
        MessTF.becomeFirstResponder()
        
//        left.title = loadLanguage("取消")
        right.title = loadLanguage("发送")
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        SendMess(messstring: textField.text!)
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func SendMess(messstring:String)
    {

        let params:NSDictionary = ["content":messstring,"mobile":sendphone]
        
        LoginManager.instance.showHud()
        User.AddFriend(params, { (data) in
            print(data)
            SVProgressHUD.dismiss()
            if (data.dictionary?["state"]?.intValue)! > 0 {
                
                let alert = SCLAlertView()
                _ = alert.addButton(loadLanguage("确定"), action: {
                   _=self.navigationController?.popViewController(animated: true)
                })
                _ = alert.showSuccess(loadLanguage( "温馨提示"), subTitle:loadLanguage("发送好友请求成功"))
                
            }
            
            }) { (error) in
                SVProgressHUD.dismiss()
                let alert = SCLAlertView()
                _ = alert.addButton(loadLanguage("确定"), action: {
                    _=self.navigationController?.popViewController(animated: true)
                })
                _ = alert.showSuccess(loadLanguage( "温馨提示"), subTitle:loadLanguage("请求失败"))
                
                
        }
    }
}
 
