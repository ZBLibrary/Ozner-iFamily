//
//  PairingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class PairingController: UIViewController {

    @IBOutlet var deviceImg: UIImageView!
    @IBOutlet var animalImg: UIImageView!
    @IBOutlet var deviceState: UILabel!
    @IBOutlet var typeState: UILabel!
    
    
    var deviceTypeValue: OznerDeviceType!
    
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(deviceTypeValue)
        loadImageandLb()
        loopImageAction()
        let time=Timer(timeInterval: 20, target: self, selector: #selector(success), userInfo: nil, repeats: false)
        time.fire()
    }

    private func loadImageandLb() {
        
        switch deviceTypeValue.rawValue {
            case OznerDeviceType.Cup.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_peidui_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "请将智能水杯倒置")
                setUpState(state: deviceState)
            break
            case OznerDeviceType.Tap.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_peidui_tantou_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "长按下start按钮")
                setUpState(state: deviceState)
            case OznerDeviceType.TDSPan.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_peidui_TDSPAN_watting", typeStateText: "正在进行蓝牙配对", deviceStateText: "长按下start按钮")
                setUpState(state: deviceState)
            case OznerDeviceType.Water_Wifi.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_peidui_jingshuiqi_watting", typeStateText: "正在进行Wifi配对", deviceStateText: "请同时按下净水器加热与制冷两个按钮")
                setUpState(state: deviceState)
            case OznerDeviceType.Air_Blue.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_smallair_peidui_waiting", typeStateText: "", deviceStateText: "正在进行蓝牙配对")
                setUpState(state: deviceState)
            case OznerDeviceType.Air_Wifi.rawValue:
                let deviceState = PairImagsAndState(imageName: "icon_bigair_peidui_waiting", typeStateText: "正在进行Wifi配对", deviceStateText: "同时按下电源和风速键,WiFi指示灯闪烁。")
                setUpState(state: deviceState)
            case OznerDeviceType.WaterReplenish.rawValue:
                let deviceState = PairImagsAndState(imageName: "WaterReplenish3", typeStateText: "待定", deviceStateText: "待定")
                setUpState(state: deviceState)
                break
        default:
            break
        }
        
    }
    
    private func setUpState(state:PairImagsAndState) {
        deviceImg.contentMode = .scaleAspectFit
        deviceImg.image = UIImage(named: state.imageName)
        typeState.text = state.typeStateText
        deviceState.text = state.deviceStateText
    }
    
    private func loopImageAction() {
    
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: M_PI * 2.0)
        rotation.duration = 1.0
        rotation.repeatCount = MAXFLOAT
        animalImg.layer.add(rotation, forKey: "rotationAnimation")
        
    }
    
    func success()  {
        
        self.performSegue(withIdentifier: "showsuccess", sender: nil)
//        animalImg.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    deinit {
        print("已销毁")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension PairingController {
    
    struct PairImagsAndState {
        let imageName:String
        let typeStateText:String
        let deviceStateText:String
        
    }
    
}
