//
//  Air_BlueMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/16.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import UICountingLabel

class Air_BlueMainView: OznerDeviceView {

    
    @IBOutlet var pm25StateLabel: UILabel!
    @IBOutlet var pm25ValueLabel: UICountingLabel!
    @IBOutlet var temperatureValueLabel: UILabel!
    @IBOutlet var humidityValueLabel: UILabel!
    @IBOutlet var FLZLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var pollutionLabel: UILabel!
    @IBOutlet var outdoorPM25Label: UILabel!
    @IBOutlet var circleBGimg: UIImageView!
    
    @IBAction func SeeLvXinClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showAirLvXin", sender: nil)
    }
    
    @IBAction func seeOutdoorAirClick(_ sender: AnyObject) {
        weak var weakself=self
        User.GetWeather(success: { (pollution, city, pm25, aqi, temp, himid, dataFrom) in
            weakself?.cityLabel.text=city
            weakself?.pollutionLabel.text=pollution
            weakself?.outdoorPM25Label.text = pm25==0 ? "-":"\(pm25)"
            
            weakself?.outdoorAirView.updateView(city: city, pm25: pm25, AQI: aqi, temp: temp, himit: himid, from: dataFrom, callback: {
                weakself?.outdoorAirView.removeFromSuperview()
            })
            weakself?.window?.addSubview((weakself?.outdoorAirView)!)
            }, failure: { (error) in
                
        })
    }
    
    
    @IBOutlet var sliderTouchView: UIView!
    @IBOutlet var sliderImgWidth: NSLayoutConstraint!
    @IBOutlet var sliderShowValueViewToRight: NSLayoutConstraint!
    @IBOutlet var sliderShowValueView: UIView!
    @IBOutlet var sliderValueLabel: UILabel!
    @IBOutlet var sliderValueStateLabel: UILabel!
    var outdoorAirView:AirOutdoorView!
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
        var tmpValue=CGFloat((currentDevice as! AirPurifier_Blue).sensor.Speed)/100
        tmpValue=34.5*width_screen/375+tmpValue*264*width_screen/375
        updateSpeed(touchX: tmpValue, isEnd: true)
        outdoorAirView=Bundle.main.loadNibNamed("AirOutdoorView", owner: nil, options: nil)?.first as! AirOutdoorView
        outdoorAirView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        outdoorAirView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        User.GetWeather(success: { (pollution, city, pm25, _, _, _, _) in
            self.cityLabel.text=city
            self.outdoorPM25Label.text="\(pm25)"
            if pm25==0{
                self.outdoorPM25Label.text="-"
                self.pollutionLabel.text="-"
            }else if pm25<75{
                self.pollutionLabel.text="优"
            }else if pm25>150{
                self.pollutionLabel.text="差"
            }else{
                self.pollutionLabel.text="良"
            }
            }, failure: { (error) in
                
        })
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
        if currentDevice?.connectStatus != .Connected {
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
            sliderValueStateLabel.text=loadLanguage("关机")
        case tmpValueInt>0&&tmpValueInt<=33:
            sliderValueStateLabel.text=loadLanguage("低速")
        case tmpValueInt>33&&tmpValueInt<=66:
            sliderValueStateLabel.text=loadLanguage("中速")
        default:
            sliderValueStateLabel.text=loadLanguage("高速")
        }
        
        if isEnd==true {
            
            if tmpValueInt == 0 {
                PM25_In = -1
            }
            
            if tmpValueInt != 0 {
                
                if PM25_In == -1 {
                    (self.currentDevice as! AirPurifier_Blue).startPower(power: true, speed: tmpValueInt, callBack: { (error) in
                        
                    })
                } else {
                
                (self.currentDevice as! AirPurifier_Blue).setSpeed(speed: tmpValueInt, callBack: { (error) in
                    
                })
                }
                PM25_In = (self.currentDevice as! AirPurifier_Blue).sensor.PM25
            } else {
//                self.perform(#selector(Air_BlueMainView.closeed), with: nil, afterDelay: 1, inModes: [RunLoopMode.commonModes])
                
                if PM25_In != -1 {
                    return
                }
                
               (self.currentDevice as! AirPurifier_Blue).closePower(power: false, callBack: { (eror) in
                
               })
                

                return
            }
            
           

        }
    }
    
    func closeed() {

        DispatchQueue.main.async {
            (self.currentDevice as! AirPurifier_Blue).setPower(power: false,    callBack: { (error) in
            })
        }
        
    
    }
    
    private var PM25_In = 0{//头部视图
        didSet{
            
            if PM25_In != oldValue  {
                if PM25_In == -1 || PM25_In == -2 {//-1 已关机,-2 已断开
                    FLZLabel.isHidden=true
                    
                    pm25ValueLabel.text = PM25_In == -2 ? loadLanguage("设备已断开"):loadLanguage("设备已关机")
                    pm25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 35*width_screen/375)
                    updateSpeed(touchX: 0, isEnd: true)
//                    self.currentDevice?.connectStatus = OznerConnectStatus.Disconnect
                    return
                }
                if PM25_In < -2 || PM25_In == 0 || PM25_In == 65535 {//暂无数据
                    FLZLabel.isHidden=true
                    pm25ValueLabel.text="-"
                    return
                }
                pm25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 55*width_screen/375)
                FLZLabel.isHidden=false
                pm25ValueLabel.format = "%d"
                pm25ValueLabel.count(from: CGFloat(oldValue==65535 ? 0:oldValue), to: CGFloat(PM25_In))
                
                temperatureValueLabel.text="\((self.currentDevice as! AirPurifier_Blue).sensor.Temperature)℃"
                humidityValueLabel.text="\((self.currentDevice as! AirPurifier_Blue).sensor.Humidity)%"
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

    override func SensorUpdate(identifier: String) {
        //更新传感器视图
        
        print("空净时时风速：\((self.currentDevice as! AirPurifier_Blue).sensor.Speed)")
        if (self.currentDevice as! AirPurifier_Blue).sensor.Power==false
        {
            PM25_In = -1
        }else{
            PM25_In=(self.currentDevice as! AirPurifier_Blue).sensor.PM25
        }
        
        
    }
    var connectChange:OznerConnectStatus = .Disconnect{
        didSet{
            if connectChange==oldValue {
                return
            }
            var tmpValue=CGFloat(0)
            switch connectChange {
            case .Connected:
                tmpValue=CGFloat((currentDevice as! AirPurifier_Blue).sensor.Speed)/100
                tmpValue=34.5*width_screen/375+tmpValue*264*width_screen/375
                PM25_In=Int((self.currentDevice as! AirPurifier_Blue).sensor.PM25)
            default:
                PM25_In = -2
                break
            }
            if connectChange == .Connected {
                updateSpeed(touchX: tmpValue, isEnd: true)
            }
            
        }
    }
    
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        //更新连接状态视图
        connectChange=(OznerManager.instance.currentDevice?.connectStatus)!
    }
}
