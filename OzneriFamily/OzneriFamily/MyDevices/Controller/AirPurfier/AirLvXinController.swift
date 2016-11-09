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
    
    
    @IBAction func consultingClick(_ sender: AnyObject) {
    }
    @IBAction func buyLvXinClick(_ sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let device=LoginManager.instance.currentDevice
        if device.type==OznerDeviceType.Air_Blue.rawValue {
            reSetLvXinButton.isHidden=false
            vocWidthConstraint.constant = -width_screen/2
            totalHeightConstraint.constant = -height_screen*90/667
            pm25ValueLabel.text="\(Int((device as! AirPurifier_Bluetooth).sensor.pm25))"
        }else{//立式空净
            reSetLvXinButton.isHidden=true
            vocWidthConstraint.constant = 0
            totalHeightConstraint.constant = 0
            pm25ValueLabel.text="\(Int((device as! AirPurifier_MxChip).sensor.pm25))"
            var vocValue = (device as! AirPurifier_MxChip).sensor.voc
            vocValue = vocValue<0||vocValue>3 ? 4:vocValue
            vocValueLabel.text=["优","良","一般","差","-"][Int(vocValue)]
            totalValueLabel.text="\((device as! AirPurifier_MxChip).sensor.totalClean/1000)"
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
