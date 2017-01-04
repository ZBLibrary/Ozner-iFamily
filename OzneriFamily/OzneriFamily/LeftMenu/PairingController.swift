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
    
    
    var currDeviceType=OznerDeviceType.Cup
    
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("正在配对")
        loadImageandLb()
    }

    override func viewDidAppear(_ animated: Bool) {
        animalImg.oznerRotateSpeed=180
    }
    
    private func loadImageandLb() {
        var deviceDes:PairImagsAndState
        switch currDeviceType {
        case OznerDeviceType.Cup:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_watting", typeStateText:loadLanguage( "正在进行蓝牙配对"), deviceStateText: loadLanguage("请将智能水杯倒置"))
        case OznerDeviceType.Tap:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_tantou_watting", typeStateText:loadLanguage( "正在进行蓝牙配对"), deviceStateText: loadLanguage("长按下start按钮"))
        case OznerDeviceType.TDSPan:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_TDSPAN_watting", typeStateText:loadLanguage( "正在进行蓝牙配对"), deviceStateText: loadLanguage("长按下start按钮"))
        case OznerDeviceType.Water_Wifi:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_jingshuiqi_watting", typeStateText: loadLanguage("正在进行Wifi配对"), deviceStateText: loadLanguage("请同时按下净水器加热与制冷两个按钮"))
        case OznerDeviceType.Air_Blue:
            deviceDes = PairImagsAndState(imageName: "icon_smallair_peidui_waitting", typeStateText: "", deviceStateText:loadLanguage( "正在进行蓝牙配对"))
        case OznerDeviceType.Air_Wifi:
            deviceDes = PairImagsAndState(imageName: "icon_bigair_peidui_waitting", typeStateText:loadLanguage( "正在进行Wifi配对"), deviceStateText:loadLanguage( "同时按下电源和风速键,WiFi指示灯闪烁。"))
        case OznerDeviceType.WaterReplenish:
            deviceDes = PairImagsAndState(imageName: "WaterReplenish3", typeStateText: "请长按开机键五秒至灯光闪烁", deviceStateText: loadLanguage("正在进行蓝牙配对"))
        case OznerDeviceType.Water_Bluetooth:
            deviceDes = PairImagsAndState(imageName: "icon_peidui_jingshuiqi_watting", typeStateText: "", deviceStateText: loadLanguage("正在进行蓝牙配对"))
       
        }
        deviceImg.image = UIImage(named: deviceDes.imageName)
        typeState.text = deviceDes.typeStateText
        deviceState.text = deviceDes.deviceStateText
        pairTimer =  Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(selectPairType), userInfo: nil, repeats: false)//1秒动画，然后选择配对方式
    }
    
    @objc private func selectPairType()  {
        if pairTimer == nil {
            return
        }
        switch currDeviceType {
        case OznerDeviceType.Cup,OznerDeviceType.Tap,OznerDeviceType.TDSPan,OznerDeviceType.Air_Blue,OznerDeviceType.WaterReplenish,OznerDeviceType.Water_Bluetooth://蓝牙配对
            StarBluePair()
        case OznerDeviceType.Water_Wifi,OznerDeviceType.Air_Wifi://Wifi配对
            self.performSegue(withIdentifier: "showWifiPair", sender: nil)
            break
        }
    }
    var pairTimer:Timer?
    //每隔2秒搜寻下蓝牙设备，总共搜索不到30秒，搜到就就跳转到成功
    var blueDevices=[OznerDevice]()
    var blueTimer:Timer?
    var remainTimer=0 //倒计时60秒
    func StarBluePair() {
       
        remainTimer=60
        blueDevices=[OznerDevice]()
        blueTimer=Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(bluePairing), userInfo: nil, repeats: true)
    }
    @objc private func bluePairing() {
        
        if blueTimer==nil || remainTimer<0 {
            return
        }
        remainTimer-=2
        let deviceIOArr=OznerManager.instance().getNotBindDevices()
        for io in deviceIOArr! {
            if OznerManager.instance().checkisBindMode(io as! BaseDeviceIO) == true
            {
                let deviceType=OznerDeviceType.getType(type: (io as! BaseDeviceIO).type)
                
                if currDeviceType == OznerDeviceType.TDSPan  {
                    if deviceType == OznerDeviceType.Tap  {
                        if let device=OznerManager.instance().getDeviceBy(io as! BaseDeviceIO) {
                            blueDevices.append(device)
                        }
                    }
                }else{
                    if currDeviceType == deviceType  {
                        if let device=OznerManager.instance().getDeviceBy(io as! BaseDeviceIO) {
                            blueDevices.append(device)
                        }
                    }
                }
            }
        }
        if blueDevices.count>0 {
            self.performSegue(withIdentifier: "showsuccess", sender: nil)
        }else if remainTimer<0{
            self.performSegue(withIdentifier: "showfailed", sender: nil)
        }
        
    }
    
    deinit {
        //防止手势返回时导致界面跳转无导航以及界面
        pairTimer = nil
        blueTimer = nil
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        blueTimer?.invalidate()
        blueTimer=nil
        pairTimer = nil
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
