//
//  WaterPurifierMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurifierMainView: OznerDeviceView {

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
        if isBlueDevice==false {//wifi设备
            if (self.currentDevice as! WaterPurifier).isOffline {//断网状态
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
    
    @IBOutlet weak var lowBtn: UIButton!
    @IBOutlet weak var centerBtn: UIButton!
    
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var highBtn: UIButton!
    func setButtonEnable(timer:Timer) {
        (timer.userInfo as! UIButton).isEnabled=true
    }
    @IBAction func operationButtonClick(_ sender: UIButton) {
        
        if isBlueDevice {
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
            (self.currentDevice as! WaterPurifier).status.setPower(!operation.power, callback: { (error) in
            })
        case 1:
            if hotEnable {
                (self.currentDevice as! WaterPurifier).status.setHot(!operation.hot, callback: { (error) in
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
                (self.currentDevice as! WaterPurifier).status.setCool(!operation.cool, callback: { (error) in
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
        
        let device = currentDevice as? ROWaterPurufier
        lowBtn.isEnabled = false
        centerBtn.isEnabled = false
        highBtn.isEnabled = false
        currentBtn?.isEnabled = false
        switch sender.tag {
        case 5555:
            
            if (device?.setHotTemp(55))! {
                
                cornerBtn(sender)
                
            }
     
            
            break
        case 6666:
            
            if (device?.setHotTemp(80))! {
                cornerBtn(sender)
            }
            break
        case 7777:
            if (device?.setHotTemp(95))! {
                cornerBtn(sender)
            }
            break
        case 8888:
            let value = UserDefaults.standard.value(forKey: "UISliderValue") ?? 44
            device?.setHotTemp(value as! Int32)
            break
        default:
            break
        }
        lowBtn.isEnabled = true
        centerBtn.isEnabled = true
        highBtn.isEnabled = true
        currentBtn?.isEnabled = true
        
        if currentBtn != sender {
            if currentBtn != nil {
                
                btnBackColor(currentBtn!)

            }
            currentBtn = sender

        }
        
    }
    
    fileprivate func btnBackColor(_ sender:UIButton) {
        
        sender.layer.masksToBounds = false
        sender.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sender.layer.borderWidth = 0
    
    }
    
    fileprivate func cornerBtn(_ sender:UIButton) {
        
        sender.layer.cornerRadius = 20
        sender.layer.masksToBounds = true
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.init(hex: "48c2fa").cgColor
        sender.setTitleColor(UIColor.init(hex: "48c2fa"), for: UIControlState.normal)
        
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
            tdsValueLabel_BF.font = UIFont(name: ".SFUIDisplay-Thin", size: (tdsBF==0 ? 32:52)*width_screen/375)
            tdsValueLabel_AF.text = tdsAF==0 ? loadLanguage("暂无"):"\(tdsAF)"
            tdsValueLabel_AF.font = UIFont(name: ".SFUIDisplay-Thin", size: (tdsAF==0 ? 32:52)*width_screen/375)
            
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
    var waterDays:Int = -1{
        didSet{
            if waterDays != oldValue {
                waterDaysLabel.text="浩泽安全净水\(waterDays)天"
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
    
    override func SensorUpdate(device: OznerDevice!) {
        //更新传感器视图
        if isBlueDevice {
            tdsContainerView.isHidden=false
            offLineLabel.isHidden=true
            tds=(Int((device as! ROWaterPurufier).waterInfo.tds1),Int((device as! ROWaterPurufier).waterInfo.tds2))
            print((device as! ROWaterPurufier).settingInfo.waterStopDate)
            waterDays=Int((device as! ROWaterPurufier).settingInfo.waterRemindDays)
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
}
