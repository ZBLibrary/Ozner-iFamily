//
//  RoWaterPuefierLvXinController.swift
//  OZner
//
//  Created by 赵兵 on 2016/11/24.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class RoWaterPuefierLvXinController: BaseViewController {

    var currentDevice:ROWaterPurufier!
    @IBOutlet var fuweiButton: UIButton!
    @IBAction func fuweiClick(sender: UIButton) {
        
        let alert = SCLAlertView()
        alert.addButton("我知道了") {
            self.currentDevice.resetFilter()
        }
        alert.addButton("购买滤芯") {
            LoginManager.instance.setTabbarSelected(index: 1)
        }
        alert.showInfo("", subTitle: "为了您和您家人的健康，请及时更换滤芯")
    }
    
    
    @IBOutlet var lvxinAlertLabel: UILabel!
    @IBOutlet var lvxinValueLabelA: UILabel!
    @IBOutlet var lvxinValueLabelB: UILabel!
    @IBOutlet var lvxinValueLabelC: UILabel!
    @IBAction func zixunClick(sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    
    @IBAction func buyLvXinClick(sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 1)
    }
    @IBAction func buyDeviceClick(sender: UIButton) {
        let vc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "AboutDeviceController") as! AboutDeviceController
        switch sender.tag
        {
        case 0:
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail36"))!, Type: 0)
            vc.title="智能水探头"
        case 1:
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail43"))!, Type: 0)
            vc.title="净水器"
        case 2:
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("goodsDetail7"))!, Type: 0)
            vc.title="智能水杯"
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init() {
        
        var nibNameOrNil = String?("RoWaterPuefierLvXinController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
            
        {
            
            nibNameOrNil = nil
            
        }
        
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    //var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDevice=LoginManager.instance.currentDevice as! ROWaterPurufier
        self.title="当前滤芯状态"
        lvxinValueLabelA.text="\(currentDevice.filterInfo.filter_A_Percentage)%"
        lvxinValueLabelB.text="\(currentDevice.filterInfo.filter_B_Percentage)%"
        lvxinValueLabelC.text="\(currentDevice.filterInfo.filter_C_Percentage)%"
        
        //timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alertLabelShanShuo), userInfo: nil, repeats: true)
        let minFilter=min(currentDevice.filterInfo.filter_A_Percentage, currentDevice.filterInfo.filter_B_Percentage, currentDevice.filterInfo.filter_C_Percentage)
        fuweiButton.isHidden = minFilter>0
        lvxinAlertLabel.text = ""   
        // Do any additional setup after loading the view.
    }
//    var istrue = true
//    
//    func alertLabelShanShuo() {
//        istrue = !istrue
//        lvxinAlertLabel.text = istrue ? "清\n洗\n水\n路\n保\n护\n器":""        
//        if false {
//            timer.invalidate()
//            timer=nil
//        }
//    }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
