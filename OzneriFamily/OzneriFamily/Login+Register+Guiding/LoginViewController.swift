//
//  StarGuideViewController.swift
//  oznerproject
//
//  Created by 111 on 15/11/16.
//  Copyright © 2015年 ozner. All rights reserved.
//

import UIKit
//import OznerLibraryFramework

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var YZMTextField: UITextField!
    
    @IBOutlet var YZMbutton: UIButton!
    
    @IBOutlet var YZMTextLabel: UILabel!
    @IBAction func getYZMclick(_ sender: AnyObject) {
        weak var weakSelf=self
        User.GetPhoneCode(phone: phoneTextField.text!, success: {
            weakSelf?.errorLabel.text="获取成功，1分钟之内没收到，继续尝试"
            }) { (error) in
                weakSelf?.errorLabel.text=error.localizedDescription
        }
        
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
        weak var weakSelf=self
        User.GetVoicePhoneCode(phone: phoneTextField.text!, success: {
            weakSelf?.errorLabel.text="获取成功，1分钟之内没收到，继续尝试"
        }) { (error) in
            weakSelf?.errorLabel.text=error.localizedDescription
        }
    }
    func presentMainViewController() {
        BPush.bindChannel { (result, error) in
            User.UpdateUserInfo()
        }
        appDelegate.mainTabBarController = MainTabBarController()
        appDelegate.mainTabBarController?.loadTabBar()
        appDelegate.mainTabBarController?.modalTransitionStyle = .crossDissolve
        self.present(appDelegate.mainTabBarController!, animated: true, completion: nil)
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
                failure: {error in})
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
