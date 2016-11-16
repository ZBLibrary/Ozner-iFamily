//
//  CupTDSDetailLineView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/15.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSDetailLineView: UIView {

 
   var volumes:CupRecordList!
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
            xLabel1.text=["0h","周一","01"][switchDate]
            xLabel2.text=["","周二",""][switchDate]
            xLabel3.text=["8","周三","11"][switchDate]
            xLabel4.text=["","周四",""][switchDate]
            xLabel5.text=["16","周五","21"][switchDate]
            xLabel6.text=["","周六",""][switchDate]
            xLabel7.text=["23","周日","\(NSDate().daysInMonth())"][switchDate]
            //chartView.updateView(segindex: sender.selectedSegmentIndex)
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
