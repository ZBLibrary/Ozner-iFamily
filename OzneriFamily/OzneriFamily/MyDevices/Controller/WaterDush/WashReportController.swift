//
//  WashReportController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/15.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class WashReportController: BaseViewController {

    @IBOutlet var valueLabel1: UILabel!
    @IBOutlet var valueLabel2: UILabel!
    @IBOutlet var valueLabel3: UILabel!
    @IBOutlet var valueLabel4: UILabel!
    @IBOutlet var valueLabel5: UILabel!
    @IBOutlet var valueLabel6: UILabel!
    @IBOutlet var valueLabel7: UILabel!
    @IBOutlet var valueLabel8: UILabel!
    @IBOutlet var valueLabel9: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device=OznerManager.instance.currentDevice as! WashDush_Wifi
        let lastData = device.sensor.lastWashData
        if lastData.count>=16 {
            var textStr="\(Int(lastData[0])+2000).\(Int(lastData[1])).\(Int(lastData[2])) "
            textStr+=" \(Int(lastData[3])):\(Int(lastData[4])):\(Int(lastData[5]))"
            valueLabel1.text=textStr
            let report = lastData.subData(starIndex: 6, count: 10)
            valueLabel2.text="\(Int(report[1]))"+".\(Int(report[0])) L"
            valueLabel3.text="\(Int(report[3]))"+".\(Int(report[2])) KWH"
            valueLabel4.text="\(Int(report[4])) min"
            valueLabel5.text="\(Int(report[5])) min"
            valueLabel6.text="\(Int(report[6])) ℃"
            valueLabel7.text=Int(report[7])==0 ? "-":"\(Int(report[7]))"
            valueLabel8.text=Int(report[8])==0 ? "-":"\(Int(report[8]))"
            valueLabel9.text=Int(report[9])==0 ? "-":"\(Int(report[9]))"
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
