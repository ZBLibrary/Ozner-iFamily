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
import SVProgressHUD
class WashDush_WifiMainView: OznerDeviceView,UIScrollViewDelegate {
    
    
    @IBOutlet var errorButton: UIButton!
    @IBAction func warnClick(_ sender: Any) {//警告单机
        let device=self.currentDevice as! WashDush_Wifi
        print(device.sensor.ErrorState)
        let errorMsg=["","请联系维修人员，电话请拨：400 920 9667","检查水龙头是否打开或水流量压力是否正常","检测门是否被异物卡住，如无异物请联系维修人员，电话请拨：400 920 9667","更换相对应图标闪烁的耗材","请联系维修人员，电话请拨：400 920 9667","请检查过滤网是否堵塞，如未堵塞请联系维修人员，电话请拨：400 920 9667","请联系维修人员，电话请拨：400 920 9667","请联系维修人员，电话请拨：400 920 9667","请使用正品洗碗机耗材，如未恢复正常请联系维修人员，电话请拨：400 920 9667"][device.sensor.ErrorState%256]
        let alertView = SCLAlertView()
        _ = alertView.addButton("我知道了", action: {})
        _ = alertView.showNotice("", subTitle: errorMsg)
    }
    @IBOutlet var washTitleLabel: UILabel!
    @IBOutlet var appointButton: UIButton!
    @IBAction func appointClick(_ sender: UIButton) {
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            alertError(code: 6)
            return
        }
        let device=self.currentDevice as! WashDush_Wifi
        if device.status.Lock {
            alertError(code: 0)
            return
        }else if device.status.Door {
            alertError(code: 1)
            return
        }else if !(device.sensor.WashState==Int(0x10)||device.sensor.WashState==Int(0x20)) {
            alertError(code: 3)
            return
        }
        let weakSelf=self
        
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
            SVProgressHUD.show(withStatus: "发送中...")
            SVProgressHUD.dismiss(withDelay: 2)
            weakSelf.washAppointTime.removeFromSuperview()
        }
        self.window?.addSubview(washAppointTime)
    }
    @IBOutlet var remindTimeView1: UIView!//动画
    @IBOutlet var remindTimeView2: UIView!
    @IBOutlet var remindTimeView3: UIView!
    @IBOutlet var remindTimeValue: UILabel!//min

    @IBOutlet var temperatView: UIView!//动画
    @IBOutlet var smallCircleView: UIView!
    @IBOutlet var smallCircleX: NSLayoutConstraint!
    @IBOutlet var smallCircleY: NSLayoutConstraint!
    @IBOutlet var temperatureLabel: UILabel!//温度
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tdsCircleView: WaterPurifierHeadCircleView!//tds圆环
    @IBOutlet var tdsBFLabel: UILabel!//tds前
    @IBOutlet var tdsAFLabel: UILabel!//tds后
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var consumableButton: UIButton!
    @IBAction func consumableClick(_ sender: Any) {//耗材界面
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            alertError(code: 6)
            return
        }
        self.delegate.DeviceViewPerformSegue!(SegueID: "showWashHaoCai", sender: nil)
    }
    @IBAction func DeviceSettingClick(_ sender: UIButton) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showTDSPanSetting", sender: nil)
    }
    @IBOutlet var controlButton1: UIButton!//电源
    @IBOutlet var controlButton2: UIButton!//开启／暂停
    @IBOutlet var controlButton3: UIButton!//童锁
    @IBOutlet var controlButton4: UIButton!//新风
    @IBAction func controlClick(_ sender: UIButton) {//控制按钮单机
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            alertError(code: 6)
            return
        }
        SVProgressHUD.show(withStatus: "发送中...")
        SVProgressHUD.dismiss(withDelay: 2)
        (self.currentDevice as! WashDush_Wifi).setControl(controlkey: sender.tag) { (error) in
            SVProgressHUD.dismiss()
            alertError(code: (error! as NSError).code)
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
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            alertError(code: 6)
            return
        }
        SVProgressHUD.show(withStatus: "发送中...")
        SVProgressHUD.dismiss(withDelay: 2)
        (self.currentDevice as! WashDush_Wifi).setModel(Model: sender.tag) { (error) in
            SVProgressHUD.dismiss()
            alertError(code: (error! as NSError).code)
        }
    }
    @IBAction func lastWashReport(_ sender: Any) {//上次洗涤报告
        if  self.currentDevice?.connectStatus != OznerConnectStatus.Connected{
            alertError(code: 6)
            return
        }
        self.delegate.DeviceViewPerformSegue!(SegueID: "showWashReport", sender: nil)
    }
    func alertError(code:Int) {
        let errorMsg=["请先关闭童锁",
                      "请先将门关闭",
                      "必须在待机、预约或运行状态下操作",
                      "必须在待机或预约状态下操作",
                      "不能空挡启动",
                      "必须在待机、预约或运行状态下操作",
                      "设备已断开连接"][code]
        let alertView=SCLAlertView()
        _=alertView.showTitle("", subTitle: errorMsg, duration: 2.0, completeText: "完成", style: SCLAlertViewStyle.notice)
    }
    @IBOutlet var lockWidth: NSLayoutConstraint!
    
    @IBOutlet var xinfengWidth: NSLayoutConstraint!
    @IBOutlet var model5Width: NSLayoutConstraint!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var washAppointTime:WashAppointTime!
    var remind1H:CGFloat!
    var cicleR:CGFloat!
    override func draw(_ rect: CGRect) {
        // Drawing code
        remind1H = ((height_screen-height_tabBar)*720/1166-214)/2
        cicleR = remind1H*125/205*86/108
        temperatView.layer.cornerRadius=remind1H*125/205
        remindTimeView1.layer.cornerRadius=remind1H
        remindTimeView2.layer.cornerRadius=remind1H*140/205
        remindTimeView3.layer.cornerRadius=remind1H*105/205
        appointButton.setTitle("--:--:--", for: .normal)
        washAppointTime=Bundle.main.loadNibNamed("WashAppointTime", owner: nil, options: nil)?.first as! WashAppointTime
        washAppointTime.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        washAppointTime.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        
        xinfengWidth.constant = -width_screen/4
        controlButton4.isHidden=true
        appointButton.isHidden=true
        switch (self.currentDevice?.deviceInfo.productID ?? "")! {
        case "edb7b978-6aca-11e7-9baf-00163e120d98":
            controlButton3.isHidden=true
            lockWidth.constant = -width_screen/4
            
            washModel5.isHidden=true
            model5Width.constant=0
            washModel7.isHidden=true
            
            break
        case "151e571a-6acb-11e7-9baf-00163e120d98":
            lockWidth.constant = width_screen/12
            break
        default:
            break
        }
        print(width_screen)
        if width_screen<=320 {
            
            temperatureLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 16)
            remindTimeValue.font=UIFont(name: ".SFUIDisplay-Thin", size: 20)
            temperatureLabel.setNeedsDisplay()
            remindTimeValue.setNeedsDisplay()
        }
        self.setNeedsDisplay()
        let ovalRadius = 172.5*remind1H/205//半径
        let layer = CAShapeLayer()
        layer.lineWidth = 6
        //圆环的颜色
        layer.strokeColor = UIColor.black.cgColor
        //背景填充色
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = kCALineCapRound
        //初始化一个路径
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: remind1H, y: remind1H), radius: ovalRadius, startAngle: 0.6*CGFloat(Double.pi), endAngle: 2.4*CGFloat(Double.pi), clockwise: true)
        
        layer.path = path.cgPath
        remindTimeView1.layer.addSublayer(layer)
        timeShapeLayer = CAShapeLayer()
        timeShapeLayer.lineWidth = 6
        //圆环的颜色
        timeShapeLayer.strokeColor = UIColor.orange.cgColor
        //背景填充色
        timeShapeLayer.fillColor = UIColor.clear.cgColor
        timeShapeLayer.lineCap = kCALineCapRound
        //初始化一个路径
        timeShapeLayer.path = UIBezierPath.init(arcCenter: CGPoint.init(x: remind1H, y: remind1H), radius: ovalRadius, startAngle: 0.6*CGFloat(Double.pi), endAngle: 0.6*CGFloat(Double.pi), clockwise: true).cgPath
        remindTimeView1.layer.addSublayer(timeShapeLayer)
        temperature=0
    }
    var timeShapeLayer:CAShapeLayer!
    func setTimeCircle(progress:CGFloat) {
        let ovalRadius = 172.5*remind1H/205//半径
        let endangle = 0.6*CGFloat(Double.pi)+progress*1.8*CGFloat(Double.pi)
        timeShapeLayer.removeFromSuperlayer()
        timeShapeLayer.path = UIBezierPath.init(arcCenter: CGPoint.init(x: remind1H, y: remind1H), radius: ovalRadius, startAngle: 0.6*CGFloat(Double.pi), endAngle: endangle, clockwise: true).cgPath
        remindTimeView1.layer.addSublayer(timeShapeLayer)
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
            temperatureLabel.text = temperature==0 || temperature == -1 ? "-":"\(temperature)"
            //加载温度动画temperatView
            //smallCircleView.isHidden=false
            
            let angle=CGFloat(Double.pi)*(2.7*CGFloat(temperature)+45)/180.0
            smallCircleY.constant = cicleR*cos(angle)
            smallCircleX.constant = -cicleR*sin(angle)
            
        }
    }
    var remindTime:(timeMin:Int,timePercent:Int) = (-1,-1){
        didSet{
            if remindTime==oldValue {
                return
            }
            remindTimeValue.text="\(remindTime.timeMin)"
            //加载remindTimeView1动画
            setTimeCircle(progress: 1-CGFloat(remindTime.timePercent)/100.0)
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
            //0 空档 1节能洗, 2:强劲洗，3日常洗，5奶瓶洗，4快速洗，6瓜果洗，7:自清洁，0空档，8自定义洗
            //print("新模式\(washModel)，旧模式\(oldValue)")
            if oldValue==0 {
                let newModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][washModel-1] as UIButton
                newModelBtn.setTitleColor(modelSelectColor, for: .normal)
                newModelBtn.setImage(UIImage.init(named: modelIMGName[washModel-1]+"ED"), for: .normal)
            }else{
                let oldModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][oldValue-1] as UIButton
                oldModelBtn.setTitleColor(unselectColor, for: .normal)
                oldModelBtn.setImage(UIImage.init(named: modelIMGName[oldValue-1]), for: .normal)
                
                if washModel != 0 {
                    let newModelBtn=[washModel1,washModel2,washModel3,washModel4,washModel5,washModel6,washModel7][washModel-1] as UIButton
                    newModelBtn.setTitleColor(modelSelectColor, for: .normal)
                    newModelBtn.setImage(UIImage.init(named: modelIMGName[washModel-1]+"ED"), for: .normal)
                }
            }
        }
        
        
    }
    
    
    let washState:[Int:String] = [Int(0x00):"关机",Int(0x10):"待机",Int(0x20):"预约",Int(0x30):"运行",Int(0x40):"故障",Int(0x50):"预留",Int(0x60):"预留",Int(0x70):"预留",Int(0x80):"在线检1",Int(0x90):"在线检2"]
    var error = -1{
        didSet{
            if error==oldValue {
                return
            }
            errorButton.isHidden = error%256==0
            if errorButton.isHidden {
                stopErrorAnimal()
            }else{
                starErrorAnimal()
            }
        }
    }
    var errorTimer:Timer?
    func errorAnimal()  {
        errorButton.setImage(errorButton.image(for: .normal)==nil ? UIImage.init(named: "警告图标"):nil, for: .normal)
    }
    func starErrorAnimal()  {
        errorTimer?.invalidate()
        errorTimer = nil
        errorTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(errorAnimal), userInfo: 0, repeats: true)
        RunLoop.main.add(errorTimer!, forMode: RunLoopMode.commonModes)
    }
    func stopErrorAnimal()  {
        errorTimer?.invalidate()
        errorTimer = nil
    }
    var filterValue = -1{
        didSet{
            if filterValue==oldValue {
                return
            }
            if self.currentDevice?.connectStatus != .Connected{
                consumableButton.setImage(UIImage.init(named: "滤芯及耗材"), for: .normal)
                stopfilterAnimal()
                return
            }
            consumableButton.setImage(UIImage.init(named: filterValue<=0 ? "滤芯及耗材":"滤芯及耗材缺乏"), for: .normal)
            filterValue<=0 ? stopfilterAnimal():starfilterAnimal()
        }
    }
    var filterTimer:Timer?
    func filterAnimal()  {
        consumableButton.setImage(consumableButton.image(for: .normal)==nil ? UIImage.init(named: "滤芯及耗材缺乏"):nil, for: .normal)
        
    }
    func starfilterAnimal()  {
        filterTimer?.invalidate()
        filterTimer = nil
        filterTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(filterAnimal), userInfo: 0, repeats: true)
        RunLoop.main.add(filterTimer!, forMode: RunLoopMode.commonModes)
    }
    func stopfilterAnimal()  {
        filterTimer?.invalidate()
        filterTimer = nil
    }

    //数据回掉处理
    override func SensorUpdate(identifier: String) {
        let device = self.currentDevice as! WashDush_Wifi
        temperature = device.sensor.Temperature
        remindTime=(device.sensor.RemindTime,device.sensor.RemindPercent)
        washTitleLabel.text="洗碗  "+washState[device.sensor.WashState]!
        error=device.sensor.ErrorState
        
    }
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        let device = self.currentDevice as! WashDush_Wifi
        control=(device.status.Power,device.status.OnOff,device.status.Lock,device.status.NewTrend)
        washModel=device.status.WashModel
    }

    override func FilterUpdate(identifier: String) {
        let filterStatus = (self.currentDevice as! WashDush_Wifi).filterStatus
        let time=filterStatus.AppointTime
        appointButton.setTitle("\(time/60):\(time%60):00", for: .normal)
        if filterStatus.jingjie<=0||filterStatus.jingshui<=0||filterStatus.ruanshui<=0||filterStatus.liangjie<=0 {
            filterValue=1
        }else{
            filterValue=0
        }
        
    }
}
