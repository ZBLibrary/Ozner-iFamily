//
//  PairingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class PairingController: UIViewController,OznerManagerDelegate {

    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var animalImg: UIImageView!
    @IBOutlet var deviceState: UILabel!
    @IBOutlet var typeState: UILabel!
    
    
    var currDeviceType: String!
    
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageandLb()
    }

    override func viewDidAppear(_ animated: Bool) {
        animalImg.oznerRotateSpeed=180
    }
    
    private func loadImageandLb() {
        var deviceDes:PairImagsAndState
        switch currDeviceType {
        case OznerDeviceType.Cup.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "请将智能水杯倒置")
        case OznerDeviceType.Tap.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_tantou_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "长按下start按钮")
        case OznerDeviceType.TDSPan.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_TDSPAN_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "长按下start按钮")
        case OznerDeviceType.Water_Wifi.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_jingshuiqi_watting", typeStateText: "正在进行Wifi配对", deviceStateText: "请同时按下净水器加热与制冷两个按钮")
        case OznerDeviceType.Air_Blue.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_smallair_peidui_waitting", typeStateText: "", deviceStateText: "正在进行蓝牙配对")
        case OznerDeviceType.Air_Wifi.rawValue:
            deviceDes = PairImagsAndState(imageName: "icon_bigair_peidui_waitting", typeStateText: "正在进行Wifi配对", deviceStateText: "同时按下电源和风速键,WiFi指示灯闪烁。")
        case OznerDeviceType.WaterReplenish.rawValue:
            deviceDes = PairImagsAndState(imageName: "WaterReplenish3", typeStateText: "", deviceStateText: "正在进行蓝牙配对")
        default:
            deviceDes = PairImagsAndState(imageName: "", typeStateText: "", deviceStateText: "")
            break
        }
        deviceImg.image = UIImage(named: deviceDes.imageName)
        typeState.text = deviceDes.typeStateText
        deviceState.text = deviceDes.deviceStateText
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(selectPairType), userInfo: nil, repeats: false)//1秒动画，然后选择配对方式
    }
    
    

    
    @objc private func selectPairType()  {
        
        switch currDeviceType {
        case OznerDeviceType.Cup.rawValue,OznerDeviceType.Tap.rawValue,OznerDeviceType.TDSPan.rawValue,OznerDeviceType.Air_Blue.rawValue,OznerDeviceType.WaterReplenish.rawValue://蓝牙配对
            StarBluePair()
        case OznerDeviceType.Water_Wifi.rawValue,OznerDeviceType.Air_Wifi.rawValue://Wifi配对
            self.performSegue(withIdentifier: "showWifiPair", sender: nil)
            break
        default:
            break
        }
    }
    //每隔2秒搜寻下蓝牙设备，总共搜索不到30秒，搜到就就跳转到成功
    var blueDevices=[OznerDevice]()
    var blueTimer:Timer?
    var remainTimer=0 //倒计时30秒
    func StarBluePair() {
       
        remainTimer=30
        blueDevices=[OznerDevice]()
        blueTimer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(bluePairing), userInfo: nil, repeats: true)
    }
    @objc private func bluePairing() {
        if blueTimer==nil {
            return
        }
        remainTimer-=2
        let deviceIOArr=OznerManager.instance().getNotBindDevices()
        for io in deviceIOArr! {
            if (io as! BaseDeviceIO).type==(currDeviceType==OznerDeviceType.TDSPan.rawValue ? OznerDeviceType.Tap.rawValue:currDeviceType) {
                if let device=OznerManager.instance().getDeviceBy(io as! BaseDeviceIO) {
                    blueDevices.append(device)
                }
            }
        }
        if blueDevices.count>0 {
            self.performSegue(withIdentifier: "showsuccess", sender: nil)
        }
        if remainTimer<0 {
            self.performSegue(withIdentifier: "showfailed", sender: nil)
        }
    }
    
    deinit {
        print("已销毁")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        blueTimer?.invalidate()
        blueTimer=nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        switch (segue.identifier)! {
        case "showsuccess":
            let pair = segue.destination as! PairSuccessController
            pair.deviceArr = blueDevices
            pair.CurrDeviceType=self.currDeviceType
        case "showfailed":
            let pair = segue.destination as! PairFailedController
            
            pair.isBlueToothDevice = true
        case "showWifiPair":
            let pair = segue.destination as! WifiPairingController
            
            pair.currDeviceType = self.currDeviceType
        default:
            break
        }
        
    }
 

}

extension PairingController {
    
    struct PairImagsAndState {
        let imageName:String
        let typeStateText:String
        let deviceStateText:String
        
    }
    
}
