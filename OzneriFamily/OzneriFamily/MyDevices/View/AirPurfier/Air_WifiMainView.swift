//
//  Air_WifiMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/16.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import UICountingLabel
class Air_WifiMainView: OznerDeviceView {

    //header
    @IBOutlet var PM25StateLabel: UILabel!
    @IBOutlet var PM25ValueLabel: UICountingLabel!
    @IBOutlet var VOCValueLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var circleBGimg: UIImageView!
    
    //center
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var polutionLabel: UILabel!
    @IBOutlet var pm25Label_Out: UILabel!
    
    //footer
    @IBOutlet var powerStateLabel: UILabel!
    @IBOutlet var powerButton: UIButton!
    @IBOutlet var speedButton: UIButton!
    @IBOutlet var speedStateLabel: UILabel!
    @IBOutlet var lockStateLabel: UILabel!
    @IBOutlet var lockButton: UIButton!
    var speedModelView:Air_Wifi_SpeedModel!
    var outdoorAirView:AirOutdoorView!
    override func draw(_ rect: CGRect) {
        speedModelView=Bundle.main.loadNibNamed("Air_Wifi_SpeedModel", owner: nil, options: nil)?.first as! Air_Wifi_SpeedModel
        speedModelView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        speedModelView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        
        outdoorAirView=Bundle.main.loadNibNamed("AirOutdoorView", owner: nil, options: nil)?.first as! AirOutdoorView
        outdoorAirView.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen)
        outdoorAirView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
        User.GetWeather(success: { (pollution, city, pm25, _, _, _, _) in
            self.cityLabel.text=city
            self.polutionLabel.text=pollution
            self.pm25Label_Out.text=pm25
            }, failure: { (error) in
                
        })
    }
    
    @IBAction func seeLvXinClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showAirLvXin", sender: nil)
    }
    //查看室外空气
    @IBAction func seeOutdoorAirClick(_ sender: AnyObject) {
        weak var weakself=self
        User.GetWeather(success: { (pollution, city, pm25, aqi, temp, himid, dataFrom) in
            weakself?.cityLabel.text=city
            weakself?.polutionLabel.text=pollution
            weakself?.pm25Label_Out.text=pm25
            
            weakself?.outdoorAirView.updateView(city: city, pm25: pm25, AQI: aqi, temp: temp, himit: himid, from: dataFrom, callback: {
                weakself?.outdoorAirView.removeFromSuperview()
            })
            weakself?.window?.addSubview((weakself?.outdoorAirView)!)
            }, failure: { (error) in
            
        })
    }
    
    func setButtonEnable(timer:Timer) {
        (timer.userInfo as! UIButton).isEnabled=true
    }
    @IBAction func operatingButtonClick(_ sender: UIButton) {
        sender.isEnabled=false
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(setButtonEnable), userInfo: sender, repeats: false)//防止多次连续点击
        if sender.tag != 0 && operation.power==false {
            return
        }
        
        switch sender.tag {
        case 0:
            (self.currentDevice as! AirPurifier_MxChip).status.setPower(!operation.power, callback: { (error) in
            })
        case 1:
           //弹出遮盖层
            self.window?.addSubview(speedModelView)
            speedModelView.SetSpeed(speed: operation.speed, speedCallBack: { (Speed) in
                (self.currentDevice as! AirPurifier_MxChip).status.setSpeed(UInt8(Speed), callback: { (error) in
                })
            })
            
        case 2:
            (self.currentDevice as! AirPurifier_MxChip).status.setLock(!operation.lock, callback: { (error) in
            })
        default:
            break
        }

    }
    
    
    //数据处理
    var PM25_In = 0{
        didSet{
            if PM25_In != oldValue   {
                if PM25_In == -1 || PM25_In == -2 {//-1 已关机,-2 已断开
                    PM25ValueLabel.text = PM25_In == -2 ? loadLanguage("设备云已断开"):loadLanguage("设备已关机")
                    PM25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 35*width_screen/375)
                    return
                }
                
                if PM25_In < -2 || PM25_In == 0 || PM25_In == 65535 {//暂无数据
                    PM25ValueLabel.text="-"
                    return
                }
                PM25ValueLabel.font=UIFont(name: ".SFUIDisplay-Thin", size: 55*width_screen/375)
                PM25ValueLabel.format = "%d"
                PM25ValueLabel.count(from: CGFloat(oldValue==65535 ? 0:oldValue), to: CGFloat(PM25_In))
                let tmpTmp=(self.currentDevice as! AirPurifier_MxChip).sensor.temperature
                temperatureLabel.text=(tmpTmp==65535 ? "-":"\(tmpTmp)")+"℃"
                let tmpHumidity=(self.currentDevice as! AirPurifier_MxChip).sensor.humidity
                humidityLabel.text=(tmpHumidity==65535 ? "-":"\(tmpHumidity)")+"%"
                
                let tmpVOCIndex=(self.currentDevice as! AirPurifier_MxChip).sensor.voc
                if tmpVOCIndex>=0&&tmpVOCIndex<=3 {
                    let vocStr=[loadLanguage("优"),loadLanguage("良"),loadLanguage("一般"),loadLanguage("差")][Int(tmpVOCIndex)]
                    VOCValueLabel.text=loadLanguage(vocStr)
                }else{
                    VOCValueLabel.text="-"
                }
                
                switch true {
                case PM25_In<=75:
                    
                    circleBGimg.image=UIImage(named: "GuangHuanbg")
                    PM25StateLabel.text=loadLanguage("优")
                    self.backgroundColor=UIColor(red: 94/255, green: 207/255, blue: 254/255, alpha: 1)
                case PM25_In>75&&PM25_In<=150:
                    circleBGimg.image=UIImage(named: "GuangHuanbg2")
                    PM25StateLabel.text=loadLanguage("良")
                    self.backgroundColor=UIColor(red: 163/255, green: 129/255, blue: 251/255, alpha: 1)
                case PM25_In>150:
                    circleBGimg.image=UIImage(named: "GuangHuanbg3")
                    PM25StateLabel.text=loadLanguage("差")
                    self.backgroundColor=UIColor(red: 254/255, green: 101/255, blue: 101/255, alpha: 1)
                default:
                    break
                }
                
                
            }
        }
    }
    let color_normol=UIColor(red: 177.0/255.0, green: 178.0/255.0, blue: 179.0/255.0, alpha: 1)
    let color_select=UIColor(red: 63.0/255.0, green: 135.0/255.0, blue: 237.0/255.0, alpha: 1)
    var operation:(power:Bool,speed:Int,lock:Bool) = (false,0,true){
        didSet{
            if operation==oldValue {
                return
            }
            powerStateLabel.textColor=operation.power ? color_select:color_normol
            powerButton.layer.borderColorWithUIColor = operation.power ? color_select:color_normol
            powerButton.setImage( UIImage(named: operation.power ? "air01001":"air22011"), for: .normal)
            
            
            speedStateLabel.textColor=operation.power ? color_select:color_normol
            speedButton.layer.borderColorWithUIColor = operation.power ? color_select:color_normol
            let tmpSpeed = (operation.speed != 4 && operation.speed != 5) ? 0:operation.speed
            let imgNameStr = [false:[0:"air22012",4:"airnightOff",5:"airdayOff"],
                              true:[0:"air01002",4:"airnightOn",5:"airdayOn"]
            ][operation.power]?[tmpSpeed]
            speedButton.setImage( UIImage(named: imgNameStr!), for: .normal)
            
            
            lockStateLabel.textColor=operation.power&&operation.lock ? color_select:color_normol
            lockButton.layer.borderColorWithUIColor = operation.power&&operation.lock ? color_select:color_normol
            lockButton.setImage( UIImage(named: operation.power&&operation.lock ? "air01004":"air22014"), for: .normal)
            
        }
    }
    override func SensorUpdate(device: OznerDevice!) {
        //更新传感器视图
        if (self.currentDevice as! AirPurifier_MxChip).status.getPower==false
        {
            PM25_In = -1
        }else{
            PM25_In=Int((self.currentDevice as! AirPurifier_MxChip).sensor.pm25)
        }
        
        operation=((device as! AirPurifier_MxChip).status.getPower,Int((device as! AirPurifier_MxChip).status.speed),(device as! AirPurifier_MxChip).status.getLock)
    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        //更新连接状态视图
        if (device as! AirPurifier_MxChip).isOffline
        {
            PM25_In = -2
            operation=(false,0,false)
        }else{
           // PM25_In=Int((self.currentDevice as! AirPurifier_MxChip).sensor.pm25)
            //operation=((device as! AirPurifier_MxChip).status.getPower,Int((device as! AirPurifier_MxChip).status.speed),(device as! AirPurifier_MxChip).status.getLock)
        }
        
        
    }
}

