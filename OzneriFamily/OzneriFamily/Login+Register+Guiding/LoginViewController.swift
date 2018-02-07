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
        
        let str = loadLanguage("倒计时")+"\(remainTime)"+loadLanguage("秒")
        
        YZMTextLabel.text=str
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
        
        phoneTextField.text = (phoneTextField.text)!.replacingOccurrences(of: " ", with: "")
        
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
                
                UserDefaults.standard.setValue(weakSelf?.phoneTextField.text!, forKey: "LoginPhone")
                UserDefaults.standard.setValue(weakSelf?.YZMTextField.text!, forKey: "LoginCode")
                UserDefaults.standard.synchronize()
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
        LoginManager.instance.currentLoginType=OznerLoginType.ByPhoneNumber
        LoginManager.instance.mainTabBarController = MainTabBarController()
        LoginManager.instance.mainTabBarController?.loadTabBar()
        LoginManager.instance.mainTabBarController?.modalTransitionStyle = .crossDissolve
        
        if !LoginManager.instance.isdownDeviceFromNet() {
            UserDefaults.standard.setValue("oK", forKey: downDeviceInderifer)
            UserDefaults.standard.synchronize()
            let alertView = SCLAlertView()
            
            _ = alertView.addButton(loadLanguage("确定"), action: {
                
                User.GetDeviceList(success: {
                    
                    self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
                }, failure: { (error) in
                    self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
                })
                
            })
            
            _ = alertView.addButton(loadLanguage("取消"), action: {
                 self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
            })
            _ = alertView.showInfo(loadLanguage("温馨提示"), subTitle: loadLanguage("是否从网络获取设备列表"))
            
        } else {
            
            self.present(LoginManager.instance.mainTabBarController!, animated: true, completion: nil)
        }
        
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
        phoneTextField.text = UserDefaults.standard.value(forKey: "LoginPhone") as! String?
        YZMTextField.text = UserDefaults.standard.value(forKey: "LoginCode") as! String?
        phoneTextField.placeholder = loadLanguage("请输入手机号")
        YZMTextField.placeholder=loadLanguage("输入验证码")
         phoneTextField.keyboardType = .numberPad
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
