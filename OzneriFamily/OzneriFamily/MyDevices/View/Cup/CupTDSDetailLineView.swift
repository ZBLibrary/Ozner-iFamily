//
//  CupTDSDetailLineView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSDetailLineView: UIView {

 
    @IBOutlet var leftLabel1: UILabel!
    @IBOutlet var leftLabel2: UILabel!
    @IBOutlet var leftLabel3: UILabel!
    @IBOutlet var xLabel1: UILabel!
    @IBOutlet var xLabel2: UILabel!
    @IBOutlet var xLabel3: UILabel!
    @IBOutlet var xLabel4: UILabel!
    @IBOutlet var xLabel5: UILabel!
    @IBOutlet var xLabel6: UILabel!
    @IBOutlet var xLabel7: UILabel!
    @IBOutlet var bottomLabel1: UILabel!
    @IBOutlet var bottomLabel2: UILabel!
    @IBOutlet var bottomLabel3: UILabel!
    @IBOutlet var smallCircelLabel2: UIView!
    @IBOutlet var smallCircelLabel3: UIView!
    @IBOutlet var lineViewContainer: UIView!
    var tdsLineView:CupTDSLineView!
    var volumes:OznerCupRecords!
    
    func setInitView(WhitchType:Int,Volumes:OznerCupRecords!) {
        tdsLineView = Bundle.main.loadNibNamed("CupTDSLineView", owner: nil, options: nil)?.last as! CupTDSLineView
        lineViewContainer.addSubview(tdsLineView)
        tdsLineView.translatesAutoresizingMaskIntoConstraints = false
        tdsLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        tdsLineView.updateCircleView(SensorType: whitchType, DateType: switchDate, Volumes: Volumes)
        volumes=Volumes
        whitchType=WhitchType
    }
    var whitchType = 0{//0TDS,1温度
        didSet{
            leftLabel1.text = whitchType==0 ? loadLanguage("较差"):loadLanguage("偏烫")
            leftLabel2.text = whitchType==0 ? loadLanguage("一般"):loadLanguage("适中")
            leftLabel3.text = whitchType==0 ? loadLanguage("健康"):loadLanguage("偏凉")
            bottomLabel1.text = whitchType==0 ? loadLanguage("健康"):loadLanguage("偏凉")
            bottomLabel2.text = whitchType==0 ? loadLanguage("一般"):loadLanguage("适中")
            bottomLabel3.text = whitchType==0 ? loadLanguage("较差"):loadLanguage("偏烫")
            
            bottomLabel2.textColor = whitchType==0 ? UIColor(hexString: "#7f64e5"):UIColor(hexString: "#e58e62")
            bottomLabel3.textColor = whitchType==0 ? UIColor(hexString: "#ee696b"):UIColor(hexString: "#ef6668")
            smallCircelLabel2.layer.borderColorWithUIColor = (whitchType==0 ? UIColor(hexString: "#7f64e5"):UIColor(hexString: "#e58e62"))!
            smallCircelLabel3.layer.borderColorWithUIColor = (whitchType==0 ? UIColor(hexString: "#ee696b"):UIColor(hexString: "#ef6668"))!
        }
    }
    var switchDate = 0{//0日,1周,2月
        didSet{
            xLabel1.text=["0h",loadLanguage("周一"),"01"][switchDate]
            xLabel2.text=["",loadLanguage("周二"),""][switchDate]
            xLabel3.text=["8",loadLanguage("周三"),"11"][switchDate]
            xLabel4.text=["",loadLanguage("周四"),""][switchDate]
            xLabel5.text=["16",loadLanguage("周五"),"21"][switchDate]
            xLabel6.text=["",loadLanguage("周六"),""][switchDate]
            xLabel7.text=["23",loadLanguage("周日"),"\(NSDate().daysInMonth())"][switchDate]
            tdsLineView.updateCircleView(SensorType: whitchType, DateType: switchDate, Volumes: volumes)
            if volumes==nil {
                return
            }
            let record=volumes.getRecord(type: [.day,.weak,.month][switchDate])            
            let totalCount = record.count
            if totalCount>0 {
                var tmp1=Float(0)
                var tmp2=Float(0)
                var tmp3=Float(0)
                if whitchType==0 {
                    for item in record {
                        switch true {
                        case item.value.TDS<tds_good:
                            tmp1+=Float(1)/Float(totalCount)
                        case item.value.TDS>tds_bad:
                            tmp3+=Float(1)/Float(totalCount)
                        default:
                            tmp2+=Float(1)/Float(totalCount)
                        }
                    }
                }else{
                    for item in record {
                        switch true {
                        case item.value.Temperature<temperature_low:
                            tmp1+=Float(1)/Float(totalCount)
                        case item.value.TDS>temperature_high:
                            tmp3+=Float(1)/Float(totalCount)
                        default:
                            tmp2+=Float(1)/Float(totalCount)
                        }
                    }
                }
                var tmp3need=0
                if (100-Int(tmp1*100)-Int(tmp2*100))==1&&tmp3==0
                {
                    tmp3need=0
                    tmp2+=0.01
                }
                else
                {
                    tmp3need=100-Int(tmp1*100)-Int(tmp2*100)
                }
                bottomLabel3.text = ( whitchType==0 ? loadLanguage("较差"):loadLanguage("偏烫"))+"(\(tmp3need)%)"
                bottomLabel2.text = (whitchType==0 ? loadLanguage("一般"):loadLanguage("适中"))+"(\(Int(tmp2*100))%)"
                bottomLabel1.text = (whitchType==0 ? loadLanguage("健康"):loadLanguage("偏凉"))+"(\(Int(tmp1*100))%)"
                
            }
            
            
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
