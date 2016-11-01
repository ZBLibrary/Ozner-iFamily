//
//  TapMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class TapMainView: OznerDeviceView {

    @IBOutlet var circleView: CupHeadCircleView!
    @IBOutlet var tdsImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    @IBOutlet var tdsValueLabel: UILabel!
    @IBOutlet var tdsBeatLabel: UILabel!
    @IBOutlet var goodOfMonthLabel: UILabel!
    @IBOutlet var generalOfMonthLabel: UILabel!
    @IBOutlet var badOfMonthLabel: UILabel!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var lastDayOfMonth: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        lastDayOfMonth.text="\(NSDate().daysInMonth())"
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
                //下载打败了多少人的数据
                weak var weakself=self
                User.TDSSensor(deviceID: (self.currentDevice?.identifier)!, type: (self.currentDevice?.type)!, tds: TDS, beforetds: 0, success: { (rank, total) in
                    let beat =  100*CGFloat(total-rank)/CGFloat(total)
                    weakself?.tdsBeatLabel.text=loadLanguage("击败了")+"\(Int(beat))%"+loadLanguage("的用户")
                    }, failure: { (error) in
                        print(error.localizedDescription)
                })
                SetTapMonthView()
            }
        }
    }
    private func SetTapMonthView(){
        let nowDate = NSDate()
        let dateStarOfNow = NSDate(string: "\(nowDate.year())-\(nowDate.month())-01 00:00:01", formatString: "yyyy-MM-dd HH:mm:ss")
        let recordArr=(self.currentDevice as! Tap).recordList.getRecordsBy(dateStarOfNow as Date!) as NSArray
        chartView.updateCircleView(dataArr: recordArr)
    }
    override func SensorUpdate(device: OznerDevice!) {
        self.currentDevice=device
        //更新传感器视图
        TDS=Int((device as! Tap).sensor.tds)
    }
    override func StatusUpdate(device: OznerDevice!, status: DeviceViewStatus) {
        self.currentDevice=device
        //更新连接状态视图
    }
}

