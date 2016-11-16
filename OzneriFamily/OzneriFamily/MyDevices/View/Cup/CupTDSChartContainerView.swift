//
//  CupTDSChartView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/14.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SnapKit

class CupTDSChartContainerView: UIView {

    var volumes:CupRecordList!
    
    var sensorType = 0//0TDS,1温度
    
    var lineView:CupTDSDetailLineView!
    var tdsCircleView:CupTDSDetailCilcleView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func segValueChange(_ sender: UISegmentedControl) {
        tdsCircleView.switchDate=segmentControl.selectedSegmentIndex
        lineView.switchDate=segmentControl.selectedSegmentIndex
    }
    @IBOutlet var chartContainerView: UIView!
    func InitSetView() {
        lineView=Bundle.main.loadNibNamed("CupTDSDetailLineView", owner: nil, options: nil)?.last as! CupTDSDetailLineView
        
        chartContainerView.addSubview(lineView)
         lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        let tap1=UITapGestureRecognizer(target: self, action: #selector(switchChartClick))
        lineView.addGestureRecognizer(tap1)
        lineView.volumes=volumes
        lineView.whitchType=sensorType
        lineView.switchDate=0
        
        
        tdsCircleView=Bundle.main.loadNibNamed("CupTDSDetailCilcleView", owner: nil, options: nil)?.last as! CupTDSDetailCilcleView
        chartContainerView.addSubview(tdsCircleView)
        tdsCircleView.isHidden=true
        tdsCircleView.translatesAutoresizingMaskIntoConstraints = false
        tdsCircleView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        let tap2=UITapGestureRecognizer(target: self, action: #selector(switchChartClick))
        tdsCircleView.addGestureRecognizer(tap2)
        tdsCircleView.leftButton.addTarget(self, action: #selector(circleButtonClick), for: .touchUpInside)//tag  -1
        tdsCircleView.rightButton.addTarget(self, action: #selector(circleButtonClick), for: .touchUpInside)//tag  1
        tdsCircleView.setInitView(WhitchType: sensorType, Volumes: volumes)

        
    }
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        
//    }
    //selectedSegmentIndex:0日,1周，2月
    func circleButtonClick(button:UIButton) {//圆环左右按钮点击事件
        segmentControl.selectedSegmentIndex=(segmentControl.selectedSegmentIndex+button.tag+3)%3
        tdsCircleView.switchDate=segmentControl.selectedSegmentIndex
        lineView.switchDate=segmentControl.selectedSegmentIndex
    }
    //切换chart
    func switchChartClick() {
        lineView.isHidden = !lineView.isHidden
        tdsCircleView.isHidden = !tdsCircleView.isHidden
    }
    
    
}
