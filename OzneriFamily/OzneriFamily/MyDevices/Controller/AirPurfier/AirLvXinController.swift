//
//  AirLvXinController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON

class AirLvXinController: BaseViewController {

    @IBOutlet var pm25ValueLabel: UILabel!
    @IBOutlet var vocValueLabel: UILabel!
    @IBOutlet var vocWidthConstraint: NSLayoutConstraint!
    //@IBOutlet var totalHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalPurificatContainerView: UIView!
    @IBOutlet var totalValueLabel: UILabel!
    @IBOutlet var reSetLvXinButton: UIButton!
    
    let device=OznerManager.instance.currentDevice
    
    @IBAction func reSetLvXinClick(_ sender: AnyObject) {
        
        let deviceType = ProductInfo.getIOTypeFromProductID(productID: (device?.deviceInfo.productID)!)
        
        if deviceType == .MxChip {
            let vc = FilterInfoScanVc()
            vc.block = { (str) in
                self.getFilterInfo(str)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            return
        }
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            dynamicAnimatorActive: true
        )
        let alert=SCLAlertView(appearance: appearance)
        _=alert.addButton(loadLanguage("否")) {
        }
        _=alert.addButton(loadLanguage("是")) {
            let device=OznerManager.instance.currentDevice as! AirPurifier_Blue
            device.resetFilter(callBack: { (error) in
                print(error ?? "")
            })
        }
        _=alert.showInfo("", subTitle: loadLanguage("您是否要重置滤芯?"))
   
    }
    @IBOutlet var lvxinImg: UIImageView!
    @IBOutlet var lvxinValueLabel: UILabel!
    @IBOutlet var starDateLabel: UILabel!
    @IBOutlet var nowDateLabel: UILabel!
    @IBOutlet var stopDateLabel: UILabel!
    @IBOutlet var imgWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hideView1: UIView!
    
