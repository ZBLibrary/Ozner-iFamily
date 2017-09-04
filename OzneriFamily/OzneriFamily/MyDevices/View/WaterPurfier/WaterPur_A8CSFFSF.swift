//
//  WaterPurifierMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPur_A8CSFFSF: OznerDeviceView {

    var scanEnable = true
    var buyLvXinUrl = ""
    var lvXinStopDate = NSDate()
    var lvXinUsedDays = 0
    //var isBlueDevice = false
    
    func setLvXinAndEnable(scan:Bool,cool:Bool,hot:Bool,buyLvXinUrl:String,lvXinStopDate:NSDate,lvXinUsedDays:Int){
        self.scanEnable=scan
        self.buyLvXinUrl=buyLvXinUrl
        self.lvXinStopDate=lvXinStopDate
        self.lvXinUsedDays=lvXinUsedDays
    }
   
    
    //footer
    @IBOutlet var TemperatLabel: UILabel!
    @IBOutlet var footerContainer: UIView!
    @IBOutlet var powerLabel: UILabel!
    @IBOutlet var powerButton: UIButton!
    @IBOutlet var hotLabel: UILabel!
    @IBOutlet var hotButton: UIButton!
    @IBOutlet var coolLabel: UILabel!
    @IBOutlet var coolButton: UIButton!
    func setButtonEnable(timer:Timer) {
        (timer.userInfo as! UIButton).isEnabled=true
    }
    @IBAction func operationButtonClick(_ sender: UIButton) {
        
        sender.isEnabled=false
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(setButtonEnable), userInfo: sender, repeats: false)//防止多次连续点击
        if sender.tag != 0 && operation.power==false {
            return
        }
        
        switch sender.tag {
        case 0:
            (OznerManager.instance.currentDevice as! WaterPurifier_Wifi).setPower(Power: !operation.power, callBack: { (error) in
            })
        case 1:
                (OznerManager.instance.currentDevice as! WaterPurifier_Wifi).setHot(Hot: !operation.hot, callBack: { (error) in
                })
                
        case 2:
            
            (OznerManager.instance.currentDevice as! WaterPurifier_Wifi).setCool(Cool: !operation.cool, callBack: { (error) in
                })
                
        default:
            break
        }
        
    }
    
    
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var offLineSuggestView:OffLineSuggest!
    override func draw(_ rect: CGRect) {
        offLineSuggestView=Bundle.main.loadNibNamed("OffLineSuggest", owner: nil, options: nil)?.first as! OffLineSuggest
        offLineSuggestView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        offLineSuggestView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        TemperatLabel.text="-"
    }
    
    //                (currentDeviceView as! WaterPurifierMainView).circleView.updateCircleView(angleBefore: 0.7, angleAfter: 0.5)
    let color_normol=UIColor(red: 177.0/255.0, green: 178.0/255.0, blue: 179.0/255.0, alpha: 1)
    let color_select=UIColor(red: 63.0/255.0, green: 135.0/255.0, blue: 237.0/255.0, alpha: 1)
    var operation:(power:Bool,hot:Bool,cool:Bool) = (false,true,true){
        didSet{
            if operation==oldValue {
                return
            }
            powerLabel.textColor=operation.power ? color_select:color_normol
            powerButton.setImage( UIImage(named: operation.power ? "icon_power":"icon_power_normal"), for: .normal)
            hotLabel.textColor=operation.power&&operation.hot ? color_select:color_normol
            hotButton.setImage( UIImage(named: operation.power&&operation.hot ? "icon_jiare":"icon_jiare_normal"), for: .normal)
            coolLabel.textColor=operation.power&&operation.cool ? color_select:color_normol
            coolButton.setImage( UIImage(named: operation.power&&operation.cool ? "icon_zhileng":"icon_zhileng_normal"), for: .normal)
            
        }
    }
    var temperature:Float = -1{
        didSet{
            if temperature==oldValue {
                return
            }
            TemperatLabel.text="\(temperature)"
        }
    }
    override func SensorUpdate(identifier: String) {
        let device = currentDevice as! WaterPurifier_Wifi
        
        if device.connectStatus != OznerConnectStatus.Connected
        {
            
            operation=(false,false,false)
        }else{
            temperature=device.sensor.Temperature
            if device.status.Power==false {
            
                operation=(false,false,false)
            }else{
                operation=(device.status.Power,device.status.Hot,device.status.Cool)
            }
            
        }
    }
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        
        let device = currentDevice as! WaterPurifier_Wifi
        
        if device.connectStatus != OznerConnectStatus.Connected
        {
            
            operation=(false,false,false)
        }else{
            temperature=device.sensor.Temperature
            if device.status.Power==false {
                
                operation=(false,false,false)
            }else{
                operation=(device.status.Power,device.status.Hot,device.status.Cool)
            }
            
        }
        
    }
}
