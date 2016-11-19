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

    
    var mainViewController: UINavigationController!//设备视图控制器
    var deviceArray:NSArray!//设备数组
    var currentSelectCellIndex:Int=0//当前选中Cell Index
    
    //无设备头像View
    @IBOutlet var heightConstraintOfNoDevice: NSLayoutConstraint!
    @IBOutlet var imgButtonOfNoDevice: UIButton!
    @IBOutlet var nameLabelOfNoDevice: UILabel!
    
    //有设备头像View
    @IBOutlet var ImgButtonOfHaveDevice: UIButton!
    @IBOutlet var nameLabelOfHaveDevice: UILabel!
    @IBOutlet var heightConstraintOfHaveDevice: NSLayoutConstraint!
    
    @IBAction func headImgClick(_ sender: UIButton) {
        closeLeft()
        LoginManager.instance.setTabbarSelected(index: 3)
    }
    //添加设备
    @IBAction func AddDeviceClick(_ sender: UIButton) {
        let addDeviceNav=UIStoryboard(name: "LeftMenu", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNav") as! UINavigationController
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
        if LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber
        {
            heightConstraintOfNoDevice.constant=50
            heightConstraintOfHaveDevice.constant=50
            imgButtonOfNoDevice.isHidden=true
            ImgButtonOfHaveDevice.isHidden=true
            nameLabelOfNoDevice.text=""
            nameLabelOfHaveDevice.text=""
        }else{
            heightConstraintOfNoDevice.constant=110
            heightConstraintOfHaveDevice.constant=110
            imgButtonOfNoDevice.isHidden=false
            ImgButtonOfHaveDevice.isHidden=false
            nameLabelOfNoDevice.text=User.currentUser?.email
            nameLabelOfHaveDevice.text=User.currentUser?.email
        }
        // Do any additional setup after loading the view.
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
            if (deviceArray[i] as! OznerDevice).identifier==LoginManager.instance.currentDeviceIdentifier
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
        LoginManager.instance.currentDeviceIdentifier = tmpDevice.identifier
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
