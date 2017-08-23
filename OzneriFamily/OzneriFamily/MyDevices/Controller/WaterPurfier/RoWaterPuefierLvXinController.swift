//
//  RoWaterPuefierLvXinController.swift
//  OZner
//
//  Created by 赵兵 on 2016/11/24.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class RoWaterPuefierLvXinController: BaseViewController {

    var currentDevice:WaterPurifier_Blue!
    var typeBLE:Bool = true
    @IBOutlet var fuweiButton: UIButton!
    @IBAction func fuweiClick(sender: UIButton) {
        
        let alert = SCLAlertView()
        alert.addButton(loadLanguage("我知道了")) {
            self.currentDevice.resetFilter()
        }
        alert.addButton(loadLanguage("购买滤芯")) {
            let vc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "AboutDeviceController") as! AboutDeviceController
            //.URL!["URLOfBuyROWater"]?.stringValue)!
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("URLOfBuyROWater"))! , Type: 0)
            vc.title="购买滤芯"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.showInfo("", subTitle: loadLanguage("为了您和您家人的健康，请及时更换滤芯"))
    }
    
    
    @IBOutlet weak var hideImage1: UIImageView!
    @IBOutlet weak var hideView2: UIView!
    @IBOutlet weak var hideView1: UIView!
    @IBOutlet var lvxinAlertLabel: UILabel!
    @IBOutlet var lvxinValueLabelA: UILabel!
    @IBOutlet var lvxinValueLabelB: UILabel!
    @IBOutlet var lvxinValueLabelC: UILabel!
    @IBAction func zixunClick(sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    
    @IBAction func buyLvXinClick(sender: AnyObject) {
        let vc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "AboutDeviceController") as! AboutDeviceController
        vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("URLOfBuyROWater"))!, Type: 0)
        vc.title="购买滤芯"
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        if !typeBLE {
            
            let device = OznerManager.instance.currentDevice as! WaterPurifier_Wifi
            
            self.title=loadLanguage("当前滤芯状态")
            lvxinAlertLabel.text = loadLanguage("清\n洗\n水\n路\n保\n护\n器")
            hideView1.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
            hideView2.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
            hideImage1.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
            lvxinValueLabelA.text="\(device.filterStates.filterA)%"
            lvxinValueLabelB.text="\(device.filterStates.filterB)%"
            lvxinValueLabelC.text="\(device.filterStates.filterC)%"
            
            //timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alertLabelShanShuo), userInfo: nil, repeats: true)
//            let minFilter=min(device.filterStates.filterA, device.filterStates.filterB, device.filterStates.filterC)
            fuweiButton.isHidden = true
            lvxinAlertLabel.text = ""

            
        } else {
        
        currentDevice=OznerManager.instance.currentDevice as! WaterPurifier_Blue
        self.title=loadLanguage("当前滤芯状态")
        lvxinAlertLabel.text = loadLanguage("清\n洗\n水\n路\n保\n护\n器")
        hideView1.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        hideView2.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        hideImage1.isHidden = !(LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber)
        lvxinValueLabelA.text="\(currentDevice.FilterInfo.Filter_A_Percentage)%"
        lvxinValueLabelB.text="\(currentDevice.FilterInfo.Filter_B_Percentage)%"
        lvxinValueLabelC.text="\(currentDevice.FilterInfo.Filter_C_Percentage)%"
        
        //timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alertLabelShanShuo), userInfo: nil, repeats: true)
        let minFilter=min(currentDevice.FilterInfo.Filter_A_Percentage, currentDevice.FilterInfo.Filter_B_Percentage, currentDevice.FilterInfo.Filter_C_Percentage)
        fuweiButton.isHidden = minFilter>0
        lvxinAlertLabel.text = ""
        }
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
