//
//  ElectrickettleMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/7/19.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/19  上午10:42
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ElectrickettleMainView: OznerDeviceView {
    
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var lineView: CupHeadCircleView!
    @IBOutlet weak var progressView: GYProgressView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var segement: UISegmentedControl!
    
    var currentTempBtn:UIButton?
    var currentHotBtn:UIButton?
    var pickDateView:TapDatePickerView?
    var isFirst:Bool = true
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var valuelb: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switchlb: UISwitch!
    @IBOutlet weak var firstContraint: NSLayoutConstraint!
    @IBOutlet weak var tmepLb: UILabel!
    @IBOutlet weak var secondContrains: NSLayoutConstraint!
    
    @IBOutlet weak var tempValue: GYValueElectSlider!
    @IBOutlet weak var patternLb: UILabel!
    
    @IBOutlet weak var circleView: CupHeadCircleView!
    @IBOutlet weak var tdsImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    @IBOutlet var tdsValueLabel: UILabel!
    @IBOutlet var tdsBeatLabel: UILabel!

    @IBOutlet weak var settimeBtn: UIButton!
    
    var tempLbtext:(temp:Int,pattern:Int) = (-1,-1) {
        
        didSet {
            
            if tempLbtext != oldValue {
                
                tmepLb.text = String(tempLbtext.temp) + "℃"
                
                switch tempLbtext.pattern {
                case 0:
                    patternLb.text = "待机中"
                    break
                case 1:
                    patternLb.text = "加热中"
                    break
                case 2:
                    patternLb.text = "保温中"
                    break
                default:
                    patternLb.text = "未知"
                    break
                }
                
            }
            
        }
        
    }
    
    private var TDS = 0{
        didSet{
            if TDS != oldValue   {
                if TDS<=0 || TDS == 65535 {//暂无
                    tdsImg.image=UIImage(named: "baobiao")
                    tdsStateLabel.text="-"
                    tdsValueLabel.text=loadLanguage("暂无")
                    tdsBeatLabel.text=""
                    return
                }
                tdsValueLabel.text="\(TDS)"
                var angle = CGFloat(0)
                switch true {
                case TDS<=Int(tds_good):
                    tdsImg.image=UIImage(named: "baobiao")
                    tdsStateLabel.text=loadLanguage("好")
                    angle=CGFloat(TDS)/CGFloat(tds_good*3)
                case TDS>Int(tds_good)&&TDS<=Int(tds_bad):
                    tdsImg.image=UIImage(named: "yiban")
                    tdsStateLabel.text=loadLanguage("一般")
                    angle=CGFloat(TDS-Int(tds_good))/CGFloat((tds_bad-tds_good)*3)+0.33
                case TDS>Int(tds_bad)&&TDS<Int(tds_bad+50):
                    tdsImg.image=UIImage(named: "cha")
                    tdsStateLabel.text=loadLanguage("偏差")
                    angle=CGFloat(TDS-Int(tds_bad))/CGFloat(50*3)+0.66
                default:
                    tdsImg.image=UIImage(named: "cha")
                    tdsStateLabel.text=loadLanguage("偏差")
                    angle=1.0
                    break
                }
                circleView.updateCircleView(angle: angle)
          
            }
        }
    }

    @IBAction func setTimeAction(_ sender: UIButton) {
        
        UIApplication.shared.keyWindow?.addSubview(datePick)
        let device = currentDevice as? Electrickettle_Blue

        datePick.didFinishSelect = { [weak self] (date) in

            self?.settimeBtn.setTitle((date.gy2_stringFromDate(dateFormat: "dd") == Date().gy_stringFromDate(dateFormat: "dd") ? "今天" : "明天") + (date.gy2_stringFromDate(dateFormat: " HH:mm") ), for: UIControlState.normal)
            
            let time = date.timeIntervalSinceNow
            let seconds = lround(time/60)  - (60 * 8)
            
            _ = device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 0 , hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: 1, orderSec: seconds))

        }
        
        
        datePick.showInView()
        
