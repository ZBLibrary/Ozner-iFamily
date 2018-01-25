//
//  PairingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class PairingController: UIViewController,OznerPairDelegate {

    var productInfo:JSON!
    private var scanDeviceInfo:[OznerDeviceInfo]!
    
    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var animalImg: UIImageView!
    @IBOutlet var deviceState: UILabel!
    @IBOutlet var typeState: UILabel!
   
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("正在配对")
        deviceImg.image = UIImage(named: productInfo["pairing"]["pairingImg2"].stringValue)
        typeState.text = productInfo["pairing"]["pairingText1"].stringValue
        deviceState.text = loadLanguage(["Ayla":"正在进行WiFi配对","MxChip":"正在进行WiFi配对","Blue":"正在进行蓝牙配对","BlueMxChip":"正在进行配对","AylaMxChip":"正在进行WiFi配对"][productInfo["IOType"].stringValue]!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animalImg.oznerRotateSpeed=180
    }
    
    
    
    var pairTimer:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pairTimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(selectPairType), userInfo: nil, repeats: false)//1秒动画，然后选择配对方式
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pairTimer?.invalidate()
        pairTimer = nil
    }
    @objc private func selectPairType()  {
        if pairTimer == nil {
            return
        }
        switch OZIOType.getFromString(str: productInfo["IOType"].stringValue) {
        case .Blue://蓝牙配对
            scanDeviceInfo=[OznerDeviceInfo]()
            OznerManager.instance.starPair(deviceClass: OZDeviceClass.getFromString(str: productInfo["ClassName"].stringValue), pairDelegate: self, ssid: "", password: "")
        case .MxChip,.Ayla,.AylaMxChip://WiFi配对
            
            let alertView = SCLAlertView()
            _ = alertView.addButton("确定", action: { [weak self] (Void) -> Void in
                self?.performSegue(withIdentifier: "showWifiPair", sender: nil)
            })
            _ = alertView.addButton("取消", action: { [weak self] (Void) -> Void in
                
                self?.navigationController?.popViewController(animated: true)
            })
            _ = alertView.showInfo("重要提示", subTitle: productInfo["pairing"]["pairingText1"].stringValue)
            
            break
        case .BlueMxChip:
            break
        }
    }
//    deinit {
//        //防止手势返回时导致界面跳转无导航以及界面
//        pairTimer?.invalidate()
//        pairTimer = nil
//        
//    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OznerPairSucceed(deviceInfo: OznerDeviceInfo) {
        scanDeviceInfo.append(deviceInfo)
        self.performSegue(withIdentifier: "showsuccess", sender: nil)
        
    }
    func OznerPairFailured(error: Error) {
        self.performSegue(withIdentifier: "showfailed", sender: nil)
    }
   
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        switch (segue.identifier)! {
        case "showsuccess":
            let pair = segue.destination as! PairSuccessController
            pair.productInfo=productInfo
            pair.deviceArr = scanDeviceInfo
            
        case "showfailed":
            let pair = segue.destination as! PairFailedController
            
            pair.isBlueToothDevice = true
        case "showWifiPair":
            let pair = segue.destination as! WifiPairingController
            pair.productInfo=productInfo
        default:
            break
        }
        
    }
 

}

