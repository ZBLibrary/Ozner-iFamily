//
//  WifiPairingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WifiPairingController: UIViewController,UITextFieldDelegate {

    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    //无线网视图容器
    @IBOutlet var wifiViewContainer: UIView!
    @IBOutlet var wifiNameText: UITextField!
    @IBOutlet var wifiPassWordText: UITextField!
    
    @IBAction func seePassWordClick(_ sender: AnyObject) {
        wifiPassWordText.isSecureTextEntry = !wifiPassWordText.isSecureTextEntry
    }
    @IBOutlet var rememberImg: UIImageView!
    private var isRemember=true
    @IBAction func rememberPassWordClick(_ sender: AnyObject) {
        isRemember = !isRemember
        rememberImg.image=UIImage(named: isRemember ? "icon_agree_select":"icon_agree_normal")
    }
    @IBAction func nextClick(_ sender: AnyObject) {
        wifiViewContainer.isHidden=true
        starAnimal()
        //开始配对
    }
    
    //正在进行配对时的动画点
    @IBOutlet var dotImg1: UIImageView!
    @IBOutlet var dotImg2: UIImageView!
    @IBOutlet var dotImg3: UIImageView!
    @IBOutlet var dotImg4: UIImageView!
    @IBOutlet var dotImg5: UIImageView!
    private var myTimer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiNameText.delegate=self
        wifiPassWordText.delegate=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //开始配对等待动画
    func starAnimal() {
        myTimer=Timer.scheduledTimer(timeInterval: 1/2, target: self, selector: #selector(imgAnimal), userInfo: nil, repeats: true)
    }
    //结束配对动画
    func endAnimal()  {
        myTimer?.invalidate()
        myTimer=nil
    }
    private var dotIndex=0
    func imgAnimal() {
        for i in 0...4
        {
            [dotImg1,dotImg2,dotImg3,dotImg4,dotImg5][i]?.image=UIImage(named: dotIndex==i ?"icon_circle_select":"icon_circle_gray")
        }
        dotIndex=(dotIndex+1)%5
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
