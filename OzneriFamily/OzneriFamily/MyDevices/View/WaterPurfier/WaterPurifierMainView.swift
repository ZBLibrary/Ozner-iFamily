//
//  WaterPurifierMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurifierMainView: OznerDeviceView,GYValueSliderDelegate {

    var scanEnable = true
    var coolEnable = true
    var hotEnable = true
    var buyLvXinUrl = ""
    var lvXinStopDate = NSDate()
    var lvXinUsedDays = 0
    var isBlueDevice = false
    var currentBtn:UIButton?
    
    func setLvXinAndEnable(scan:Bool,cool:Bool,hot:Bool,buyLvXinUrl:String,lvXinStopDate:NSDate,lvXinUsedDays:Int){
        self.scanEnable=scan
        self.coolEnable=cool
        self.hotEnable=hot
        self.buyLvXinUrl=buyLvXinUrl
        self.lvXinStopDate=lvXinStopDate
        self.lvXinUsedDays=lvXinUsedDays
    }
    @IBOutlet var waterDaysLabel: UILabel!//水值
    @IBOutlet var circleView: WaterPurifierHeadCircleView!
    
    @IBOutlet weak var kitChenView: UIView!
    //header
    @IBOutlet var tdsImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    @IBOutlet var tdsValueLabel_BF: UILabel!
    @IBOutlet var tdsValueLabel_AF: UILabel!
    @IBOutlet var offLineLabel: UILabel!//断网提示Label
    @IBOutlet var tdsContainerView: UIView!
    @IBAction func toTDSDetailClick(_ sender: UITapGestureRecognizer) {
        if ProductInfo.getCurrDeviceClass() == .WaterPurifier_Wifi {//wifi设备
            if (self.currentDevice as! WaterPurifier_Wifi).connectStatus != .Connected {//断网状态
                weak var weakself=self
                offLineSuggestView.updateView(IsAir: false, callback: {
                    weakself?.offLineSuggestView.removeFromSuperview()
                })
                self.window?.addSubview(offLineSuggestView)
            }else{
                self.delegate.DeviceViewPerformSegue!(SegueID: "showWaterPurfierTDS", sender: nil)
            }
            
        }
        
    }
    
    //footer
    @IBOutlet var footerContainer: UIView!
    @IBOutlet var powerLabel: UILabel!
    @IBOutlet var powerButton: UIButton!
    @IBOutlet var hotLabel: UILabel!
    @IBOutlet var hotButton: UIButton!
    @IBOutlet var coolLabel: UILabel!
    @IBOutlet var coolButton: UIButton!
    
    //1
    
    @IBOutlet weak var valueSlider: GYValueSlider!
    @IBOutlet weak var sumwaterLb: UILabel!
    @IBOutlet weak var lowBtn: UIButton!
    @IBOutlet weak var centerBtn: UIButton!
    
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var highBtn: UIButton!
    func setButtonEnable(timer:Timer) {
        (timer.userInfo as! UIButton).isEnabled=true
    }
    @IBAction func operationButtonClick(_ sender: UIButton) {
        
        if ProductInfo.getCurrDeviceClass() == .WaterPurifier_Blue {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                dynamicAnimatorActive: true
            )
            let alert=SCLAlertView(appearance: appearance)
            _=alert.addButton(loadLanguage("确定"), action: {return})
            _=alert.showNotice(loadLanguage("提示"), subTitle: loadLanguage("抱歉，该净水器型号没有提供此项功能！"))
            return
        }
        
        sender.isEnabled=false
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(setButtonEnable), userInfo: sender, repeats: false)//防止多次连续点击
        if sender.tag != 0 && operation.power==false {
            return
        }
        
        switch sender.tag {
        case 0:
            (self.currentDevice as! WaterPurifier_Wifi).setPower(Power: !operation.power, callBack: { (error) in
            })
        case 1:
            if hotEnable {
                (self.currentDevice as! WaterPurifier_Wifi).setHot(Hot: !operation.hot, callBack: { (error) in
                })
            }else{
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    dynamicAnimatorActive: true
                )
                let alert=SCLAlertView(appearance: appearance)
                _=alert.addButton(loadLanguage("确定"), action: {return})
                _=alert.showNotice(loadLanguage("提示"), subTitle: loadLanguage("抱歉，该净水器型号没有提供此项功能！"))
            }
            
        case 2:
            if coolEnable {
                (self.currentDevice as! WaterPurifier_Wifi).setCool(Cool: !operation.cool, callBack: { (error) in
                })
            }else{
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    dynamicAnimatorActive: true
                )
                let alert=SCLAlertView(appearance: appearance)
                _=alert.addButton(loadLanguage("确定"), action: {return})
                _=alert.showNotice(loadLanguage("提示"), subTitle: loadLanguage("抱歉，该净水器型号没有提供此项功能！"))
            }
            
        default:
            break
        }
        
    }
    
    
    
    @IBAction func tempAction(_ sender: UIButton) {
        
        let device = currentDevice as? WaterPurifier_Blue
        if device?.connectStatus != OznerConnectStatus.Connected {
            valueSlider.isEnabled = false
            return
        } else {
            valueSlider.isEnabled = true
        }
        lowBtn.isEnabled = false
        centerBtn.isEnabled = false
        highBtn.isEnabled = false
        customerBtn.isEnabled = false
        currentBtn?.isEnabled = false
        switch sender.tag {
        case 5555:
            
            if (device?.setHotTemp(55))! {
                
                cornerBtn(sender)
                valueSlider.value = 55
                
            }
            break
        case 6666:
            
            if (device?.setHotTemp(85))! {
                cornerBtn(sender)
                valueSlider.value = 85
            }
            break
        case 7777:
            if (device?.setHotTemp(99))! {
                cornerBtn(sender)
                valueSlider.value = 99
            }
            break
        case 8888:
            let value = UserDefaults.standard.value(forKey: "UISliderValue") ?? 40
            if (device?.setHotTemp(value as! Int))! {
                cornerBtn(sender)
                valueSlider.value = Float(value as! Int)
            }
            
            break
        default:
            break
        }
        
        if valueSlider.previewView != nil {
            
            valueSlider.previewView?.frame = canclueFrame()
            valueSlider.previewView?.changeValue(String.init(format: "%.0f", valueSlider.value) + "℃")
            
        } else {
            valueSlider.addSubview(valueSlider.creatGYTmpView(canclueFrame()))
            valueSlider.previewView?.changeValue(String.init(format: "%.0f",valueSlider.value) + "℃")
        }
        lowBtn.isEnabled = true
        centerBtn.isEnabled = true
        highBtn.isEnabled = true
        customerBtn.isEnabled = true
        currentBtn?.isEnabled = true
        if currentBtn != sender {
            if currentBtn != nil {
                btnBackColor(currentBtn!)
            }
            currentBtn = sender
        }
    }
    
    func endTrackingSetValue() {
        let device = currentDevice as? WaterPurifier_Blue
        _ =  device?.setHotTemp(Int(valueSlider.value))
    }
    
    
    
    fileprivate func canclueFrame() -> CGRect{
        let rect = valueSlider.thumbRect(forBounds: valueSlider.bounds, trackRect: valueSlider.bounds, value: valueSlider.value)
        let rect1 = rect.insetBy(dx: -8, dy: -8)
        let rect2 = rect1.offsetBy(dx: 0, dy: -30)
        return rect2
    }
    
    fileprivate func btnBackColor(_ sender:UIButton) {
        sender.layer.masksToBounds = false
        sender.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sender.layer.borderWidth = 0
    }
    
    fileprivate func cornerBtn(_ sender:UIButton) {
        UIView.animate(withDuration: 1) {
            sender.layer.cornerRadius = 15
            sender.layer.masksToBounds = true
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.init(hex: "48c2fa").cgColor
            sender.setTitleColor(UIColor.init(hex: "48c2fa"), for: UIControlState.normal)
        }
        
    }
    
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var offLineSuggestView:OffLineSuggest!
    override func draw(_ rect: CGRect) {
        offLineSuggestView=Bundle.main.loadNibNamed("OffLineSuggest", owner: nil, options: nil)?.first as! OffLineSuggest
        offLineSuggestView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        offLineSuggestView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        waterDaysLabel.text=""
    }
    
    //                (currentDeviceView as! WaterPurifierMainView).circleView.updateCircleView(angleBefore: 0.7, angleAfter: 0.5)
    var tds:(tds1:Int,tds2:Int)=(0,-1){
        didSet{
            if tds==oldValue {
                return
            }
            let tmptdsBF = (tds.tds1==65535 || tds.tds1<0) ? 0:tds.tds1
            let tmptdsAF = (tds.tds2==65535 || tds.tds2<0) ? 0:tds.tds2
            let tdsBF=max(tmptdsBF, tmptdsAF)
            let tdsAF=min(tmptdsBF, tmptdsAF)
            
            tdsValueLabel_BF.text = tdsBF==0 ? loadLanguage("暂无"):"\(tdsBF)"
            tdsValueLabel_BF.font = UIFont(name: ".SFUIDisplay-Thin", size: (tdsBF==0 ? 32:45)*width_screen/375)
            tdsValueLabel_AF.text = tdsAF==0 ? loadLanguage("暂无"):"\(tdsAF >= 99 ? 99 : tdsAF)"
            tdsValueLabel_AF.font = UIFont(name: ".SFUIDisplay-Thin", size: (tdsAF==0 ? 32:45)*width_screen/375)
            
            var angleBF = CGFloat(0)
            switch true {
            case tdsBF<=Int(tds_good):
                angleBF=CGFloat(tdsBF)/CGFloat(tds_good*3)
            case tdsBF>Int(tds_good)&&tdsBF<=Int(tds_bad):
                angleBF=CGFloat(tdsBF-Int(tds_good))/CGFloat((tds_bad-tds_good)*3)+0.33
            case tdsBF>Int(tds_bad)&&tdsBF<Int(tds_bad+50):
                angleBF=CGFloat(tdsBF-Int(tds_bad))/CGFloat(50*3)+0.66
            default:
                angleBF=1.0
                break
            }
            var angleAF = CGFloat(0)
            switch true {
            case tdsAF<=0:
                tdsStateLabel.text=loadLanguage("-")
                angleAF=0
            case tdsAF>0&&tdsAF<=Int(tds_good):
                tdsImg.image=UIImage(named: "waterState1")
                tdsStateLabel.text=loadLanguage("健康")
                angleAF=CGFloat(tdsAF)/CGFloat(tds_good*3)
            case tdsAF>Int(tds_good)&&tdsAF<=Int(tds_bad):
                tdsImg.image=UIImage(named: "waterState2")
                tdsStateLabel.text=loadLanguage("一般")
                angleAF=CGFloat(tdsAF-Int(tds_good))/CGFloat((tds_bad-tds_good)*3)+0.33
            case tdsAF>Int(tds_bad)&&tdsAF<Int(tds_bad+50):
                tdsImg.image=UIImage(named: "waterState3")
                tdsStateLabel.text=loadLanguage("较差")
                angleAF=CGFloat(tdsAF-Int(tds_bad))/CGFloat(50*3)+0.66
            default:
                tdsImg.image=UIImage(named: "waterState3")
                tdsStateLabel.text=loadLanguage("较差")
                angleAF=1.0
                break
            }
            circleView.updateCircleView(angleBefore: angleBF, angleAfter: angleAF)
        }
    }
    var waterStopDate:Date = Date.init(timeIntervalSince1970: 0){
        didSet{
            if waterStopDate != oldValue {
                let currentDevice=OznerManager.instance.currentDevice as! WaterPurifier_Blue
                if currentDevice.WaterSettingInfo.waterModel==Int(0x8816) {
                    let days=(waterStopDate as NSDate).days(from: Date())
                    waterDaysLabel.text="浩泽安全净水\(max(days, 0))天"
                }else{
                    waterDaysLabel.text=""
                }
            }
        }
    }
    var sumWater:String = "0ml" {
        didSet {
            if sumWater != oldValue {
                sumwaterLb.text = sumWater
            }
        }
    }
    
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
    
    
    
    override func SensorUpdate(identifier: String) {
        //更新传感器视图
        if ProductInfo.getCurrDeviceClass() == .WaterPurifier_Blue {
            let currentDevice=OznerManager.instance.currentDevice as! WaterPurifier_Blue
            valueSlider.isEnabled = currentDevice.connectStatus == .Connected
            tdsContainerView.isHidden=false
            offLineLabel.isHidden=true
            tds=(currentDevice.WaterInfo.TDS1,currentDevice.WaterInfo.TDS2)
            
            waterStopDate=currentDevice.WaterSettingInfo.waterDate
            
        }else{
            let device = currentDevice as! WaterPurifier_Wifi
            
            if device.connectStatus != OznerConnectStatus.Connected
            {
                tdsContainerView.isHidden=true
                offLineLabel.isHidden=false
                offLineLabel.text=loadLanguage("设备云已断开")
                operation=(false,false,false)
            }else{
                if device.status.Power==false {
                    tdsContainerView.isHidden=true
                    offLineLabel.isHidden=false
                    offLineLabel.text=loadLanguage("设备已关机")
                    operation=(false,false,false)
                }else{
                    tdsContainerView.isHidden=false
                    offLineLabel.isHidden=true
                    tds=(device.sensor.TDS_Before,device.sensor.TDS_After)
                    operation=(device.status.Power,device.status.Hot,device.status.Cool)
                }
                
            }
        }
        
    }
    
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        //更新连接状态视图
        if ProductInfo.getCurrDeviceClass() == .WaterPurifier_Blue {
            tdsContainerView.isHidden=false
            offLineLabel.isHidden=true
            tds=(Int((currentDevice as! WaterPurifier_Blue).WaterInfo.TDS1),Int((currentDevice as! WaterPurifier_Blue).WaterInfo.TDS2))
        }else{
            let device = currentDevice as! WaterPurifier_Wifi
            
            if device.connectStatus != OznerConnectStatus.Connected
            {
                tdsContainerView.isHidden=true
                offLineLabel.isHidden=false
                offLineLabel.text=loadLanguage("设备云已断开")
                operation=(false,false,false)
            }else{
                if device.status.Power==false {
                    tdsContainerView.isHidden=true
                    offLineLabel.isHidden=false
                    offLineLabel.text=loadLanguage("设备已关机")
                    operation=(false,false,false)
                }else{
                    tdsContainerView.isHidden=false
                    offLineLabel.isHidden=true
                    tds=(device.sensor.TDS_Before,device.sensor.TDS_After)
                    operation=(device.status.Power,device.status.Hot,device.status.Cool)
                }
                
            }
        }
    }
    /*
    override func SensorUpdate(device: OznerDevice!) {
        //更新传感器视图
        if isBlueDevice {
            valueSlider.isEnabled = device.connectStatus() == Connected
            tdsContainerView.isHidden=false
            offLineLabel.isHidden=true
            tds=(Int((device as! ROWaterPurufier).waterInfo.tds1),Int((device as! ROWaterPurufier).waterInfo.tds2))
            print((device as! ROWaterPurufier).settingInfo.waterStopDate)
            if device.type == "Ozner RO" {
                waterDays=Int((device as! ROWaterPurufier).settingInfo.waterRemindDays)
            }
            if device.type == "RO Comml" {
                sumWater = canclueWater(Int((device as! ROWaterPurufier).waterInfo.waterml))
                
                if valueSlider.previewView != nil {
                    
                    valueSlider.value = Float((device as! ROWaterPurufier).twoInfo.hottempSet)
                    valueSlider.previewView?.frame = canclueFrame()
                    valueSlider.previewView?.changeValue(String.init(format: "%.0f", round(valueSlider.value)) + "℃")
                    
                } else {
                    valueSlider.value = Float((device as! ROWaterPurufier).twoInfo.hottempSet)
                    valueSlider.addSubview(valueSlider.creatGYTmpView(canclueFrame()))
                   
                    valueSlider.previewView?.changeValue(String.init(format: "%.0f", round(valueSlider.value)) + "℃")
                    
                }

            }
            
        }else{
            if (device as! WaterPurifier).isOffline
            {
                tdsContainerView.isHidden=true
                offLineLabel.isHidden=false
                offLineLabel.text=loadLanguage("设备云已断开")
                operation=(false,false,false)
            }else{
                if (device as! WaterPurifier).status.power==false {
                    tdsContainerView.isHidden=true
                    offLineLabel.isHidden=false
                    offLineLabel.text=loadLanguage("设备已关机")
                    operation=(false,false,false)
                }else{
                    tdsContainerView.isHidden=false
                    offLineLabel.isHidden=true
                    tds=(Int((device as! WaterPurifier).sensor.tds1),Int((device as! WaterPurifier).sensor.tds2))
                    operation=((device as! WaterPurifier).status.power,(device as! WaterPurifier).status.hot,(device as! WaterPurifier).status.cool)
                }
                
            }
        }
        
    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        //更新连接状态视图
        if isBlueDevice {
            tdsContainerView.isHidden=false
            offLineLabel.isHidden=true
            tds=(Int((device as! ROWaterPurufier).waterInfo.tds1),Int((device as! ROWaterPurufier).waterInfo.tds2))
        }else{
            if (device as! WaterPurifier).isOffline
            {
                tdsContainerView.isHidden=true
                offLineLabel.isHidden=false
                offLineLabel.text=loadLanguage("设备云已断开")
                operation=(false,false,false)
            }else{
                if (device as! WaterPurifier).status.power==false {
                    tdsContainerView.isHidden=true
                    self.offLineLabel.isHidden=false
                    self.offLineLabel.text=loadLanguage("设备已关机")
                    operation=(false,false,false)
                }else{
                    tdsContainerView.isHidden=false
                    self.offLineLabel.isHidden=true
                    tds=(Int((device as! WaterPurifier).sensor.tds1),Int((device as! WaterPurifier).sensor.tds2))
                    operation=((device as! WaterPurifier).status.power,(device as! WaterPurifier).status.hot,(device as! WaterPurifier).status.cool)
                }
                
            }
        }
    }
 */
    
    fileprivate func canclueWater(_ water:Int) -> String{
        
        switch water {
        case 0...1000:
            return "\(water)ml"
        case 1000...1000000:
            return String(format: "%.2f", Float(water)/1000.0) + "L"
        case 1000000...Int.max:
            return String(format: "%.2f", Float(water)/1000000.0) + "m³"
        default:
            break
        }
        return "0ml"
    }
}
