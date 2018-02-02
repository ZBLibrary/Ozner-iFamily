//
//  NewTrendAirMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/17.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit
import UICountingLabel
class NewTrendAirMainView: OznerDeviceView {

    
   
    @IBAction func AppointTimeCLick(_ sender: UIButton) {//定时开关机
        //showNewAirAppoint
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            showMSG(msg: "设备已断开连接")
            return
        }
        self.delegate.DeviceViewPerformSegue!(SegueID: "showNewAirAppoint", sender: nil)
    }
    @IBOutlet var PM25Label_Out: UICountingLabel!
    @IBOutlet var PM25Label_In: UICountingLabel!
    @IBOutlet var TeampValueLabel: UILabel!
    @IBOutlet var HimitValueLabel: UILabel!
    @IBOutlet var leftSpeedImg: UIImageView!
    @IBOutlet var rightSpeedImg: UIImageView!
    @IBAction func PanSpeed(_ sender: UIPanGestureRecognizer) {
        if sender.state==UIGestureRecognizerState.ended{
            let point=sender.translation(in: nil)
            (self.currentDevice as! NewTrendAir_Wifi).setSpeed(key: (sender.view?.tag)!, value: point.y<0 ? +1:-1, callBack: { (error) in
                showMSG(msg: (error! as NSError).domain)
            })
        }
        
    }
    
    @IBOutlet var CO2ValueLabel: UILabel!
    @IBOutlet var TVOCValueLabel: UILabel!
    
    @IBOutlet var controlButton0: UIButton!
    @IBOutlet var controlButton1: UIButton!
    @IBOutlet var controlButton2: UIButton!
    @IBOutlet var controlButton3: UIButton!
    @IBAction func controlClick(_ sender: UIButton) {
        let device = (self.currentDevice as! NewTrendAir_Wifi)
        device.setControl(key: sender.tag) { (error) in
            showMSG(msg: (error! as NSError).domain)
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    func showMSG(msg:String) {
        let alertView=SCLAlertView()
        _=alertView.showTitle("", subTitle: msg, duration: 2.0, completeText: "ok", style: SCLAlertViewStyle.notice)
    }
    var control:(Power:Bool,Lock:Bool,AirAndSpeed:Int,NewAndSpeed:Int,hotPower:Bool,O3Power:Bool)=(false,false,0,0,false,false){
        didSet{
            if control==oldValue {
                return
            }
            if control.Power != oldValue.Power {
                controlButton0.setImage(UIImage.init(named: control.Power ? "新风开关ED":"新风开关"), for: .normal)
            }
            if control.AirAndSpeed != oldValue.AirAndSpeed {

                controlButton1.setImage(UIImage.init(named: control.AirAndSpeed>0 ? "新风净化ED":"新风净化"), for: .normal)
                let imgStr = ["新风左0","新风左1","新风左2","新风左3"][control.AirAndSpeed]
                leftSpeedImg.image=UIImage.init(named: imgStr)
                
            }
            if control.NewAndSpeed != oldValue.NewAndSpeed {
                controlButton2.setImage(UIImage.init(named: control.NewAndSpeed>0 ? "新风新风ED":"新风新风"), for: .normal)
                let imgStr = ["新风右0","新风右1","新风右2"][control.NewAndSpeed]
                rightSpeedImg.image=UIImage.init(named: imgStr)
                
            }
            if control.Lock != oldValue.Lock {
                controlButton3.setImage(UIImage.init(named: control.Lock ? "新风童锁ED":"新风童锁"), for: .normal)
            }
        }
    }
  
    //数据回掉处理
    override func SensorUpdate(identifier: String) {
        let deviceSensor = (self.currentDevice as! NewTrendAir_Wifi).sensor
        
        HimitValueLabel.text = deviceSensor.Humidity==0 ? "-%":"\(deviceSensor.Humidity)%"
        TeampValueLabel.text = deviceSensor.Temperature==0 ? "- ℃":"\(deviceSensor.Temperature) ℃"
        PM25Label_Out.text = deviceSensor.PM25_Out==0 ? "-":"\(deviceSensor.PM25_Out)"
        PM25Label_In.text = deviceSensor.PM25_In==0 ? "-":"\(deviceSensor.PM25_In)"
        
        switch true {
        case deviceSensor.CO2<600:
            CO2ValueLabel.text="优"
        case deviceSensor.CO2>1200:
            CO2ValueLabel.text="差"
        default:
            CO2ValueLabel.text="良"
        }
        switch true {
        case deviceSensor.TVOC<160:
            TVOCValueLabel.text="优"
        case deviceSensor.TVOC>300:
            TVOCValueLabel.text="差"
        default:
            TVOCValueLabel.text="良"
        }
        
    }
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        control = (self.currentDevice as! NewTrendAir_Wifi).status
    }
    
    override func FilterUpdate(identifier: String) {
        //let filterStatus = (self.currentDevice as! NewTrendAir_Wifi).filterStatus
    }
}
