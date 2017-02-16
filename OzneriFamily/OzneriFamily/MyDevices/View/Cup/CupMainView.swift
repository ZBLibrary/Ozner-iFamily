//
//  CupMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupMainView: OznerDeviceView {

    @IBAction func headCenterClick(_ sender: UITapGestureRecognizer) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupTDSDetail", sender: nil)
    }
    @IBAction func drinkingClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupDrinkingDetail", sender: nil)
    }
    @IBAction func temperatureClick(_ sender: AnyObject) {
        self.delegate.DeviceViewPerformSegue!(SegueID: "showCupTemperatureDetail", sender: nil)
    }
    
    @IBOutlet var circleView: CupHeadCircleView!
    
    @IBOutlet var tdsImg: UIImageView!
    @IBOutlet var tdsState: UILabel!
    @IBOutlet var tdsValueLabel: UILabel!
    @IBOutlet var tdsBeatLabel: UILabel!
    
    //饮水量
    @IBOutlet var drinkingImg: UIImageView!
    @IBOutlet var drinkingValueLabel: UILabel!
    @IBOutlet var drinkingGoalLabel: UILabel!
    //水温
    @IBOutlet var temperatureImg: UIImageView!
    @IBOutlet var temperatureValueLabel: UILabel!
    @IBOutlet var temperatureStateLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
    }
    private var TDS = 0{
        didSet{
            if TDS != oldValue   {
                if TDS<=0 || TDS == 65535 {//暂无
                    tdsImg.image=UIImage(named: "baobiao")
                    tdsState.text="-"
                    tdsValueLabel.text=loadLanguage("暂无")
                    tdsBeatLabel.text=""
                    return
                }
                tdsValueLabel.text="\(TDS)"
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
                circleView.updateCircleView(angle: angle)
                //下载打败了多少人的数据
                weak var weakself=self
                User.TDSSensor(deviceID: (self.currentDevice?.identifier)!, type: (self.currentDevice?.type)!, tds: TDS, beforetds: 0, success: { (rank, total) in
                    let beat =  100*CGFloat(total-rank)/CGFloat(total)
                    weakself?.tdsBeatLabel.text=loadLanguage("击败了")+"\(Int(beat))%"+loadLanguage("的用户")
                    }, failure: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
    }
    private var Drinking = 0.0{
        didSet{
            if Drinking != oldValue   {
                let drinkGoal=Double(self.currentDevice?.settings.get("DrinkGoal", default: 2000) as! Int)
                let tmpDrinking = Drinking/drinkGoal
                drinkingGoalLabel.text=loadLanguage("饮水目标")+":\(Int(drinkGoal))ml"
                drinkingValueLabel.text="\(Int(Drinking))ml"
                switch true {
                case tmpDrinking<=0:
                    drinkingImg.image=UIImage(named: "yin_shui_liang_0")
                case tmpDrinking>0&&tmpDrinking<=0.33:
                    drinkingImg.image=UIImage(named: "yin_shui_liang_1")
                case tmpDrinking>0.33&&tmpDrinking<=0.66:
                    drinkingImg.image=UIImage(named: "yin_shui_liang_2")
                default:
                     drinkingImg.image=UIImage(named: "yin_shui_liang_3")
                    break
                }
                //上传饮水量到服务器
                User.VolumeSensor(deviceID: (self.currentDevice?.identifier)!, type: (self.currentDevice?.type)!, volume: Int(Drinking), success: { (rank) in
                    print("饮水量排名\(rank)")
                    }, failure: { (error) in
                        print("饮水量上传错误:"+error.localizedDescription)
                })
            }
        }
    }
    private var Temperature = 0{
        didSet{
            if Temperature != oldValue   {
                if Temperature == 65535 {//暂无
                    temperatureImg.image=UIImage(named: "wen_du_1")
                    temperatureValueLabel.text=loadLanguage("暂无")
                    temperatureStateLabel.text=loadLanguage("当前水温暂无")
                    return
                }
                switch true {
                case Temperature<=Int(temperature_low):
                    temperatureImg.image=UIImage(named: "wen_du_1")
                    temperatureValueLabel.text=loadLanguage("偏凉")
                    temperatureStateLabel.text=loadLanguage("当前水温偏凉")
                case Temperature>Int(temperature_low)&&Temperature<=Int(temperature_high):
                    temperatureImg.image=UIImage(named: "wen_du_2")
                    temperatureValueLabel.text=loadLanguage("适中")
                    temperatureStateLabel.text=loadLanguage("当前水温适宜饮用")
                case Temperature>Int(temperature_high):
                    temperatureImg.image=UIImage(named: "wen_du_3")
                    temperatureValueLabel.text=loadLanguage("偏烫")
                    temperatureStateLabel.text=loadLanguage("当前水温偏烫")
                default:
                    break
                }
            }
        }
    }
    override func SensorUpdate(device: OznerDevice!) {
        //更新传感器视图
        TDS=Int((device as! Cup).sensor.tds)
        Temperature=Int((device as! Cup).sensor.temperature)
        
        //饮水量
        let nowDate = NSDate()
        let dateStarOfNow = NSDate(string: "\(nowDate.year())-\(nowDate.month())-\(nowDate.day()) 00:00:01", formatString: "yyyy-MM-dd HH:mm:ss")
        let record:CupRecord? = (device as! Cup).volumes.getRecordBy(dateStarOfNow as Date!)
        Drinking = record==nil ? 0:Double((record?.volume)!)

    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        //更新连接状态视图
    }

}
extension CupMainView{
    
}
