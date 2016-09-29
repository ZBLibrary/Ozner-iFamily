//
//  StarGuideViewController.swift
//  oznerproject
//
//  Created by 111 on 15/11/16.
//  Copyright © 2015年 ozner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var YZMTextField: UITextField!
    
    @IBOutlet var YZMbutton: UIButton!
    
    @IBOutlet var YZMTextLabel: UILabel!
    @IBAction func getYZMclick(_ sender: AnyObject) {
        
    }

    

    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func loginClick(_ sender: AnyObject) {

        weak var weakSelf=self
        User.loginWithPhone(phone: phoneTextField.text!, phonecode: YZMTextField.text!,success:
            { (user) in
                weakSelf?.presentMainViewController()
            }, failure:
            { (error) in
                weakSelf?.errorLabel.text=error.localizedDescription
        })
    }

    @IBOutlet var agreeImageView: UIButton!
    @IBOutlet var agreeButton: UIButton!
    @IBAction func agreeButtonClick(_ sender: AnyObject) {

    }
    
    @IBAction func agreeTextClick(_ sender: UIButton) {

    }
    
    @IBOutlet var TishiLabel: UILabel!
    @IBOutlet var getYYbutton: UIButton!
    @IBAction func getYYbuttonclick(_ sender: UIButton) {
        
    }
    func presentMainViewController() {
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //User.GetCurrentUserInfo({ [weak self](user) in
           // MBProgressHUD.hideHUDForView(self!.view, animated: true)
            //User.currentUser=user
            appDelegate.mainTabBarController = MainTabBarController()
            appDelegate.mainTabBarController?.modalTransitionStyle = .crossDissolve
            self.present(appDelegate.mainTabBarController!, animated: true, completion: nil)
//        }) { [weak self](error) in
//            MBProgressHUD.hideHUDForView(self!.view, animated: true)
//            let alertView=SCLAlertView()
//            alertView.addButton("ok", action: {})
//            alertView.showError("错误提示", subTitle: error.localizedDescription)
//        }
    }

    var firstAppear = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            firstAppear = false
            User.loginWithLocalUserInfo(
                success: {
                    [weak self] user in
                    self?.presentMainViewController()
                },
                failure: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
       loginButton.setTitle(loadLanguage("登录"), for: UIControlState())
        getYYbutton.setTitle(loadLanguage("获取语音验证码"), for: UIControlState())
        agreeButton.setTitle(loadLanguage("我已阅读并同意《浩泽净水家免责条款》"), for: UIControlState())
        phoneTextField.placeholder=loadLanguage("请输入手机号")
        YZMTextField.placeholder=loadLanguage("输入验证码")
        TishiLabel.text=loadLanguage("未收到短信验证码？")
        //set_islogin(false)
        
        //YZMbutton.layer.borderColor=color_main.cgColor
        //getYYbutton.layer.borderColor=color_main.cgColor
        errorLabel.text=""
        phoneTextField.delegate=self
        YZMTextField.delegate=self
       

 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text=""
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
