//
//  MyDevicesController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyDevicesController: UIViewController {

    @IBOutlet var deviceNameLabel: UILabel!//设备名称
    @IBOutlet var deviceConnectStateLabel: UILabel!//设备连接状态
    @IBOutlet var deviceViewContainer: UIView!//自定义视图容器
    @IBOutlet var centerViewContainer: UIView!//中部视图容器（包括电量，滤芯状态，设置，）
    @IBAction func toDeviceSettingClick(_ sender: AnyObject) {//点击设置按钮事件
        
    }
    @IBAction func leftMenuClick(_ sender: UIButton) {//左菜单点击按钮
        self.toggleLeft()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
//    @IBAction func addDeviceClick(_ sender: AnyObject) {
//        let addDeviceNav=UIStoryboard(name: "LeftMenu", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNav") as! UINavigationController
//        weak var weakSelf=self
//        self.present(addDeviceNav, animated: false) {
//            weakSelf?.closeLeft()
//        }
//        
//    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden=true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
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
//侧滑控制器代理方法
extension MyDevicesController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
