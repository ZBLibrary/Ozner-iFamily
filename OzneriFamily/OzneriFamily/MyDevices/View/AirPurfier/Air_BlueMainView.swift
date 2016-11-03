//
//  Air_BlueMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/16.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class Air_BlueMainView: OznerDeviceView {

    
    @IBOutlet var pm25StateLabel: UILabel!
    @IBOutlet var pm25ValueLabel: UILabel!
    @IBOutlet var temperatureValueLabel: UILabel!
    @IBOutlet var humidityValueLabel: UILabel!
    @IBOutlet var FLZLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var pollutionLabel: UILabel!
    @IBOutlet var outdoorPM25Label: UILabel!
    @IBOutlet var circleBGimg: UIImageView!
    @IBAction func seeOutdoorAirClick(_ sender: AnyObject) {
    }
    
    
    @IBOutlet var sliderTouchView: UIView!
    @IBOutlet var sliderImgWidth: NSLayoutConstraint!
    @IBOutlet var sliderShowValueViewToRight: NSLayoutConstraint!
    @IBOutlet var sliderShowValueView: UIView!
    @IBOutlet var sliderValueLabel: UILabel!
    @IBOutlet var sliderValueStateLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        sliderShowValueView.layer.shadowColor=UIColor(red: 0, green: 104/255, blue: 246/255, alpha: 1).cgColor
        sliderShowValueView.layer.shadowOffset=CGSize(width: 0, height: 0)//阴影偏移量
        //添加拖动手势
        let panGesture=UIPanGestureRecognizer(target: self, action: #selector(panImage))
        sliderTouchView.addGestureRecognizer(panGesture)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(tapImage))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        sliderTouchView.addGestureRecognizer(tapGesture)
        var tmpValue=CGFloat((currentDevice as! AirPurifier_Bluetooth).status.rpm)/100
        tmpValue=34.5*width_screen/375+tmpValue*264*width_screen/375
        updateSpeed(touchX: tmpValue, isEnd: false)
        // Drawing code
    }
    
    func panImage(_ gesture:UIPanGestureRecognizer)
    {
        let tapPoint:CGPoint = gesture.location(in: sliderTouchView)
        updateSpeed(touchX: tapPoint.x, isEnd: gesture.state == UIGestureRecognizerState.ended)
    }
    
    func tapImage(_ gesture:UITapGestureRecognizer)
    {
        if (gesture.state == UIGestureRecognizerState.ended) {
            if (gesture.numberOfTouches <= 0) {
                return
            }
            let tapPoint:CGPoint = gesture.location(ofTouch: 0, in: sliderTouchView)
            updateSpeed(touchX: tapPoint.x, isEnd: true)
        }
    }
    private func updateSpeed(touchX:CGFloat,isEnd:Bool){
        if currentDevice?.connectStatus() != Connected {
            pm25ValueLabel.text="设备已断开"
            FLZLabel.isHidden=true
            pm25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 35*width_screen/320)
            updateSliderView(touchX: 0, isEnd: isEnd)
        }else{
            updateSliderView(touchX: touchX, isEnd: isEnd)
        }
        
        
    }
    //264,333
    //0-333,触碰点范围
    //34.5-298.5 中心点范围
    private func updateSliderView(touchX:CGFloat,isEnd:Bool) {//底部视图
        var needValue=max(34.5*width_screen/375, touchX)
        needValue=min(298.5*width_screen/375, needValue)
        sliderImgWidth.constant=needValue-34.5*width_screen/375
        sliderShowValueViewToRight.constant=333*width_screen/375-needValue-30
        let tmpValue = (needValue-34.5*width_screen/375)/(264*width_screen/375)
        let tmpValueInt=Int(100*tmpValue)
        sliderValueLabel.text="\(tmpValueInt)"
        switch true {
        case tmpValueInt==0:
            sliderValueStateLabel.text="关机"
        case tmpValueInt>0&&tmpValueInt<=33:
            sliderValueStateLabel.text="低速"
        case tmpValueInt>33&&tmpValueInt<=66:
            sliderValueStateLabel.text="中速"
        default:
            sliderValueStateLabel.text="高速"
        }
        if isEnd==true {
            
            (self.currentDevice as! AirPurifier_Bluetooth).status.setPower(tmpValueInt != 0, callback: { (error) in
            })
            (self.currentDevice as! AirPurifier_Bluetooth).status.setRPM(Int32(tmpValueInt), callback: { (error) in
            })
        }
    }
    private var PM25_In = 0{//头部视图
        didSet{
            if PM25_In != oldValue   {
                if (self.currentDevice as! AirPurifier_Bluetooth).status.power==false {
                    pm25ValueLabel.text="已关机"
                    pm25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 35*width_screen/375)
                    FLZLabel.isHidden=true
                    updateSpeed(touchX: 0, isEnd: false)
                    return
                }
                pm25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 55*width_screen/375)
                if PM25_In<=0 || PM25_In == 65535 {//暂无
                    pm25ValueLabel.text="-"
                    return
                }
                FLZLabel.isHidden=false
                pm25ValueLabel.text="\(PM25_In)"
                temperatureValueLabel.text="\((self.currentDevice as! AirPurifier_Bluetooth).sensor.temperature)℃"
                humidityValueLabel.text="\((self.currentDevice as! AirPurifier_Bluetooth).sensor.humidity)%"
                switch true {
                case PM25_In<=75:
                    
                    circleBGimg.image=UIImage(named: "GuangHuanbg")
                    pm25StateLabel.text=loadLanguage("优")
                    self.backgroundColor=UIColor(red: 94/255, green: 207/255, blue: 254/255, alpha: 1)
                case PM25_In>75&&PM25_In<=150:
                    circleBGimg.image=UIImage(named: "GuangHuanbg2")
                    pm25StateLabel.text=loadLanguage("良")
                     self.backgroundColor=UIColor(red: 163/255, green: 129/255, blue: 251/255, alpha: 1)
                case PM25_In>150:
                    circleBGimg.image=UIImage(named: "GuangHuanbg3")
                    pm25StateLabel.text=loadLanguage("差")
                     self.backgroundColor=UIColor(red: 254/255, green: 101/255, blue: 101/255, alpha: 1)
                default:
                    break
                }
               
                
            }
        }
    }

    override func SensorUpdate(device: OznerDevice!) {
        self.currentDevice=device
        //更新传感器视图
        if (self.currentDevice as! AirPurifier_Bluetooth).status.power==false
        {
            PM25_In=0
        }else{
            PM25_In=Int((self.currentDevice as! AirPurifier_Bluetooth).sensor.pm25)
        }
        
        
    }
    var connectChange = Disconnect{
        didSet{
            if connectChange==oldValue {
                return
            }
            var tmpValue=CGFloat(0)
            switch connectChange {
            case Connected:
                tmpValue=CGFloat((currentDevice as! AirPurifier_Bluetooth).status.rpm)/100
                tmpValue=34.5*width_screen/375+tmpValue*264*width_screen/375
            default:
                break
            }
            updateSpeed(touchX: tmpValue, isEnd: false)
        }
    }
    
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        self.currentDevice=device
        //更新连接状态视图
        connectChange=device.connectStatus()
    }
}
