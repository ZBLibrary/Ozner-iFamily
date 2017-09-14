//
//  WashDush_WifiMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/8/9.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/8/9  下午2:06
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class WashDush_WifiMainView: OznerDeviceView,UIScrollViewDelegate {
    
    
    @IBOutlet var errorButton: UIButton!
    @IBAction func warnClick(_ sender: Any) {//警告单机
        let device=self.currentDevice as! WashDush_Wifi
        let errorMsg=["","溢流报警","进水异常","门电机/门开关故障","耗材更换报警","BLDC故障","加热异常","热敏电阻开路/短路","耗材模块漏水报警","防伪异常"][device.sensor.ErrorState]
        let alertView = SCLAlertView()
        _ = alertView.addButton("我知道了", action: {})
        _ = alertView.showError("警告信息", subTitle: errorMsg)
    }
    @IBOutlet var washTitleLabel: UILabel!
    @IBOutlet var appointButton: UIButton!
    @IBAction func appointClick(_ sender: UIButton) {
        let weakSelf=self
        let device=self.currentDevice as! WashDush_Wifi
        washAppointTime.setTime=device.filterStatus.AppointTime
        washAppointTime.setModel=device.filterStatus.AppointModel
        washAppointTime.callBack={( appoint:(model:Int,time:Int)?)->() in
            if appoint==nil {
                device.setAppoint(IsOpen: false, time: 0, model: 0, callBack: { (error) in
                    
                })
            }else{
                device.setAppoint(IsOpen: true, time: (appoint?.time)!, model: (appoint?.model)!, callBack: { (error) in
                    
                })
            }
            
            weakSelf.washAppointTime.removeFromSuperview()
        }
        self.window?.addSubview(washAppointTime)
    }
    @IBOutlet var remindTimeView1: UIView!//动画
    @IBOutlet var remindTimeView2: UIView!
    @IBOutlet var remindTimeView3: UIView!
    @IBOutlet var remindTimeValue: UILabel!//min

    @IBOutlet var temperatView: UIView!//动画
    @IBOutlet var temperatureLabel: UILabel!//温度
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tdsCircleView: WaterPurifierHeadCircleView!//tds圆环
    @IBOutlet var tdsBFLabel: UILabel!//tds前
    @IBOutlet var tdsAFLabel: UILabel!//tds后
    @IBOutlet var pageControl: UIPageControl!
    
    @IBAction func consumableClick(_ sender: Any) {//耗材界面
    }
    @IBOutlet var controlButton1: UIButton!//电源
    @IBOutlet var controlButton2: UIButton!//开启／暂停
    @IBOutlet var controlButton3: UIButton!//童锁
    @IBOutlet var controlButton4: UIButton!//新风
    @IBAction func controlClick(_ sender: UIButton) {//控制按钮单机
        (self.currentDevice as! WashDush_Wifi).setControl(controlkey: sender.tag) { (error) in
        }
    }
    
    
    @IBOutlet var washModel1: UIButton!//强劲
    @IBOutlet var washModel2: UIButton!//日常
    @IBOutlet var washModel3: UIButton!//节能
    @IBOutlet var washModel4: UIButton!//快速
    @IBOutlet var washModel5: UIButton!//瓜果
    @IBOutlet var washModel6: UIButton!//奶瓶
    @IBOutlet var washModel7: UIButton!//清洁
    @IBAction func washModelClick(_ sender: UIButton) {
        (self.currentDevice as! WashDush_Wifi).setModel(Model: sender.tag) { (error) in            
        }
    }
    @IBAction func lastWashReport(_ sender: Any) {//上次洗涤报告
        
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var washAppointTime:WashAppointTime!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
       temperatView.layer.cornerRadius=temperatView.frame.height/2
        remindTimeView1.layer.cornerRadius=remindTimeView1.frame.height/2
        remindTimeView2.layer.cornerRadius=remindTimeView2.frame.height/2
        remindTimeView3.layer.cornerRadius=remindTimeView3.frame.height/2
        appointButton.setTitle("--:--:--", for: .normal)
        washAppointTime=Bundle.main.loadNibNamed("WashAppointTime", owner: nil, options: nil)?.first as! WashAppointTime
        washAppointTime.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        washAppointTime.backgroundColor=UIColor.black.withAlphaComponent(0.5)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x)/scrollView.frame.size.width);
        pageControl.currentPage = page
    }
    
    
    var temperature = -1{
        didSet{
            if temperature==oldValue {
                return
            }
            temperatureLabel.text="\(temperature)"
            //加载温度动画temperatView
            
        }
    }
    var remindTime:(timeMin:Int,timePercent:Int) = (-1,-1){
        didSet{
            if remindTime==oldValue {
                return
            }
            remindTimeValue.text="\(remindTime.timeMin)"
            //加载remindTimeView1动画
            
        }
    }
    let unselectColor = UIColor.init(hex: "bebdbe")
    let controlSelectColor = UIColor.init(hex: "5a76ef")
    let modelSelectColor = UIColor.init(hex: "64f2fe")
    var control:(power:Bool,onoff:Bool,lock:Bool,newtrend:Bool) = (false,false,false,false){
        didSet{
            if control==oldValue {
                return
            }
            if control.power != oldValue.power {
                controlButton1.setTitleColor(control.power ? controlSelectColor:unselectColor, for: .normal)
                controlButton1.setImage(UIImage.init(named: control.power ? "电源开关ED":"电源开关"), for: .normal)
            }
            if control.onoff != oldValue.onoff {
                controlButton2.setTitleColor(control.onoff ? controlSelectColor:unselectColor, for: .normal)
                controlButton2.setImage(UIImage.init(named: control.onoff ? "开启暂停ED":"开启暂停"), for: .normal)
            }
            if control.lock != oldValue.lock {
                controlButton3.setTitleColor(control.lock ? controlSelectColor:unselectColor, for: .normal)
                controlButton3.setImage(UIImage.init(named: control.lock ? "童锁ED":"童锁"), for: .normal)
            }
            if control.newtrend != oldValue.newtrend {
                controlButton4.setTitleColor(control.newtrend ? controlSelectColor:unselectColor, for: .normal)
                controlButton4.setImage(UIImage.init(named: control.newtrend ? "新风ED":"新风"), for: .normal)
            }
        }
    }
    let modelIMGName = ["节能洗","强劲洗","日常洗","快速洗","奶瓶洗","瓜果洗","自清洁"]
    
    var washModel = 0{
        didSet{
            if washModel==oldValue {
                return
            }
            //2:强劲洗，3日常洗，1节能洗，4快速洗，6瓜果洗，5奶瓶洗，7:自清洁，0空档，8自定义洗
            
            if oldValue==0 {
                let newModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][washModel] as UIButton
                newModelBtn.setTitleColor(modelSelectColor, for: .normal)
                newModelBtn.setImage(UIImage.init(named: modelIMGName[washModel]+"ED"), for: .normal)
            }else{
                let oldModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][oldValue] as UIButton
                oldModelBtn.setTitleColor(unselectColor, for: .normal)
                oldModelBtn.setImage(UIImage.init(named: modelIMGName[oldValue]), for: .normal)
                
                if washModel != 0 {
                    let newModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][washModel] as UIButton
                    newModelBtn.setTitleColor(modelSelectColor, for: .normal)
                    newModelBtn.setImage(UIImage.init(named: modelIMGName[oldValue]+"ED"), for: .normal)
                }
            }
        }
        
        
    }
    
    let washState = [Int(0x00):"关机",Int(0x10):"待机",Int(0x20):"预约",Int(0x30):"运行",Int(0x40):"故障",Int(0x50):"预留",Int(0x60):"预留",Int(0x70):"预留",Int(0x80):"在线检1",Int(0x90):"在线检2"]
    var error = 0{
        didSet{
            if error==oldValue {
                return
            }
        }
    }
    
    //数据回掉处理
    override func SensorUpdate(identifier: String) {
        let device = self.currentDevice as! WashDush_Wifi
        temperature = device.sensor.Temperature
        remindTime=(device.sensor.RemindTime,device.sensor.RemindPercent)
        washTitleLabel.text="洗碗机  "+washState[device.sensor.WashState]!
        error=device.sensor.ErrorState
    }
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        let device = self.currentDevice as! WashDush_Wifi
        control=(device.status.Power,device.status.OnOff,device.status.Lock,device.status.NewTrend)
        washModel=device.status.WashModel
    }

    override func FilterUpdate(identifier: String) {
        let device = self.currentDevice as! WashDush_Wifi
        let time=device.filterStatus.AppointTime
        appointButton.setTitle("\(time/60):\(time%60):00", for: .normal)
    }
}
