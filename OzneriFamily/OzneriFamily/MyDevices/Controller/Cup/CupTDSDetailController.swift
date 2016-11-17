//
//  CupTDSDetailController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSDetailController: UIViewController {


    @IBAction func shareClick(_ sender: UIBarButtonItem) {
    }
    @IBOutlet var tdsValueLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBAction func ConsultingClick(_ sender: UIButton) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    @IBOutlet var tdsStateImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    
    @IBOutlet var chartContainerView: UIView!
    @IBAction func buyWaterPurfier(_ sender: UIButton) {
        LoginManager.instance.setTabbarSelected(index: 1)
    }
    var rankValue = 0 //排名
    var beatValue = 0 //打败了百分之多少的用户
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let device = LoginManager.instance.currentDevice as! Cup
        let tds=device.sensor.tds==65535 ? 0 :device.sensor.tds
        tdsValueLabel.text = tds==0 ? "-":"\(tds)"
        switch true
        {
        case tds>0&&tds<=tds_good:
            tdsStateImg.image=UIImage(named: "waterState1")
            tdsStateLabel.text=loadLanguage("完美水质，体内每个细胞都说好！")
        case tds_good<tds&&tds<=tds_bad:
            tdsStateImg.image=UIImage(named: "waterState2")
            tdsStateLabel.text=loadLanguage("饮水安全需谨慎，你值得拥有更好的。")
        case tds_bad<tds:
            tdsStateImg.image=UIImage(named: "waterState3")
            tdsStateLabel.text=loadLanguage("当前杂质较多，请放心给对手饮用")
        default:
            tdsStateLabel.text="-"
            break
        }
        //TDS排名
        
        User.TDSSensor(deviceID: device.identifier, type: device.type, tds: Int(tds), beforetds: 0, success: { (rank, total) in
            self.rankValue = rank
            self.beatValue = Int(100*CGFloat(total-rank)/CGFloat(total))
            self.rankLabel.text="\(rank)"
            let strCount=self.rankLabel.text!.characters.count
            var fontSize=(66*width_screen/375-16)/CGFloat(strCount)*2
            fontSize=min(32, fontSize)
            fontSize=max(12, fontSize)
            self.rankLabel.font=UIFont.init(name: ".SFUIDisplay-Thin", size:fontSize)
            }, failure: { (error) in
                self.rankLabel.text="-"
        })
        
        //chart
        let chartCont=Bundle.main.loadNibNamed("CupTDSChartContainerView", owner: nil, options: nil)?.last as! CupTDSChartContainerView
        chartContainerView.addSubview(chartCont)
        chartCont.translatesAutoresizingMaskIntoConstraints = false
        chartCont.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        chartCont.InitSetView(volumes: device.volumes, sensorType: 0)
        
        
        
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
