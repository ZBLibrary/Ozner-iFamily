//
//  SendYanZHViewController.swift
//  My
//
//  Created by test on 15/11/26.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class SendYanZHViewController: UIViewController,UITextFieldDelegate {

    var sendphone=""
    @IBAction func CancelClick(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func SendClick(sender: AnyObject) {
        SendMess(messstring: MessTF.text!)
        
    }
    @IBOutlet var MessTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessTF.delegate=self
        MessTF.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
//        /*
//        usertoken
//        //用户登录返回标识
//        mobile
//        //对方手机号
//        content
//         */
//        let manager = AFHTTPRequestOperationManager()
//        let url = StarURL_New+"/OznerServer/AddFriend"
        let params:NSDictionary = ["content":messstring,"mobile":sendphone]
        
        User.AddFriend(params, { (data) in
            print(data)
            }) { (error) in
                print(error)
        }
//        manager.POST(url,
//            parameters: params,
//            success: { (operation: AFHTTPRequestOperation!,
//                responseObject: AnyObject!) in
//                print(responseObject)
//                let isSuccess=responseObject.objectForKey("state") as! Int
//                if isSuccess > 0
//                {
//                    let successalert = UIAlertView(title: "", message: "发送成功", delegate: self, cancelButtonTitle: "ok")
//                    NSNotificationCenter.defaultCenter().postNotificationName("sendAddFriendMesSuccess", object: nil)
//                    successalert.show()
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//                else if isSuccess == -10017
//                {
//                    let successalert = UIAlertView(title: "", message: "对方不是浩泽用户", delegate: self, cancelButtonTitle: "ok")
//                    successalert.show()
//                }
//                
//            },
//            failure: { (operation: AFHTTPRequestOperation!,
//                error: NSError!) in
//                
//                //print("Error: " + error.localizedDescription)
//                
//        })
//        let werbservice = UserInfoActionWerbService()
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        werbservice.addFriend(sendphone, content: messstring, returnBlock:{ (state:StatusManager!) -> Void in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            if state.networkStatus == kSuccessStatus
//            {
//                let successalert = UIAlertView(title: "提示", message: "发送验证消息成功", delegate: self, cancelButtonTitle: "ok")
//                successalert.show()
//                self.navigationController?.popViewControllerAnimated(true)
//                NSNotificationCenter.defaultCenter().postNotificationName("sendAddFriendMesSuccess", object: nil)
//            }
//            else
//            {
//                let successalert = UIAlertView(title: "提示", message: "添加失败，请检查网络", delegate: self, cancelButtonTitle: "ok")
//                successalert.show()
//            }
//        })
// 
        
    }
}
 
