//
//  RNModifyPasswordViewController.swift
//  OZner
//
//  Created by 婉卿容若 on 16/7/26.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RNModifyPasswordViewController: UIViewController {
    
    // 正则判定
    
    struct RNRegexHelper {
        
        let regex: NSRegularExpression
        
        init(_ pattern: String) throws {
            
            try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
        }
        
        func match(input: String) -> Bool {
            
            let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
            
            return matches.count > 0
        }
    }


    // MARK: - properties - 即定义的各种属性
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contrainerView: UIView! //
    
    @IBOutlet weak var emailTextField: UITextField! // 邮箱
    
    @IBOutlet weak var codeTextField: UITextField! // 验证码
    
    @IBOutlet weak var pswTextField: UITextField! // 密码
    
    @IBOutlet weak var cPswTextField: UITextField! // 确认密码
    
    @IBOutlet weak var getCodeBtn: UIButton! // 获取验证码
    
    private var returnkeyHandler: IQKeyboardReturnKeyHandler!
    var countDownTimer: Timer? // 计时器
    
    var remainingSeconds = 0{ // 倒计时剩余多少秒
        
        willSet{
            
            getCodeBtn.setTitle("\(newValue)s", for: UIControlState.normal)
            
            if newValue <= 0 {
                
                getCodeBtn.setTitle("重新获取", for: UIControlState.normal)
                
                isCounting = false
            }
        }
    }
    
    var isCounting: Bool = false{ // 用于开启和关闭计时器
        
        willSet{
            
            if  newValue {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                
                // getCodeBtn.backgroundColor = UIColor.grayColor()
            }else {
                
                countDownTimer?.invalidate()
                countDownTimer = nil
                
                //  getCodeBtn.backgroundColor = UIColor.brownColor()
            }
            
            getCodeBtn.isEnabled = !newValue
        }
    }
    

    
    // MARK: -  Life cycle - 即生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
     returnkeyHandler = IQKeyboardReturnKeyHandler(controller: self)
//        addDelegateForTextField()
//        keyBoardObserve()
//        addTap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)

    }
    
}

// MARK: - Public Methods - 即系统提供的方法

extension RNModifyPasswordViewController{
    
}

// MARK: - Private Methods - 即私人写的方法

extension  RNModifyPasswordViewController: UITextFieldDelegate{
 
    // 添加代理
    func addDelegateForTextField() {
        
        emailTextField.delegate = self
        codeTextField.delegate = self
        pswTextField.delegate = self
        cPswTextField.delegate = self
    }
    
    
    // 校验
    func checkout01() -> Bool{
        
        guard !(emailTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle:  "Email cannot be empty")
            
            return false
        }
        
        guard isValidateEmail(email: emailTextField.text!) else{
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle:  "Email address format is not correct")
            
            return false
        }
        
        
        return true
    }
    
    func checkout02() -> Bool{
        
        guard !(codeTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle:  " Security code cannot be empty")
            
            return false
        }
        
        guard !(pswTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle:  "New Password connot be empty")
            
            return false
        }
        
        guard !(cPswTextField.text?.isEmpty)! else{
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle: "Confirm Password connot be empty")
            
            return false
        }
        
        
        guard (pswTextField.text! as NSString).isEqual(to: cPswTextField.text!) else {
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: {})
            alertView.showError("Error Tips", subTitle:  "Two different passwords")
            
            return false
        }
        
        return true
        
    }
    
    
    // 邮箱格式
    func isValidateEmail(email: String) -> Bool{
        
        let emailRegex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher: RNRegexHelper
        do {
            matcher = try! RNRegexHelper(emailRegex)
        }
        
        return matcher.match(input: email)
    }
    
    // 键盘监听
    func keyBoardObserve() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // 添加手势
    func addTap() {
        
        contrainerView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyHidden))
        contrainerView.addGestureRecognizer(tap)
    }
    
    
    // 修改密码请求
    func modifyRequeset(){
        let email = emailTextField.text!
        let password = pswTextField.text!
        let code = codeTextField.text!

        let params:NSDictionary = ["username":email,"password":password,"code":code]
        
        User.ResetPasswordByEmail(params, { 
                                    let alertView=SCLAlertView()
                                    alertView.addButton("OK", action: { [weak self] in
            
                                        self!.dismiss(animated: false, completion: nil)
                                        })
                                    alertView.showSuccess("Tips", subTitle: "Modify success, return to login")
            }) { (error) in
                
                                        let alertView=SCLAlertView()
                                        alertView.addButton("OK", action: {})
                                        alertView.showError("Error Tips", subTitle: error.localizedDescription)
        }
        
    }
    

}

// MARK: - Event response - 按钮/手势等事件的回应方法

extension  RNModifyPasswordViewController{
    
    // 获取验证码
    @IBAction func getCodeAction(sender: UIButton) {
        
        // 先校验邮箱格式
        
        guard checkout01() else{ return }
        
        // 调用发送验证码接口
        let email = emailTextField.text!
//        let manager = AFHTTPRequestOperationManager()
//        let url = StarURL_New+"/OznerServer/GetEmailCode"
        let params:NSDictionary = ["email":email]
        
        User.getEmailVaildCode(params, {
            
            
            let alertView=SCLAlertView()
            alertView.addButton("OK", action: { [weak self] in
                
                self!.remainingSeconds = 60
                self!.isCounting = true
                
                })
            alertView.showSuccess("Tips", subTitle: "Get verification code is successful, open the mailbox access security code")
            
            
        }) { (error) in
            print(error)
        }

        
    }

    
    // 注册
    @IBAction func modifyAction(sender: UIButton) {
        
        guard checkout01() else{ return }
        
        guard checkout02() else{ return }
        
        // 请求接口
        modifyRequeset()
    }
    
    // 返回
    @IBAction func backAction(sender: UIButton) {
        
       self.dismiss(animated: false, completion: nil)
          
    }

    //计时器事件
    func updateTime() -> Void {
        
        remainingSeconds -= 1
    }
    
    // 键盘显示
    func keyboardWillShow(_ notification: NSNotification) {
        
        // 获取键盘高度
        let height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        
        // 设置 contentInset 的值,默认为(0,0,0,0)
        let e = UIEdgeInsetsMake(0, 0, height, 0)
        
        scrollView.contentInset = e
        
    }
    
    // 键盘隐藏
    func keyboardWillHidden(_ notification: NSNotification) {
        
        // 将 contentInset 的值设回默认值(0,0,0,0)
        let e = UIEdgeInsetsMake(0, 0, 0, 0)
        
        scrollView.contentInset = e
        
    }
    
    // 手势收起键盘
    func keyHidden() {
        
        contrainerView.endEditing(true)
    }
    

}

// MARK: - Delegates - 即各种代理方法

// MARK: - UITextFieldDelegate

extension RNModifyPasswordViewController{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.tag < 3 {
            let tf = contrainerView.viewWithTag(textField.tag + 1) as! UITextField
            tf.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}


