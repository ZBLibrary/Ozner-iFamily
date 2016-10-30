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
    var wifiDevices=[OznerDevice]()//搜索到的设备数组
    @IBAction func nextClick(_ sender: AnyObject) {
        if wifiNameText.text=="" {
            _=SCLAlertView().showTitle("", subTitle: loadLanguage("Wifi名称不能为空!"), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.notice)
            return
        }
        
        UserDefaults.standard.set(wifiPassWordText.text!, forKey: "Wifi_"+wifiNameText.text!)//保存密码
        StarWifiPairing()
    }
    
    //正在进行配对时的动画点
    @IBOutlet var dotImg1: UIImageView!
    @IBOutlet var dotImg2: UIImageView!
    @IBOutlet var dotImg3: UIImageView!
    @IBOutlet var dotImg4: UIImageView!
    @IBOutlet var dotImg5: UIImageView!
    private var myTimer:Timer?
    var currDeviceType:String!
    var mxChipPair:MXChipPair!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mxChipPair=MXChipPair()
        mxChipPair.delegate=self
        wifiNameText.text=MXChipPair.getWifiSSID()
        let wifiPassWord=UserDefaults.standard.object(forKey: "Wifi_\(wifiNameText.text!)") ?? ""
        wifiPassWordText.text = (wifiPassWord as! String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CancleWifiPairing()
    }
    //开始配对
    func StarWifiPairing() {
        CancleWifiPairing()//终止以前的配对
        wifiViewContainer.isHidden=true//隐藏输入框
        //开始动画
        myTimer=Timer.scheduledTimer(timeInterval: 1/2, target: self, selector: #selector(imgAnimal), userInfo: nil, repeats: true)
        //开始调用配对方法
        mxChipPair.start(wifiNameText.text!, password: wifiPassWordText.text!)
        
    }
    func CancleWifiPairing(){
        if mxChipPair.isRuning() {
            mxChipPair.cancel()
        }
        if myTimer != nil {
            myTimer?.invalidate()
            myTimer=nil
        }
        wifiViewContainer.isHidden=false
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showsuccess" {
            let pair = segue.destination as! PairSuccessController
            pair.deviceArr = wifiDevices
        }
        if segue.identifier == "showfailed" {
            let pair = segue.destination as! PairFailedController
            pair.isBlueToothDevice=false
        }
        
    }
 

}
extension WifiPairingController : MxChipPairDelegate{
    func mxChipPairSendConfiguration() {
        
    }
    func mxChipFailure() {
        self.performSegue(withIdentifier: "showfailed", sender: nil)
    }
    func mxChipPairActivate() {
        
    }
    func mxChipPairWaitConnectWifi() {
        
    }
    func mxChipComplete(_ io: MXChipIO!) {
        let tmpDevice=OznerManager.instance().getDeviceBy(io)
        wifiDevices.append(tmpDevice!)
        self.performSegue(withIdentifier: "showsuccess", sender: nil)
    }
    
}
