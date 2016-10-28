//
//  LeftMenuController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
enum OznerLeftMenu: Int {
    case main = 0
    case addDevice
}

//var CurrentSelectDeviceID:String?//全局变量，个人中心中可以改变
class LeftMenuController: UIViewController {

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewConst: NSLayoutConstraint!
    var mainViewController: UINavigationController!//设备视图控制器
    var deviceArray:NSArray!//设备数组
    var currentSelectCellIndex:Int=0//当前选中Cell Index
    
    //无设备时添加按钮和显示界面
    //添加设备
    @IBAction func AddDeviceClick(_ sender: UIButton) {
        let addDeviceNav=UIStoryboard(name: "LeftMenu", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNav") as! UINavigationController
        //let rootController = addDeviceNav.viewControllers[0] as! SelectDeviceTableController
        weak var weakSelf=self
        self.present(addDeviceNav, animated: false) {
            weakSelf?.closeLeft()
        }
    }
    @IBOutlet var noDeviceViewContainer: UIView!
    //有设备设备表
    @IBOutlet var tableContainer: UIView!//tableView的容器
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceArray=NSArray()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.rowHeight=90*height_screen/667
        self.tableView.register(UINib(nibName: "LeftMenuDeviceCell", bundle: nil), forCellReuseIdentifier: "LeftMenuDeviceCell")
        // Do any additional setup after loading the view.
        if LoginManager.currentLoginType == .ByEmail {
             topViewConst.constant = 80
            addMyInfoBtn()
        }
       
    }
    
    func addMyInfoBtn() {
        
        let btn = UIButton(frame:  CGRect(x: (SlideMenuOptions.leftViewWidth - 70) / 2, y: 18, width: 70, height: 70))
        btn.setImage(UIImage(named:"My_Unlogin_head"), for: UIControlState.normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(100, -75, 0, 0)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        btn.setTitle("Ozner", for: UIControlState.normal)
        btn.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(headAction), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        
        
    }
    
    func headAction() {
        let c4=UIStoryboard(name: "MainMyCenter", bundle: nil).instantiateInitialViewController() as!UINavigationController

        weak var weakSelf = self
        self.present(c4, animated: false) { 
            weakSelf?.closeLeft()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deviceArray=OznerManager.instance().getDevices() as NSArray!
        tableContainer.isHidden = deviceArray.count==0
        currentSelectCellIndex=0
        for i in 0..<deviceArray.count {
            if (deviceArray[i] as! OznerDevice).identifier==LoginManager.currentDeviceIdentifier
            {
                currentSelectCellIndex=i
                break
            }
        }
        
        self.tableView.reloadData()
        
        self.tableView.selectRow(at: IndexPath(row: currentSelectCellIndex, section: 0), animated: false, scrollPosition: .none)
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

extension LeftMenuController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpDevice = deviceArray[indexPath.row] as! OznerDevice
        LoginManager.currentDeviceIdentifier = tmpDevice.identifier
        currentSelectCellIndex = indexPath.row

        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
}
extension LeftMenuController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "LeftMenuDeviceCell") as! LeftMenuDeviceCell
        cell.device = deviceArray[indexPath.row] as! OznerDevice
        cell.selectionStyle=UITableViewCellSelectionStyle.none
                return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
