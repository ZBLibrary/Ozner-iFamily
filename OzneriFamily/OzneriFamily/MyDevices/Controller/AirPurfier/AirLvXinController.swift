//
//  AirLvXinController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class AirLvXinController: UIViewController {

    @IBOutlet var pm25ValueLabel: UILabel!
    @IBOutlet var vocValueLabel: UILabel!
    @IBOutlet var vocWidthConstraint: NSLayoutConstraint!
    @IBOutlet var totalHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalValueLabel: UILabel!
    @IBOutlet var reSetLvXinButton: UIButton!
    @IBAction func reSetLvXinClick(_ sender: AnyObject) {
        let device=LoginManager.instance.currentDevice
        (device as! AirPurifier_Bluetooth).status.resetFilterStatus({ (error) in
        })
    }
    @IBOutlet var lvxinImg: UIImageView!
    @IBOutlet var lvxinValueLabel: UILabel!
    @IBOutlet var starDateLabel: UILabel!
    @IBOutlet var nowDateLabel: UILabel!
    @IBOutlet var stopDateLabel: UILabel!
    @IBOutlet var imgWidthConstraint: NSLayoutConstraint!
    
    
    @IBAction func consultingClick(_ sender: AnyObject) {
         LoginManager.instance.setTabbarSelected(index: 2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let device=LoginManager.instance.currentDevice
        if device.type==OznerDeviceType.Air_Blue.rawValue {//台式
            reSetLvXinButton.isHidden=false
            vocWidthConstraint.constant = -width_screen/2
            totalHeightConstraint.constant = -height_screen*90/667
            pm25ValueLabel.text="\(Int((device as! AirPurifier_Bluetooth).sensor.pm25))"
            SetLvXin(lastDate: (device as! AirPurifier_Bluetooth).status.filterStatus.lastTime as NSDate?, maxUseMonth: 3)
        }else{//立式空净
            reSetLvXinButton.isHidden=true
            vocWidthConstraint.constant = 0
            totalHeightConstraint.constant = 0
            pm25ValueLabel.text="\(Int((device as! AirPurifier_MxChip).sensor.pm25))"
            var vocValue = (device as! AirPurifier_MxChip).sensor.voc
            vocValue = vocValue<0||vocValue>3 ? 4:vocValue
            vocValueLabel.text=["优","良","一般","差","-"][Int(vocValue)]
            totalValueLabel.text="\((device as! AirPurifier_MxChip).sensor.totalClean/1000)"
            if let filter=(device as! AirPurifier_MxChip).status.filterStatus {
                SetLvXin(lastDate: filter.lastTime as NSDate?, maxUseMonth: 12)
            }
            else{
                SetLvXin(lastDate: nil as NSDate?, maxUseMonth: 12)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    func SetLvXin(lastDate:NSDate?,maxUseMonth:Int) {
        if lastDate==nil {
            starDateLabel.text=""
            nowDateLabel.text=""
            stopDateLabel.text=""
            lvxinValueLabel.text="--"
            imgWidthConstraint.constant=0
        }else{
            let starDate = lastDate! 
            let nowDate = NSDate()
            let stopDate = (lastDate?.addingMonths(maxUseMonth))! as NSDate
            
            
            starDateLabel.text="\(starDate.year())\n"+starDate.formattedDate(withFormat: "MM-dd")
            nowDateLabel.text="\(nowDate.year())\n"+nowDate.formattedDate(withFormat: "MM-dd")
            stopDateLabel.text="\(stopDate.year())\n"+stopDate.formattedDate(withFormat: "MM-dd")
            
            var lvxinValue = 1-CGFloat(nowDate.timeIntervalSince1970-starDate.timeIntervalSince1970)/CGFloat(stopDate.timeIntervalSince1970-starDate.timeIntervalSince1970)
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
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBuyAirLvXin" {
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail64_1"))!, isUrl: true)
            vc.title="购买空净滤芯"
        }
    }
    

}
