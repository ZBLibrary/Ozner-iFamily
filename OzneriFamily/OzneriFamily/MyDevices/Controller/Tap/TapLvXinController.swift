//
//  TapLvXinController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class TapLvXinController: BaseViewController {

    //var isShowScanView = true
    var waterPurfierData:[String:Any]?
    
    @IBOutlet weak var hideView3: UIView!
    @IBOutlet weak var hideView2: UIView!
    @IBOutlet weak var hideView1: UIView!
    //滤芯
    @IBOutlet var lvxinDaysLabel: UILabel!
    @IBOutlet var lvxinValueLabel: UILabel!
    @IBOutlet var widthLXConstraint: NSLayoutConstraint!
    @IBOutlet var nowDateLabel: UILabel!
    @IBOutlet var starDateLabel: UILabel!
    @IBOutlet var stopDateLabel: UILabel!
    //咨询购买
    @IBAction func consultingClick(_ sender: AnyObject) {
         LoginManager.instance.setTabbarSelected(index: 2)
    }
   
    //扫码
    @IBOutlet var scanViewHeightConstraint: NSLayoutConstraint!
    @IBAction func scanCodeClick(_ sender: AnyObject) {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;       
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;

        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");
        
        let vc = LBXScanViewController();
        vc.scanStyle = style
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //更多产品
    //浩泽安心服务
    @IBOutlet var heightImgConstrant: NSLayoutConstraint!
    var buyWaterLvXinUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loadLanguage("滤芯状态")
//        let device=OznerManager.instance.currentDevice
        let isBool = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        
        hideView1.isHidden = isBool
        hideView2.isHidden = isBool
        hideView3.isHidden = isBool
       
        let deviceType = ProductInfo.getCurrDeviceClass()
        heightImgConstrant.constant = deviceType == OZDeviceClass.WaterPurifier_Wifi ? 0:width_screen*613/375
        if deviceType==OZDeviceClass.WaterPurifier_Wifi {
            scanViewHeightConstraint.constant = (waterPurfierData?["scanEnable"] as! Bool) ? 118:0
            self.setLvXin(stopDate: (waterPurfierData?["lvXinStopDate"] as! NSDate) as NSDate, maxDays: 365)
            buyWaterLvXinUrl=(waterPurfierData?["buyLvXinUrl"] as! String)
            if buyWaterLvXinUrl=="" {
                buyWaterLvXinUrl=(NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail9"))!
            }
        }else{//探头
            //下载滤芯更新
            buyWaterLvXinUrl=(NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail39"))!
            User.FilterService(deviceID: ProductInfo.getCurrDeviceMac(), success: { (usedDay, starDate) in
                self.setLvXin(stopDate: (starDate as NSDate).addingDays(30) as NSDate, maxDays: 30)
                }, failure: { (error) in
                    
            })
        }
        // Do any additional setup after loading the view.
    }
    func setLvXin(stopDate:NSDate,maxDays:Int){
        let starDate = stopDate.addingDays(-maxDays) as NSDate
        var remindTime=CGFloat(stopDate.timeIntervalSince1970-NSDate().timeIntervalSince1970)/CGFloat(stopDate.timeIntervalSince1970-starDate.timeIntervalSince1970)
        remindTime=min(remindTime, 1)
        remindTime=max(remindTime, 0)
        lvxinDaysLabel.text="\(Int(CGFloat(maxDays)*remindTime))"
        lvxinValueLabel.text="\(Int(100*remindTime))"
        widthLXConstraint.constant=42+(width_screen-84)*(1-remindTime)
        
        
        nowDateLabel.text="\(NSDate().year())\n"+NSDate().formattedDate(withFormat: "MM-dd")
        stopDateLabel.text="\(stopDate.year())\n"+stopDate.formattedDate(withFormat: "MM-dd")
        starDateLabel.text="\(starDate.year())\n"+starDate.formattedDate(withFormat: "MM-dd")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier)! {
        case "showWaterPurfier":
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail43"))!, Type: 0)
            vc.title=loadLanguage("净水器")
        case "showTap":
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail36"))!, Type: 0)
            vc.title=loadLanguage("智能水探头")
        case "showCup":
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail7"))!, Type: 0)
            vc.title=loadLanguage("智能水杯")
        case "showBuyLvXin":
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: buyWaterLvXinUrl, Type: 0)
            vc.title=loadLanguage("购买滤芯")
            
        default:
            break
        }
    }
   

}