    @IBAction func consultingClick(_ sender: AnyObject) {
         LoginManager.instance.setTabbarSelected(index: 2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loadLanguage("室内空气质量详情")
        hideView1.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        
        switch ProductInfo.getDeviceClassFromProductID(productID: (device?.deviceInfo.productID)!) {
        case .AirPurifier_Blue:
            reSetLvXinButton.setTitle("重置滤芯", for: UIControlState.normal)
            reSetLvXinButton.isHidden=false
            vocWidthConstraint.constant = -width_screen/2
            //hiden
            totalPurificatContainerView.removeFromSuperview()
            pm25ValueLabel.text="\(Int((device as! AirPurifier_Blue).sensor.PM25))"
            SetLvXin(workTime: Int((device as! AirPurifier_Blue).filterStatus.workTime), maxUseMM: 60000)
        case .AirPurifier_Wifi:
            reSetLvXinButton.setTitle("绑定滤芯", for: UIControlState.normal)
            reSetLvXinButton.isHidden=false
            vocWidthConstraint.constant = 0
            totalPurificatContainerView.isHidden=false
            pm25ValueLabel.text="\((device as! AirPurifier_Wifi).sensor.PM25)"
            var vocValue = (device as! AirPurifier_Wifi).sensor.VOC
            vocValue = vocValue<0||vocValue>3 ? 4:vocValue
            vocValueLabel.text=[loadLanguage("优"),loadLanguage("良"),loadLanguage("一般"),loadLanguage("差"),"-"][Int(vocValue)]
            totalValueLabel.text="\((device as! AirPurifier_Wifi).sensor.TotalClean)"
            print((device as! AirPurifier_Wifi).sensor.TotalClean)
            SetLvXin(workTime: (device as! AirPurifier_Wifi).filterStatus.workTime, maxUseMM: 129600)
        case .NewTrendAir_Wifi:
            
            vocWidthConstraint.constant = 0
            totalPurificatContainerView.isHidden=false
            pm25ValueLabel.text="\((device as! AirPurifier_Wifi).sensor.PM25)"
            var vocValue = (device as! AirPurifier_Wifi).sensor.VOC
            vocValue = vocValue<0||vocValue>3 ? 4:vocValue
            vocValueLabel.text=[loadLanguage("优"),loadLanguage("良"),loadLanguage("一般"),loadLanguage("差"),"-"][Int(vocValue)]
            totalValueLabel.text="\((device as! AirPurifier_Wifi).sensor.TotalClean)"
            print((device as! AirPurifier_Wifi).sensor.TotalClean)
            SetLvXin(workTime: (device as! AirPurifier_Wifi).filterStatus.workTime, maxUseMM: 129600)
        default:
            break
        }
        
        // Do any additional setup after loading the view.
    }

    func SetLvXin(workTime:Int,maxUseMM:Int) {
        starDateLabel.text=""
        nowDateLabel.text=""
        stopDateLabel.text=""
        if workTime == -1 {
            lvxinValueLabel.text="--"
            imgWidthConstraint.constant=0
        }else{
            //let starDate = lastDate!
            //let nowDate = NSDate()
            //let stopDate = (lastDate?.addingMonths(maxUseMonth))! as NSDate
            
            
            //starDateLabel.text="\(starDate.year())\n"+starDate.formattedDate(withFormat: "MM-dd")
            //nowDateLabel.text="\(nowDate.year())\n"+nowDate.formattedDate(withFormat: "MM-dd")
            //stopDateLabel.text="\(stopDate.year())\n"+stopDate.formattedDate(withFormat: "MM-dd")
            
            //var lvxinValue = 1-CGFloat(nowDate.timeIntervalSince1970-starDate.timeIntervalSince1970)/CGFloat(stopDate.timeIntervalSince1970-starDate.timeIntervalSince1970)
            var lvxinValue=1-CGFloat(workTime)/CGFloat(maxUseMM)
            lvxinValue=min(1, lvxinValue)
            lvxinValue=max(0, lvxinValue)
            lvxinValueLabel.text="\(Int(lvxinValue*100))"
            imgWidthConstraint.constant=lvxinValue*width_screen*292/375
            switch true {
            case lvxinValue==0:
                lvxinImg.image=UIImage(named: "airLvxinState0")
            case lvxinValue>0&&lvxinValue<=0.4:
                lvxinImg.image=UIImage(named: "airLvxinState1")
            case lvxinValue>0.4&&lvxinValue<=0.6:
                lvxinImg.image=UIImage(named: "airLvxinState2")
            case lvxinValue>0.6&&lvxinValue<1:
                lvxinImg.image=UIImage(named: "airLvxinState3")
            default:
                lvxinImg.image=UIImage(named: "airLvxinState4")
            }
        }
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
        if segue.identifier == "showBuyAirLvXin" {
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail64_1"))!, Type: 0)
            vc.title=loadLanguage("购买空净滤芯")
        }
        if segue.identifier=="showWhatIsPM25"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是PM25"]?.stringValue)!, Type: 2)
            vc.title=loadLanguage("什么是PM25")
        }
        if segue.identifier=="showWhatIsVOC"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是VOC"]?.stringValue)!, Type: 2)
            vc.title=loadLanguage("什么是VOC")
        }
    }
    
    fileprivate func getFilterInfo(_ str:String) {
        User.getFilterNoInfo(deviceType: str, success: { (data) in
            
            let json1 = JSON(data)
            if json1["state"].intValue >= 1 {
                
                let filterLifeDay = json1["filterLifeDay"].intValue
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    dynamicAnimatorActive: true
                )
                let alert=SCLAlertView(appearance: appearance)
                _=alert.addButton(loadLanguage("否")) {
                }
                _=alert.addButton(loadLanguage("是")) {
                    
                    let device=OznerManager.instance.currentDevice as! AirPurifier_Wifi

                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        
                        device.addTimeToDevice(filterLifeDay)

                    }
                    self.bindFilterInfo(str, deviceId: device.deviceInfo.deviceMac)
                    
                }
                
                _=alert.showInfo("", subTitle: loadLanguage("您是否绑定此滤芯?"))
                
            } else {
                DispatchQueue.main.async {
                    self.noticeOnlyText("此二维码已失效")
                }
            }
            
            
            
        }, failure: { (error) in
            
        })
    }
    
    fileprivate func bindFilterInfo(_ str:String,deviceId:String) {
    
        User.getFilterNoInfo(deviceId: deviceId, filter_no: str, success: { (data) in
            
            let json1 = JSON(data)
            if json1["state"].intValue >= 1 {
                DispatchQueue.main.async {
                    self.noticeOnlyText("绑定成功")
                }
            }
            
        }) { (error) in
            
            self.noticeOnlyText("绑定失败")
            
        }
    
    
    }
    

}
