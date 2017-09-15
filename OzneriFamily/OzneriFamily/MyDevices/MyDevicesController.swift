//
//  MyDevicesController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import SwiftyJSON
class MyDevicesController: UIViewController {

    @IBOutlet var deviceNameLabel: UILabel!//设备名称
    @IBOutlet var deviceConnectStateLabel: UILabel!//设备连接状态
    @IBOutlet var deviceViewContainer: DeviceViewContainer!//自定义视图容器，加载设备自定义视图
    //@IBOutlet var centerViewContainer: UIView!//中部视图容器（包括电量，滤芯状态，设置）,主要用于centerViewContainer是否隐藏
    @IBOutlet var bottomOfCenterViewContainer: NSLayoutConstraint!//调整centerViewContainer的距离底部位置
    @IBOutlet var batteryViewContainer: UIView!//电量容器,作用隐藏与否
    @IBOutlet var batteryImg: UIImageView!
    @IBOutlet var batteryValueLabel: UILabel!
    
    @IBOutlet var filterViewContainer: UIView!//滤芯容器,作用隐藏与否
    @IBOutlet var filterImg: UIImageView!
    @IBOutlet var filterValueLabel: UILabel!
    @IBOutlet var filterStateLabel: UILabel!
    @IBOutlet var settingButton: UIButton!//设置
    
    
    @IBAction func lvXinClick(_ sender: AnyObject) {
        
        switch  ProductInfo.getCurrDeviceClass() {
        case .Tap:
           self.performSegue(withIdentifier: "toTapLvXin", sender: nil)
        case .WaterPurifier_Wifi:
            
            if (OznerManager.instance.currentDevice as? WaterPurifier_Wifi)?.deviceInfo.productID == "adf69dce-5baa-11e7-9baf-00163e120d98" {
                let vc = RoWaterPuefierLvXinController()
                vc.typeBLE = false
                self.navigationController?.pushViewController(vc, animated: true)
                
               return
            }
            
            let tmpDeviceView = deviceViewContainer.currentDeviceView as! WaterPurifierMainView
            let senderData=["buyLvXinUrl":tmpDeviceView.buyLvXinUrl,
             "scanEnable":tmpDeviceView.scanEnable,
             "lvXinStopDate":tmpDeviceView.lvXinStopDate,
             "lvXinUsedDays":tmpDeviceView.lvXinUsedDays] as [String : Any]
            self.performSegue(withIdentifier: "toTapLvXin", sender: senderData)
        case .AirPurifier_Wifi,.AirPurifier_Blue:
            self.performSegue(withIdentifier: "showAirLvXin", sender: nil)
        case .WaterPurifier_Blue:
            let vc = RoWaterPuefierLvXinController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

    }
    @IBAction func toDeviceSettingClick(_ sender: AnyObject) {//点击设置按钮事件
        
        switch  ProductInfo.getCurrDeviceClass() {
        case .Cup:
            self.performSegue(withIdentifier: "showCupSetting", sender: nil)
        case .Tap:
            self.performSegue(withIdentifier: "showTapSetting", sender: nil)
        case .TDSPan:
            self.performSegue(withIdentifier: "showTDSPanSetting", sender: nil)
        case .WaterPurifier_Blue,.WaterPurifier_Wifi:
            self.performSegue(withIdentifier: "showWaterPurfierSetting", sender: nil)
        case .AirPurifier_Blue,.AirPurifier_Wifi:
            self.performSegue(withIdentifier: "showAirSetting", sender: nil)
        case .WaterReplenish:
            self.performSegue(withIdentifier: "showWaterReplenishSetting", sender: nil)
            //MARK: - TODO:
        case .Electrickettle_Blue:
            self.performSegue(withIdentifier: "ShowElectrickettleSetting", sender: nil)
        case .WashDush_Wifi:
            self.performSegue(withIdentifier: "showTDSPanSetting", sender: nil)
        }
    }
    @IBAction func leftMenuClick(_ sender: UIButton) {//左菜单点击按钮
        self.toggleLeft()       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceViewContainer.delegate=self

        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleBottomMargin]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //因为在autolayout下，页面会在viewDidAppear之前根据subview的constraint重新计算scrollview的contentsize。 这就是为什么，在viewdidload里面手动设置了contentsize没用。因为在后面，会再重新计算一次，前面手动设置的值会被覆盖掉。
//        if ProductInfo.getCurrDeviceClass() == .Electrickettle_Blue {
//            
//            (deviceViewContainer.currentDeviceView as! ElectrickettleMainView).scrollerView.contentSize = CGSize(width: width_screen, height: 550)
//            
//        }
        
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deviceViewContainer.SetDeviceAndView()
//        self.navigationController?.navigationBar.isHidden=true
        navigationController?.setNavigationBarHidden(true, animated: false)
//        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleBottomMargin]
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
  
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoginManager.instance.mainTabBarController?.setTabBarHidden(false, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.slideMenuController()?.removeLeftGestures()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showBuyLvXin"://AboutDeviceController
            let aboutVC = segue.destination as! AboutDeviceController
            aboutVC.title=(sender as! NSDictionary).object(forKey: "title") as! String?
            aboutVC.setLoadContent(content: ((sender as! NSDictionary).object(forKey: "url") as! String?)!, Type: 0)
        case "showCupSetting","showTapSetting":
            break
        case "showSeeSkin"://补水仪
            let vc = segue.destination as! SkinQueryController
            vc.currentSkinTypeIndex=(sender as! [String:Int])["currentSkinTypeIndex"]!
            vc.totalTimes=(sender as! [String:Int])["totalTimes"]!
        case "showSkinDetail"://补水仪
            let vc = segue.destination as! SkinDetailController
            vc.currentBody=sender as! BodyParts
            break
        case "toTapLvXin"://水机探头滤芯详情
            let vc = segue.destination as! TapLvXinController
            vc.waterPurfierData=sender as! [String : Any]?
            break
            
        default:
            break
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
//DeviceViewContainerDelegate代理方法
extension MyDevicesController : DeviceViewContainerDelegate{
    
    func PresentModelController(controller:UIViewController)//弹出模态视图
    {
        
        weak var weakSelf=self
        self.present(controller, animated: false) {
            weakSelf?.closeLeft()
        }
    }
    func DeviceNameChange(name: String) {
        deviceNameLabel.text=name
    }
    func DeviceConnectStateChange(stateDes: String) {
        deviceConnectStateLabel.text=stateDes
    }
    func WhitchCenterViewIsHiden(SettingIsHiden:Bool,BateryIsHiden:Bool,FilterIsHiden:Bool,BottomValue:CGFloat){
        settingButton.isHidden=SettingIsHiden
        batteryViewContainer.isHidden=BateryIsHiden
        filterViewContainer.isHidden=FilterIsHiden
        bottomOfCenterViewContainer.constant=BottomValue
    }
    //0-100，<0表示无
    func BateryValueChange(value:Int){
        switch true {
        case value<0:
            batteryImg.image=UIImage(named: "dian_liang_0")
            batteryValueLabel.text="-"
        case value==0:
            batteryImg.image=UIImage(named: "dian_liang_0")
            batteryValueLabel.text="0%"
        case value>0&&value<=30:
            batteryImg.image=UIImage(named: "dian_liang_30")
            batteryValueLabel.text="\(value)%"
        case value>30&&value<=70:
            batteryImg.image=UIImage(named: "dian_liang_70")
            batteryValueLabel.text="\(value)%"
        case value>70:
            batteryImg.image=UIImage(named: "dian_liang_100")
            batteryValueLabel.text="\(min(value, 100))%"
        default:
            
            break
        }
    }
    func FilterValueChange(value:Int){
        switch true {
        case value==65535:
            filterImg.image=UIImage(named: "airLvxinState0")
            filterValueLabel.text="-"
        case value<=0:
            filterImg.image=UIImage(named: "airLvxinState0")
            filterValueLabel.text="0%"
        case value>0&&value<=40:
            filterImg.image=UIImage(named: "airLvxinState1")
            filterValueLabel.text="\(value)%"
        case value>40&&value<=60:
            filterImg.image=UIImage(named: "airLvxinState2")
            filterValueLabel.text="\(value)%"
        case value>60&&value<100:
            filterImg.image=UIImage(named: "airLvxinState3")
            filterValueLabel.text="\(value)%"
        default:
            filterImg.image=UIImage(named: "airLvxinState4")
            filterValueLabel.text="\(min(value, 100))%"
            break
        }
        filterStateLabel.text = value<30 ? loadLanguage("请及时更换滤芯"):loadLanguage("滤芯状态")
    }//0-100，<0表示无
    
    //页面跳转
    func DeviceViewPerformSegue(SegueID: String,sender: Any?) {
        self.performSegue(withIdentifier: SegueID, sender: sender)
    }
}
//侧滑控制器代理方法
extension MyDevicesController : SlideMenuControllerDelegate {
}
