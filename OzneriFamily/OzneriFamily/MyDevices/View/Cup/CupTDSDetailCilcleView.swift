//
//  CupTDSDetailCilcleView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSDetailCilcleView: UIView {

    var volumes:OznerCupRecords!
    
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet var topLabel1: UILabel!
    @IBOutlet var topLabel2: UILabel!
    @IBOutlet var topLabel3: UILabel!
    
    @IBOutlet var circleViewContaniner: UIView!
    var tdsCircleView: CupTDSCircleView!
    func setInitView(WhitchType:Int,Volumes:OznerCupRecords!) {
        tdsCircleView = Bundle.main.loadNibNamed("CupTDSCircleView", owner: nil, options: nil)?.last as! CupTDSCircleView
        tdsCircleView.frame=circleViewContaniner.frame
        circleViewContaniner.addSubview(tdsCircleView)
        tdsCircleView.translatesAutoresizingMaskIntoConstraints = false
        tdsCircleView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        tdsCircleView.UpdateCircle(type: WhitchType, state1: 0, state2: 0, state3: 0)
        whitchType=WhitchType
        volumes=Volumes
        switchDate = 0
    }
    var whitchType = 0{//0TDS,1温度
        didSet{
            
            topLabel1.text = whitchType==0 ? loadLanguage("较差"):loadLanguage("偏烫")
            topLabel2.text = whitchType==0 ? loadLanguage("一般"):loadLanguage("适中")
            topLabel3.text = whitchType==0 ? loadLanguage("健康"):loadLanguage("偏凉")
            
            topLabel3.textColor = whitchType==0 ? UIColor(hexString: "#4990ef"):UIColor(hexString: "#4bacef")
            topLabel2.textColor = whitchType==0 ? UIColor(hexString: "#7f64e5"):UIColor(hexString: "#e58e62")
            topLabel1.textColor = whitchType==0 ? UIColor(hexString: "#ee696b"):UIColor(hexString: "#ef6668")
        }
    }
    var switchDate = 0{//0日,1周,2月
        didSet{
           leftButton.isHidden = switchDate==0
           rightButton.isHidden = switchDate==2
            
            
            if volumes==nil {
                tdsCircleView.UpdateCircle(type: whitchType, state1: 0, state2: 0, state3: 0)
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
                topLabel1.text = ( whitchType==0 ? loadLanguage("较差"):loadLanguage("偏烫"))+"(\(tmp3need)%)"
                topLabel2.text = (whitchType==0 ? loadLanguage("一般"):loadLanguage("适中"))+"(\(Int(tmp2*100))%)"
                topLabel3.text = (whitchType==0 ? loadLanguage("健康"):loadLanguage("偏凉"))+"(\(Int(tmp1*100))%)"
                tdsCircleView.UpdateCircle(type: whitchType, state1: tmp3need, state2: Int(tmp2*100), state3: Int(tmp1*100))
                return
            }
            
            
            tdsCircleView.UpdateCircle(type: whitchType, state1: 0, state2: 0, state3: 0)
            
            
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
   

}
