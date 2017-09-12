//
//  CupTemperatureController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTemperatureController: BaseViewController {
    
    var isOneCup:Bool = true

    @IBOutlet var tempValueLabel: UILabel!

    @IBAction func Consulting(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    @IBOutlet var tempStateImg: UIImageView!
    @IBOutlet var tempStateLabel: UILabel!
    

    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var healthyBtn: UIButton!
    @IBOutlet weak var zixunBtn: UIButton!
    //var chartContainerView: CupTDSChartContainerView!
    
    @IBOutlet weak var bootomHideView: UIView!
    @IBOutlet var chartContainerview: UIView!
   
    @IBAction func buyWaterPurfier(_ sender: AnyObject) {
         LoginManager.instance.setTabbarSelected(index: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("水温")
        
        zixunBtn.setTitle(loadLanguage("咨询"), for: UIControlState.normal)
        healthyBtn.setTitle(loadLanguage("健康水知道 "), for: UIControlState.normal)
        buyBtn.setTitle(loadLanguage("购买净水器"), for: UIControlState.normal)
        
        if !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        {
            zixunBtn.isHidden = true
            bootomHideView.isHidden = true
        } else {
            zixunBtn.isHidden = false
            bootomHideView.isHidden = false
        }

        let chartCont=Bundle.main.loadNibNamed("CupTDSChartContainerView", owner: nil, options: nil)?.last as! CupTDSChartContainerView
        chartCont.titleLabel.text = "水温分布"
        chartContainerview.addSubview(chartCont)
        chartCont.translatesAutoresizingMaskIntoConstraints = false
        chartCont.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        var temp:Int = 0
        if isOneCup {
            let device = OznerManager.instance.currentDevice as! Cup
            temp = device.sensor.Temperature
            chartCont.InitSetView(volumes: device.records, sensorType: 1)

        } else {
            let device = OznerManager.instance.currentDevice as! TwoCup
            temp = device.senSorTwo.Temperature
            chartCont.InitSetView(volumes: device.records, sensorType: 1)
        }
        
        
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
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.CupTDSDetail)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showHealthyKnow"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["jxszd"]?.stringValue)!, Type: 0)
            vc.title="健康水知道"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
