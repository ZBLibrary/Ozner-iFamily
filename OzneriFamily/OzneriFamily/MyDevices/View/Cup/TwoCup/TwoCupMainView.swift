//
//  TwoCupMainView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/9/4.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/9/4  下午2:58
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class TwoCupMainView: OznerDeviceView {
    
    
    
    @IBOutlet weak var tdsLb: UILabel!
    
    @IBOutlet weak var tdsState: UILabel!
    @IBOutlet weak var tdsImg: UIImageView!
    @IBOutlet weak var tdsBeatLabel: UILabel!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var secondRemindLb: UILabel!
    @IBOutlet weak var timeRemindLb: UILabel!
    @IBOutlet weak var batteryLb: UILabel!
    @IBOutlet weak var batteryImage: UIImageView!

    @IBOutlet weak var tdsView: CupHeadCircleView!
    @IBOutlet weak var segement: UISegmentedControl!
    
    @IBOutlet weak var tempView: GYCirclePoint!
    
    var battery:Int = 0 {
        
        didSet {
            
            if battery != oldValue {
                
                batteryLb.text = String(battery) + "%"
                switch battery {
                case 0...15:
                    batteryImage.image = #imageLiteral(resourceName: "没电")
                    break
                case 16...30:
                    batteryImage.image = #imageLiteral(resourceName: "电池25")
                    break
                case 30...70:
                    batteryImage.image = #imageLiteral(resourceName: "电池50")
                    break
                case 71...89:
                    batteryImage.image = #imageLiteral(resourceName: "电池75")
                    break
                case 90...100:
                    batteryImage.image = #imageLiteral(resourceName: "电池满")
                    break
                default:
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
                    tdsState.text="-"
                    tdsLb.text=loadLanguage("暂无")
                    tdsBeatLabel.text=""
                    return
                }
                tdsLb.text="\(TDS)"
                var angle = CGFloat(0)
                switch true {
                case TDS<=Int(tds_good):
                    tdsImg.image=UIImage(named: "baobiao")
                    tdsState.text=loadLanguage("好")
                    angle=CGFloat(TDS)/CGFloat(tds_good*3)
                case TDS>Int(tds_good)&&TDS<=Int(tds_bad):
                    tdsImg.image=UIImage(named: "yiban")
                    tdsState.text=loadLanguage("一般")
                    angle=CGFloat(TDS-Int(tds_good))/CGFloat((tds_bad-tds_good)*3)+0.33
                case TDS>Int(tds_bad)&&TDS<Int(tds_bad+50):
                    tdsImg.image=UIImage(named: "cha")
                    tdsState.text=loadLanguage("偏差")
                    angle=CGFloat(TDS-Int(tds_bad))/CGFloat(50*3)+0.66
                default:
                    tdsImg.image=UIImage(named: "cha")
                    tdsState.text=loadLanguage("偏差")
                    angle=1.0
                    break
                }
                tdsView.updateCircleView(angle: angle)
                //下载打败了多少人的数据
                weak var weakself=self
                User.TDSSensor(deviceID: (self.currentDevice?.deviceInfo.deviceMac)!, type: (self.currentDevice?.deviceInfo.deviceType)!, tds: TDS, beforetds: 0, success: { (rank, total) in
                    let beat =  100*CGFloat(total-rank)/CGFloat(total)
                    weakself?.tdsBeatLabel.text=loadLanguage("击败了")+"\(Int(beat))%"+loadLanguage("的用户")
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
    }
   

    @IBAction func tempAction(_ sender: UITapGestureRecognizer) {
        
         self.delegate.DeviceViewPerformSegue!(SegueID: "showCupTemperatureDetail", sender: nil)
    }
    
    
    @IBAction func tdsAction(_ sender: UITapGestureRecognizer) {
        
         self.delegate.DeviceViewPerformSegue!(SegueID: "showCupTDSDetail", sender: nil)
        
    }
    
    @IBAction func timeSetAction(_ sender: UITapGestureRecognizer) {
        
        self.delegate.DeviceViewPerformSegue!(SegueID: "ShowElectrickettleSetting", sender: nil)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tdsView.isHidden = true
        tempView.isHidden = false
        segement.addTarget(self, action:  #selector(TwoCupMainView.segmentedChanged(_:)), for: UIControlEvents.valueChanged)
        
      
        if OznerManager.instance.currentDevice?.settings.GetValue(key: "SmartCupRemindSender", defaultValue: "0") == "0" {
          
            timeRemindLb.text = "未设置"
            secondRemindLb.text = "未设置"
            
        } else {
        
            let starTime=Int((OznerManager.instance.currentDevice?.settings.GetValue(key: "SmartCupStartTiemKey", defaultValue: "\(9*3600)"))!)!
            let endTime=Int((OznerManager.instance.currentDevice?.settings.GetValue(key: "SmartCupEndTiemKey", defaultValue: "\(19*3600)"))!)!
            
            timeRemindLb.text="\(timeCheck(starTime)):\(sec(starTime))-\(timeCheck(endTime)):\(sec(endTime))"
            let timeSpace = Int((OznerManager.instance.currentDevice?.settings.GetValue(key: "SmartCupRemindInterval", defaultValue: "15"))!)!
            secondRemindLb.text="\(timeSpace%60+timeSpace/60)"+(timeSpace>=60 ? loadLanguage("小时"):loadLanguage("分钟"))
        }
        
    }
    
    func timeCheck(_ hour:Int) -> String {
        
        if hour/3600 >= 10 {
           return String(hour/3600)
        }
        return "0" + "\(hour/3600)"
        
    }
    
    func sec(_ hour:Int) -> String {
        
        if (hour%3600)/60 >= 10 {
            return String((hour%3600)/60)
        }
        return "0" + "\((hour%3600)/60)"
        
    }
    
    func segmentedChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            UIView.transition(with: tempView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.tdsView.isHidden = true
                self.tempView.isHidden = false
                
            }, completion: { (finished) in
                
            })
            
            break
        case 1:
            UIView.transition(with: tdsView, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.tempView.isHidden = true
                self.tdsView.isHidden = false
            }, completion: { (finished) in
                
            })
            
            break
        default:
            break
        }
        
    }

    
    override func SensorUpdate(identifier: String) {
        
        
        let currentDevice=OznerManager.instance.currentDevice as! TwoCup
        
        tempView.currentTemp(currentDevice.senSorTwo.Temperature)
        battery = currentDevice.cupState.Battery
        TDS = currentDevice.senSorTwo.TDS
        
    }
    
    override func StatusUpdate(identifier: String, status: OznerConnectStatus) {
        
        
        
    }
    
    
//    override func draw(_ rect: CGRect) {
//        
//        super.draw(rect)
//        
//        
//        /// 获取当前View在屏幕上的坐标点
//        let lb1Frame = lb1.convert(lb1.bounds, to: appDelegate.window)
//        
//        
////        let lb1Frame = lb1.frame
////        print(lb1Frame)
////        print(lb2.frame)
//        
//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.setLineCap(CGLineCap.round)
//        
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: lb1Frame.minX - 6, y: lb1Frame.minY))
//        path.addLine(to: CGPoint(x: lb1Frame.minX - 6, y: lb1Frame.maxY))
//        path.closeSubpath() //关闭路径
//        
//        ctx?.setFillColor(UIColor.blue.cgColor)
//        ctx?.setLineWidth(4)
//        ctx?.addPath(path)
//        ctx?.strokePath()
//    
//
//        
//    }
//

}
