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
//protocol OznerLeftMenuProtocol : class {
//    func changeViewController(_ menu: OznerLeftMenu)
//}
class LeftMenuController: UIViewController {

    
    var mainViewController: MyDevicesController!
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
        //tableContainer.isHidden=true
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
        self.tableView.rowHeight=90*height_screen/667
        self.tableView.register(UINib(nibName: "LeftMenuDeviceCell", bundle: nil), forCellReuseIdentifier: "LeftMenuDeviceCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
}
extension LeftMenuController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "LeftMenuDeviceCell") as! LeftMenuDeviceCell
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
