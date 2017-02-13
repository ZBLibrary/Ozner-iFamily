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
        if MyRegex("^1[0-9]{10}$").match(input: phoneTextField.text!)==false {
            errorLabel.text=loadLanguage("手机号码格式不正确!")
            return
        }
        YZMbutton.isEnabled=false
        YZMTextLabel.textColor=UIColor(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)
        YZMTextLabel.backgroundColor=grayColor
        YZMTextLabel.layer.borderColorWithUIColor=grayColor
        remainTime=60
        YZMTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDown), userInfo: nil, repeats: true)
        weak var weakSelf=self
        User.GetPhoneCode(phone: phoneTextField.text!, success: {
            weakSelf?.errorLabel.text="一分钟之内没收到，继续尝试"
            }) { (error) in
                weakSelf?.errorLabel.text=error.localizedDescription
        }
        
    }
    var YZMTimer:Timer?
    var remainTime:Int=60
    func timerDown() {
        
        YZMTextLabel.text=loadLanguage("倒计时")+"\(remainTime)"+loadLanguage("秒")
        if remainTime<=0 {
            setYZMNormal()
            if (YZMTimer?.isValid)! {
                YZMTimer?.invalidate()
            }
            YZMTimer=nil
        }
        remainTime=remainTime-1
    }
    func setYZMNormal() {
        //短信验证码
        YZMTextLabel.textColor=blueColor
        YZMbutton.isEnabled=true
        YZMTextLabel.text=loadLanguage("短信验证码")
        YZMTextLabel.backgroundColor=UIColor.clear
        YZMTextLabel.layer.borderColorWithUIColor=blueColor

    }
    

    @IBOutlet var errorLabel: UILabel!
    
    
    @IBAction func loginClick(_ sender: AnyObject) {
        
        if MyRegex("^1[0-9]{10}$").match(input: phoneTextField.text!)==false {
            errorLabel.text=loadLanguage("手机号码格式不正确!")
            return
        }
        if MyRegex("^[0-9]{4}$").match(input: YZMTextField.text!)==false {
            errorLabel.text=loadLanguage("验证码格式不正确!")
            return
        }
        weak var weakSelf=self
        
        User.loginWithPhone(phone: phoneTextField.text!, phonecode: YZMTextField.text!,success:
            { (user) in
                weakSelf?.presentMainViewController()
            }, failure:
            { (error) in
                weakSelf?.errorLabel.text=error.localizedDescription
        })
        
    }

    
   
    
    @IBOutlet var getYYbutton: UIButton!
    @IBAction func getYYbuttonclick(_ sender: UIButton) {
        if MyRegex("^1[0-9]{10}$").match(input: phoneTextField.text!)==false {
            errorLabel.text=loadLanguage("手机号码格式不正确!")
            return
        }
        
        getYYbutton.isEnabled=false
        getYYbutton.backgroundColor=grayColor
        getYYbutton.layer.borderColorWithUIColor=grayColor
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setYYNormal), userInfo: nil, repeats: false)
        weak var weakSelf=self
        User.GetVoicePhoneCode(phone: phoneTextField.text!, success: {
            weakSelf?.errorLabel.text=loadLanguage("一分钟之内没收到，继续尝试")
        }) { (error) in
            weakSelf?.errorLabel.text=error.localizedDescription
        }
    }
    @objc func setYYNormal()  {
        getYYbutton.isEnabled=true
        //语音验证码
        getYYbutton.backgroundColor=UIColor.clear
        getYYbutton.layer.borderColorWithUIColor=blueColor
   
    }
    private func presentMainViewController() {
        BPush.bindChannel { (result, error) in
            User.UpdateUserInfo()
        }
        LoginManager.instance.currentLoginType=OznerLoginType.ByEmail
        LoginManager.instance.mainTabBarController = MainTabBarController()
        LoginManager.instance.mainTabBarController?.loadTabBar()
        LoginManager.instance.mainTabBarController?.modalTransitionStyle = .crossDissolve
        self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
    }

    var firstAppear = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSetView()//初始化视图
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
    //初始化视图
    let blueColor = UIColor(red: 74/255, green: 180/255, blue: 233/255, alpha: 1)
    let grayColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    private func initSetView(){
        errorLabel.text=""
        //phoneTextField.text=""
        //YZMTextField.text=""
        setYZMNormal()
        setYYNormal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YZMTextField.placeholder=loadLanguage("输入验证码")
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
