//
//  WaterPurfierTDSController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class WaterPurfierTDSController: UIViewController {

    //header
    @IBOutlet var tdsValueLabel_BF: UILabel!
    @IBOutlet var tdsValueLabel_AF: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var tdsStateImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    @IBAction func shareClick(_ sender: AnyObject) {
        let device=LoginManager.instance.currentDevice as! WaterPurifier
        let tdsValue = min(device.sensor.tds1,device.sensor.tds2)
        var rankValue=0
        var beatValue=0
        User.TDSSensor(deviceID: device.identifier, type: device.type, tds: Int(tdsValue), beforetds: 0, success: { (rank, total) in
            rankValue = rank
            beatValue = Int(100*CGFloat(total-rank)/CGFloat(total))
            }, failure: { (error) in
                
        })
        let img=OznerShareManager.getshareImage(rankValue, type: 1, value: Int(tdsValue), beat: beatValue, maxWater: 0)
        OznerShareManager.ShareImgToWeChat(sence: WXSceneTimeline, url: "", title: "浩泽净水家", shareImg: img)
    }
    @IBAction func ConsultingClick(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    //center
    @IBOutlet var TDSchartView: WaterPurfierTDSChart!
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        weakLabel1.text = sender.selectedSegmentIndex==0 ? "周一":"01"
         weakLabe2.text = sender.selectedSegmentIndex==0 ? "周二":""
        weakLabel3.text = sender.selectedSegmentIndex==0 ? "周三":"11"
        weakLabel4.text = sender.selectedSegmentIndex==0 ? "周四":""
        weakLabel5.text = sender.selectedSegmentIndex==0 ? "周五":"21"
        weakLabel6.text = sender.selectedSegmentIndex==0 ? "周六":""
        weakLabel7.text = sender.selectedSegmentIndex==0 ? "周日":"\(NSDate().daysInMonth())"
        self.TDSchartView.updateView(isWeak: sender.selectedSegmentIndex==0)
    }
    @IBOutlet var weakLabel1: UILabel!
    @IBOutlet var weakLabe2: UILabel!
    @IBOutlet var weakLabel3: UILabel!
    @IBOutlet var weakLabel4: UILabel!
    @IBOutlet var weakLabel5: UILabel!
    @IBOutlet var weakLabel6: UILabel!
    @IBOutlet var weakLabel7: UILabel!
    
    //footer
    @IBAction func buyDeviceClick(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = LoginManager.instance.currentDevice as! WaterPurifier
        let TDS_BF=max(device.sensor.tds1, device.sensor.tds2)
        let TDS_AF=min(device.sensor.tds1, device.sensor.tds2)
        tdsValueLabel_BF.text = TDS_BF==0||TDS_BF==65535 ? "-":"\(TDS_BF)"
        tdsValueLabel_AF.text = TDS_AF==0||TDS_AF==65535 ? "-":"\(TDS_AF)"
        // Do any additional setup after loading the view.
        User.TdsFriendRank(type: device.type, success: { (rank) in
            self.rankLabel.text="\(rank)"
        }) { (error) in
            self.rankLabel.text="-"
        }
        User.GetDeviceTdsFenBu(mac: device.identifier, success: { (WeakData, MonthData) in
            self.TDSchartView.weakData=WeakData
            self.TDSchartView.monthData=MonthData
            self.TDSchartView.updateView(isWeak: true)
            }, failure: { (error) in
            
        })
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showHealthyKnow" {
            let vc = segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL!["jxszd"]?.stringValue)!, Type: 0)
            vc.title="健康水知道"
        }
        if segue.identifier=="showWhatIsTDS"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是TDS"]?.stringValue)!, Type: 2)
            vc.title="什么是TDS"
        }
    }
    

}