//        pickDateView=Bundle.main.loadNibNamed("TapDatePickerView", owner: nil, options: nil)?.last as? TapDatePickerView
//        pickDateView?.datePicker.minimumDate = Date.init()
//        pickDateView?.datePicker.datePickerMode = .time
//        
//        pickDateView?.datePicker.maximumDate = Date.init(timeIntervalSinceNow: 24 * 60 * 60)
//        pickDateView?.datePicker.datePickerMode = .dateAndTime
//        pickDateView?.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen - 64)
//        pickDateView?.cancelButton.addTarget(self, action: #selector(pickerCancle), for: .touchUpInside)
//        pickDateView?.OKButton.addTarget(self, action: #selector(pickerOK), for: .touchUpInside)
//        self.addSubview(pickDateView!)
    }
        
    func pickerOK() {
        let date = pickDateView?.datePicker.date
        
        settimeBtn.setTitle((date?.gy2_stringFromDate(dateFormat: "dd") == Date().gy_stringFromDate(dateFormat: "dd") ? "今天" : "明天") + (date?.gy2_stringFromDate(dateFormat: " HH:mm") ?? ""), for: UIControlState.normal)
        
        let time = date?.timeIntervalSinceNow
        print(lround(time!/60))
        pickDateView?.removeFromSuperview()
    }
    
    @IBAction func tempChange(_ sender: UIButton) {
        
        let device = currentDevice as? Electrickettle_Blue
        
        if device?.connectStatus != OznerConnectStatus.Connected {
            return
        }
        
        if currentTempBtn?.tag == sender.tag {
            UIView.animate(withDuration: 0.5) {
                
                self.currentTempBtn?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                self.currentTempBtn?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                self.currentTempBtn = nil
            }
            
            if sender.tag == 666 {
                
                secondContrains.constant = 120
                tempValue.isHidden = true
            }
            
            return
        }
        
        if sender.tag == 666{
            
            secondContrains.constant = 170
            tempValue.isHidden = false
            let value = UserDefaults.standard.value(forKey: "UISliderValueElectrickettle") ?? 0
            tempValue.value = Float(value as! Int)
            
        } else {
            tempValue.isHidden = true
            secondContrains.constant = 120
        }
        
        if sender.tag != 666 {
            
            let device = currentDevice as? Electrickettle_Blue
            
            _ = device?.setSetting((hotTemp: sender.tag , hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
            
        }
        
        switch sender.tag {
        case 90:
            currentTemp.text = "90℃适合泡咖啡"
            break
        case 80:
            currentTemp.text = "80℃适合泡绿茶"
            break
        case 70:
            currentTemp.text = "70℃适合冲米粉"
            break
        case 60:
            currentTemp.text = "60℃适合泡牛奶"
            break
        default:
            currentTemp.text = ""
            break
        }
        
        UIView.animate(withDuration: 0.5) {
        
            self.currentTempBtn?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            self.currentTempBtn?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            
        }
        currentTempBtn = sender
        
        UIView.animate(withDuration: 0.5) { 
            
            sender.transform = CGAffineTransform(a: 1.3, b: 0, c: 0, d: 1.3, tx: 0, ty: 0)
            sender.setTitleColor(UIColor.init(red: 168/255.0, green: 40/255.0, blue: 102/255.0, alpha: 1.0), for: UIControlState.normal)
        }
        
    }
 
    @IBAction func hotAction(_ sender: UIButton) {
        
        let device = currentDevice as? Electrickettle_Blue
        
        if device?.connectStatus != OznerConnectStatus.Connected {
            
            return
        }
        
        if currentHotBtn?.tag == sender.tag {
   
            return
        }
        
        switch sender.tag {
        case 777:
//            _ = device?.setHotFunction(0)
             _ = device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 40 , hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))

            break
        case 888:
//            _ = device?.setHotFunction(1)
             _ = device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 40 , hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: 1 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
            
            break
        default:
            break
        }
        
        
        UIView.animate(withDuration: 0.5) {
            
            self.currentHotBtn?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            self.currentHotBtn?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            
        }
        currentHotBtn = sender
        
        UIView.animate(withDuration: 0.5) {
            
            sender.transform = CGAffineTransform(a: 1.3, b: 0, c: 0, d: 1.3, tx: 0, ty: 0)
            sender.setTitleColor(UIColor.init(red: 168/255.0, green: 40/255.0, blue: 102/255.0, alpha: 1.0), for: UIControlState.normal)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gylayoutSubviews()
    }
    
    func sliderValueChanged(_ sender:UISlider) {
        
//        String.init(format: "%0.1f", sender.value)
        
        valuelb.text = "持续保温\(String.init(format: "%0.1f", sender.value))小时"
        let device = currentDevice as? Electrickettle_Blue
        
        if device?.settingInfo.hotTemp == -1{
            return
        }
        
        _ = device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 0, hotTime: Int(sender.value * 60.0), boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: device?.settingInfo.hotPattern ?? 0 , orderFunction: device?.settingInfo.orderFunction ?? 0, orderSec: device?.settingInfo.orderSec ?? 0))
        
    }
    
    func segmentedChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            UIView.transition(with: headView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.lineView.isHidden = true
                self.progressView.isHidden = false
                self.progressView.startAnimation()
                
            }, completion: { (finished) in
                
            })
            
            break
        case 1:
            UIView.transition(with: headView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                
                self.progressView.stopanimation()
                self.progressView.isHidden = true
                self.progressView.upperShapeLayer?.strokeEnd = 0
                self.progressView.upperShapeLayer1?.strokeEnd = 0
                self.lineView.isHidden = false
                
            }, completion: { (finished) in
                
            })
            
            break
        default:
            break
        }
        
    }
    
    func switchChanged(_ sender:UISwitch) {
        
        settimeBtn.isHidden = !sender.isOn
        let device = currentDevice as? Electrickettle_Blue

        if sender.isOn {
            
            self.noticeOnlyText("请设置预约时间")
            firstContraint.constant = 120
            
        } else {
            
            firstContraint.constant = 60
            _ =  device?.setSetting((hotTemp: device?.settingInfo.hotTemp ?? 0, hotTime: device?.settingInfo.hotTime ?? 0, boilTemp: device?.settingInfo.orderTemp ?? 0, hotFunction: 0 , orderFunction: 0, orderSec: 0))
            settimeBtn.setTitle("--:--", for: UIControlState.normal)
         
            self.noticeOnlyText("预约时间已取消")
        }
        
        self.perform(#selector(ElectrickettleMainView.gylayoutSubviews), with: nil, afterDelay: 1, inModes: [RunLoopMode.commonModes])
        
    }

    override func SensorUpdate(identifier: String) {
        
        let currentDevice=OznerManager.instance.currentDevice as! Electrickettle_Blue
        
        tempLbtext = (currentDevice.settingInfo.temp,currentDevice.settingInfo.isHot)
        
        TDS = currentDevice.settingInfo.tds
        switchlb.isEnabled = (currentDevice.connectStatus == .Connected)

        slider.isEnabled = (currentDevice.connectStatus == .Connected)
        
        setUIInfo(currentDevice)
        
        print(currentDevice.settingInfo)
        
    }
    
    private func setUIInfo(_ currentDevice:Electrickettle_Blue) {
     
        if isFirst && currentDevice.settingInfo.orderFunction ==  1 && (currentDevice.connectStatus == .Connected) {
            
            isFirst = false
            switchlb.isEnabled = true
            switchlb.isOn = true
            settimeBtn.isHidden = false
            firstContraint.constant = 120
            
            let date = Date(timeIntervalSinceNow: TimeInterval(currentDevice.settingInfo.orderSec * 60))
            settimeBtn.setTitle((date.gy_stringFromDate(dateFormat: "dd") == Date().gy_stringFromDate(dateFormat: "dd") ? "今天" : "明天") + (date.gy_stringFromDate(dateFormat: " HH:mm")), for: UIControlState.normal)
            
            self.perform(#selector(ElectrickettleMainView.gylayoutSubviews), with: nil, afterDelay: 1, inModes: [RunLoopMode.commonModes])
            
        }
        
        //Value设置
        if currentDevice.settingInfo.orderFunction == 0   {
            valuelb.text = "持续保温0小时"
            slider.value = 0.0
        } else if currentDevice.settingInfo.orderSec > 0 {
            let time = String.init(format: "%.1f",currentDevice.settingInfo.hotTime/60)
            
            valuelb.text = "持续保温\(time))小时"
            slider.value = Float(time)!
        } else {
            
            let time = String.init(format: "%.1f",currentDevice.settingInfo.hotSurplusTime/60)
            
            valuelb.text = "持续保温\(time))小时"
            slider.value = Float(time)!
            
        }
        
    }
    
    
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {

    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.isHidden = true
        lineView.layer.masksToBounds = true
        lineView.layer.cornerRadius = 10
        scrollerView.bounces = true
        progressView.startAnimation()
        segement.addTarget(self, action: #selector(ElectrickettleMainView.segmentedChanged(_:)), for: UIControlEvents.valueChanged)
        switchlb.addTarget(self, action:#selector(ElectrickettleMainView.switchChanged(_:)), for: UIControlEvents.valueChanged)
        
//        slider.addTarget(self, action: #selector(ElectrickettleMainView.sliderValueChangedEnd), for: UIControlEvents.touchCancel)

        slider.addTarget(self, action: #selector(ElectrickettleMainView.sliderValueChanged(_:)), for: UIControlEvents.touchUpInside)
        
        tempValue.minimumValue = 0
        tempValue.maximumValue = 100
        tempValue.isEnabled = true
        tempValue.layer.sublayers?.removeAll()
        switchlb.isEnabled = false
        
    }
    
     func gylayoutSubviews() {
        
        scrollerView.contentSize = CGSize(width: width_screen, height: 560)
        
    }
    
    fileprivate lazy var datePick:AbbDatePickView = {
        let minDate = Date.init()
        let maxDate = Date.init(timeIntervalSinceNow: 24 * 60 * 60)
        let dp = AbbDatePickView(cornorType: CornorType.circle, minDate: minDate, maxDate: maxDate, showOnlyValidDates: true)
        return dp
    }()


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
