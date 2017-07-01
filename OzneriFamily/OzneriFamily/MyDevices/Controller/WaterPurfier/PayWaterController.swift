//
//  PayWaterController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/6/5.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit
struct WaterCardStruct {
    var ProductId:Int
    var OrderId:Int
    var OrderDtlId:Int
    var LimitTimes:Int
    var OrginOrderCode:String
    var UCode:Int
    var Days:Int
    var IsUsed:Bool
}
class PayWaterController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var payWaterButton: UIButton!
    var dataArr:[WaterCardStruct]!
    //var errorState = [-1:"服务器错误",2:"当前没有该充水卡信息",3:"当前水卡已使用",4:"当前水卡没有绑定水机(试用水卡)",5:"该水机已使用过试用水卡",6:"当前mac地址没有对应的水机信息(不是试用水卡)",7:"当前水机未开户",9:"水卡信息无效",10:"当前会员没有支付安装费用",11:"当前水机没有支付安装费用",97:"服务器异常",98:"当前参数Json数据有误"]
    
    @IBAction func payWaterClick(_ sender: UIButton) {
        //
        if dataArr[selectRow].IsUsed {
            return
        }
        let alertView=SCLAlertView()
        if OznerManager.instance.currentDevice?.connectStatus != OznerConnectStatus.Connected       {
            _=alertView.showTitle("", subTitle: "设备已断开!检查设备或手机蓝牙是否链接正常", duration: 3.0, completeText: "确定", style: SCLAlertViewStyle.error)
            return
        }
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.showProgress(0)
        
        let weakSelf=self
        let RODevice = OznerManager.instance.currentDevice as! WaterPurifier_Blue
        DispatchQueue.global().async {
            if RODevice.addWaterDays(days: Int(self.dataArr[self.selectRow].Days))
            {
                //设备充值成功
                User.UseWaterCard(cardinfo: self.dataArr[self.selectRow], Mac: RODevice.deviceInfo.deviceMac, success: { () in
                    //充值成功
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false,
                            dynamicAnimatorActive: true
                        )
                        let alert=SCLAlertView(appearance: appearance)
                        _=alert.addButton("ok") {
                            weakSelf.refreshData()
                        }
                        _=alert.showInfo("", subTitle: "恭喜您，冲水成功!")
                    }
                
                }, failure: { (error) in
                    //充值失败
                    DispatchQueue.global().async{
                        RODevice.addWaterDays(days: -Int(weakSelf.dataArr[weakSelf.selectRow].Days))
                    }

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        _=alertView.showTitle("", subTitle: error.localizedDescription, duration: 3.0, completeText: "确定", style: SCLAlertViewStyle.error)
                    }
                })
            }
            else{
                
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    //充值失败
                    _=alertView.showTitle("", subTitle: "充值失败!检查设备或手机蓝牙是否链接正常", duration: 3.0, completeText: "确定", style: SCLAlertViewStyle.error)
                }
            }
        }
        
    }
    
    var selectRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UINib.init(nibName: "PayWaterCell", bundle: nil), forCellReuseIdentifier: "PayWaterCell")
        dataArr=[WaterCardStruct]()
        tableview.rowHeight=95*width_screen/250-20
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshData() {
        //获取数据
        let weakSelf = self
        
        dataArr=[WaterCardStruct]()
        User.GetWaterCardList(success: { (arr) in
            self.dataArr=arr
            DispatchQueue.main.async(execute: {
                weakSelf.tableview.isHidden = weakSelf.dataArr.count==0
                weakSelf.payWaterButton.isHidden = weakSelf.dataArr.count==0
                weakSelf.tableview.reloadData()
            })
        }) { (error) in
            weakSelf.tableview.isHidden = weakSelf.dataArr.count==0
            weakSelf.payWaterButton.isHidden = weakSelf.dataArr.count==0
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="buywater" {
            let vc=segue.destination as! AboutDeviceController
            vc.title=""
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("buyWaterCard"))!, Type: 0)
        }        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
extension PayWaterController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //selectRow=indexPath.row
        if !dataArr[indexPath.row].IsUsed {
            
            let cell2 = tableview.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as! PayWaterCell
            cell2.selectImg.image=UIImage(named:"未选择")
            let cell1 = tableview.cellForRow(at: indexPath) as! PayWaterCell
            cell1.selectImg.image=UIImage(named:"已选择")
            selectRow=indexPath.row
        }
    }
}
extension PayWaterController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(dataArr)
        let cell=tableview.dequeueReusableCell(withIdentifier: "PayWaterCell") as! PayWaterCell
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.cardImg.image=UIImage(named: [0:"维修卡",1:"试用卡",6:"半年卡",12:"一年卡"][dataArr[indexPath.row].LimitTimes]!)
        cell.useImg.isHidden = !dataArr[indexPath.row].IsUsed//true
        cell.selectImg.isHidden = !cell.useImg.isHidden
        cell.selectImg.image=UIImage(named: indexPath.row==selectRow ? "已选择":"未选择")
        return cell
    }
 
    
}
