//
//  CupTDSDetailController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupTDSDetailController: BaseViewController {


    @IBAction func shareClick(_ sender: UIBarButtonItem) {
        let img = OznerShareManager.getshareImage(rankValue, type: 1, value: 1, beat: beatValue, maxWater: 0)
        OznerShareManager.ShareImgToWeChat(sence: WXSceneTimeline, url: "", title: "浩泽净水家", shareImg: img)
    }
    @IBOutlet weak var rightBtn: UIBarButtonItem!
    @IBOutlet weak var bootomHideView: UIView!
    @IBOutlet var tdsValueLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBAction func ConsultingClick(_ sender: UIButton) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    @IBOutlet var tdsStateImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var healthLb: UIButton!
    @IBOutlet weak var gaishanlb: UILabel!
    @IBOutlet weak var zixunBtn: UIButton!
    @IBOutlet weak var friendLb: UILabel!
    @IBOutlet weak var tdsLb: UILabel!
    @IBOutlet var chartContainerView: UIView!
    @IBAction func buyWaterPurfier(_ sender: UIButton) {
        LoginManager.instance.setTabbarSelected(index: 1)
    }
    var rankValue = 0 //排名
    var beatValue = 0 //打败了百分之多少的用户
    var tdsValue=Int32(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("水质纯净值TDS")
        tdsLb.text = loadLanguage("水质纯净值")
        friendLb.text = loadLanguage("好友排名")
        healthLb.setTitle(loadLanguage("健康水知道 "), for: UIControlState.normal)
        buyBtn.setTitle(loadLanguage("购买净水器"), for: UIControlState.normal)
        zixunBtn.setTitle(loadLanguage("咨询"), for: UIControlState.normal)
        gaishanlb.text = loadLanguage("改善您的饮水健康")
        if !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        {
            bootomHideView.isHidden = true
            zixunBtn.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        } else {
            bootomHideView.isHidden = false
            zixunBtn.isHidden = false
        }

        let device = LoginManager.instance.currentDevice as! Cup
        tdsValue=device.sensor.tds==65535 ? 0 :device.sensor.tds
        tdsValueLabel.text = tdsValue==0 ? "-":"\(tdsValue)"
        switch true
        {
        case tdsValue>0&&tdsValue<=tds_good:
            tdsStateImg.image=UIImage(named: "waterState1")
            tdsStateLabel.text=loadLanguage("完美水质，体内每个细胞都说好！")
        case tds_good<tdsValue&&tdsValue<=tds_bad:
            tdsStateImg.image=UIImage(named: "waterState2")
            tdsStateLabel.text=loadLanguage("饮水安全需谨慎，你值得拥有更好的。")
        case tds_bad<tdsValue:
            tdsStateImg.image=UIImage(named: "waterState3")
            tdsStateLabel.text=loadLanguage("当前杂质较多，请放心给对手饮用")
        default:
            tdsStateLabel.text="-"
            break
        }
        //TDS排名
        
        User.TDSSensor(deviceID: device.identifier, type: device.type, tds: Int(tdsValue), beforetds: 0, success: { (rank, total) in
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
        if segue.identifier=="showWhatIsTDS"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是TDS"]?.stringValue)!, Type: 2)
            vc.title="什么是TDS"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
