//
//  WifiPairingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class WifiPairingController: UIViewController,UITextFieldDelegate {

    var productInfo:JSON!
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var conWL: UILabel!
    @IBOutlet weak var connectWl: UILabel!
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
    var wifiDevices=[OznerDeviceInfo]()//搜索到的设备数组
    @IBAction func nextClick(_ sender: AnyObject) {
        if wifiNameText.text=="" {
            _=SCLAlertView().showTitle("", subTitle: loadLanguage("Wifi名称不能为空!"), duration: 2.0, completeText: loadLanguage("完成"), style: SCLAlertViewStyle.notice)
            return
        }
        
        UserDefaults.standard.set(wifiPassWordText.text!, forKey: "Wifi_"+wifiNameText.text!)//保存密码
        let className=productInfo["ClassName"].stringValue
        switch className {
        case OZDeviceClass.AirPurifier_Wifi.rawValue://汉枫测试
            let vc = HFPairingViewController()
            vc.ssid=wifiNameText.text!
            vc.password=wifiPassWordText.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            StarWifiPairing()
        }

    }
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var remberPwd: UILabel!
    //正在进行配对时的动画点
    @IBOutlet var dotImg1: UIImageView!
    @IBOutlet var dotImg2: UIImageView!
    @IBOutlet var dotImg3: UIImageView!
    @IBOutlet var dotImg4: UIImageView!
    @IBOutlet var dotImg5: UIImageView!
    private var myTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("WiFi配对")
        connectWl.text = loadLanguage("连接WLAN")
        conWL.text = loadLanguage("选择一个可用的WLAN,让设备接入网络")
        remberPwd.text = loadLanguage("下次记住密码")
        nextBtn.setTitle(loadLanguage("下一步"), for: UIControlState.normal)
        //mxChipPair=MXChipPair()
        //mxChipPair.delegate=self
        OznerManager.instance.fetchCurrentSSID(handler: { (ssid) in
            self.wifiNameText.text = ssid ?? ""
        })
        let wifiPassWord=UserDefaults.standard.object(forKey: "Wifi_\(wifiNameText.text!)") ?? ""
        wifiPassWordText.text = (wifiPassWord as! String)
        wifiPassWordText.placeholder = loadLanguage("请输入密码")
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
        let deviceClass = OZDeviceClass.getFromString(str: productInfo["ClassName"].stringValue)        
        OznerManager.instance.starPair(deviceClass: deviceClass, pairDelegate: self, ssid: wifiNameText.text!, password: wifiPassWordText.text!)
    }
    func CancleWifiPairing(){
        OznerManager.instance.canclePair()
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
            pair.productInfo=productInfo
        }
        if segue.identifier == "showfailed" {
            let pair = segue.destination as! PairFailedController
            pair.isBlueToothDevice=false
        }
        
    }
 

}
extension WifiPairingController : OznerPairDelegate{
    func OznerPairSucceed(deviceInfo: OznerDeviceInfo) {
        wifiDevices.append(deviceInfo)
        self.performSegue(withIdentifier: "showsuccess", sender: nil)
    }
    func OznerPairFailured(error: Error) {
        self.performSegue(withIdentifier: "showfailed", sender: nil)
    }
    
}
