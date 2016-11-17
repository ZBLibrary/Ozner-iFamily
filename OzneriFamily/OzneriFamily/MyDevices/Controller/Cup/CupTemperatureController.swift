//
//  CupTemperatureController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTemperatureController: UIViewController {

    @IBOutlet var tempValueLabel: UILabel!

    @IBAction func Consulting(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    @IBOutlet var tempStateImg: UIImageView!
    @IBOutlet var tempStateLabel: UILabel!
    

    //var chartContainerView: CupTDSChartContainerView!
    
    @IBOutlet var chartContainerview: UIView!
   
    @IBAction func buyWaterPurfier(_ sender: AnyObject) {
         LoginManager.instance.setTabbarSelected(index: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = LoginManager.instance.currentDevice as! Cup
        let temp=device.sensor.temperature==65535 ? 0 :device.sensor.temperature
        switch true
        {
        case temp>0&&temp<=temperature_low:
            tempValueLabel.text="偏凉"
            tempStateImg.image=UIImage(named: "waterState1")
            tempStateLabel.text=loadLanguage("水温太凉啦！让胃暖起来，心才会暖！")
        case temperature_low<temp&&temp<=temperature_high:
            tempValueLabel.text="适中"
            tempStateImg.image=UIImage(named: "waterState2")
            tempStateLabel.text=loadLanguage("不凉不烫，要的就是刚刚好！")
        case temperature_high<temp:
            tempValueLabel.text="偏烫"
            tempStateImg.image=UIImage(named: "waterState3")
            tempStateLabel.text=loadLanguage("水温偏烫再凉一凉吧，心急可是会受伤的哦！")
        default:
            tempValueLabel.text="-"
            tempStateLabel.text="-"
            break
        }
        
        
        let chartCont=Bundle.main.loadNibNamed("CupTDSChartContainerView", owner: nil, options: nil)?.last as! CupTDSChartContainerView
        chartContainerview.addSubview(chartCont)
        chartCont.translatesAutoresizingMaskIntoConstraints = false
        chartCont.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        chartCont.InitSetView(volumes: device.volumes, sensorType: 1)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.CupTDSDetail)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showHealthyKnow"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["jxszd"]?.stringValue)!, isUrl: true)
            vc.title="健康水知道"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
