//
//  CenterWaterSettingVc.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/11/6.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/6  下午2:39
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

fileprivate struct gy_associatedKeys{
    
    static var imageKey = "imageKey"
    
}

struct CenterWaterModel {
    var name = ""
    var setTime = ""
    var key = ""
}

extension CenterWaterSettingVc: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2:
            return 0
        default:
            return sectionNum
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GYCenterWaterCellD") as! GYCenterWaterCell
        let model = dataArr[indexPath.row]
        cell.reloadUI(model,index:indexPath.row)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isCanEdit {
            self.noticeOnlyText("请选择自定义模式进行设置")
            return
        }
        
        var model = dataArr[indexPath.row]
        
        switch indexPath.row {
        case 0...6:
            let alert = SCLAlertView()
            let txt = alert.addTextField("请输入")
            alert.addButton("确定") {
                print("Text value: \(String(describing: txt.text))")
                if txt.text?.count == 0 || txt.text == nil {
                    return
                }
                model.setTime = txt.text!
                self.dataArr[indexPath.row] = model
                self.tableView.reloadData()
            }
            alert.addButton("取消") {
                
            }
            alert.showEdit("温馨提示", subTitle: "请设置"+model.name)
            break
        case 7:
            pickDateView=Bundle.main.loadNibNamed("TapDatePickerView", owner: nil, options: nil)?.last as? TapDatePickerView
            pickDateView?.datePicker.minimumDate = Date.init()
            pickDateView?.datePicker.datePickerMode = .time
    
            pickDateView?.datePicker.maximumDate = Date.init(timeIntervalSinceNow: 24 * 60 * 60)
            pickDateView?.datePicker.datePickerMode = .dateAndTime
            pickDateView?.frame=CGRect(x: 0, y: 0, width: width_screen, height: height_screen - 64)
            pickDateView?.cancelButton.addTarget(self, action: #selector(pickerCancle), for: .touchUpInside)
            pickDateView?.OKButton.addTarget(self, action: #selector(pickerOK), for: .touchUpInside)
            view.addSubview(pickDateView!)
            break
        default:
            break
        }
 
    }
    
    func pickerOK()  {
        let date = pickDateView!.datePicker.date as NSDate
        print(date.formattedDate(withFormat: "HH:mm"))
        DispatchQueue.main.async {

            var model = self.dataArr[7]
            model.setTime = date.formattedDate(withFormat: "HH:mm")
            self.dataArr[7] = model
            self.pickDateView?.removeFromSuperview()
        
            self.tableView.reloadRows(at: [IndexPath(item: 7, section: 1)], with: UITableViewRowAnimation.none)
        }
    }
    
    func pickerCancle() {
        pickDateView?.removeFromSuperview()
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CenterWaterSettingVc.tapFloderAction(_:)))
        
        tap.isEnabled = true
        
        if section == 1 {
            let headView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "CenterHeadViewID") as! CenterHeadView
            headView.isUserInteractionEnabled = true
            headView.addGestureRecognizer(tap)
            headView.block = { (index) -> Void in
                
                self.sectionNum = 8
//                self.isCanEdit = index == 555 ? false :true
                self.tableView.reloadData()
                
            }
            
            objc_setAssociatedObject(self, &gy_associatedKeys.imageKey, headView.rightImage, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return headView
        }
        
        let headView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeadViewID") as! TableHeadView
        headView.actionBtn.tag = section + 666
        if section == 0 {
            headView.nameLb.text = self.getNameAndAttr()
        } else {
            headView.deviceLb.text = "关于中央净水机"
            headView.nameLb.text = "我的水机"
        }
        headView.actionBtn.addTarget(self, action: #selector(CenterWaterSettingVc.actionBtn(_:)), for: UIControlEvents.touchUpInside)
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func actionBtn(_ sender:UIButton) {
        
        switch sender.tag {
        case 666:
            self.performSegue(withIdentifier: "ShowCenterVc", sender: nil)
            break
        case 668:
            break
        default:
            break
        }
        
    }
    
    func tapFloderAction(_ tap:UITapGestureRecognizer) {
        
        let imageView = objc_getAssociatedObject(self, &gy_associatedKeys.imageKey) as! UIImageView
        
        sectionNum = sectionNum == 8 ? 0 : 8
        if sectionNum == 0 {
            
            UIView.animate(withDuration: 1) {
                
                imageView.transform =  .identity
            }
        } else {
            UIView.animate(withDuration: 1) {
                
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                
            }
        }
        tableView.reloadData()
    }
    
}

class CenterWaterSettingVc: DeviceSettingController {
    
    var tableView:UITableView!
    var sectionNum:Int = 0
    
    var isCanEdit:Bool = true
    
    var pickDateView:TapDatePickerView?
    
    var dataArr:[CenterWaterModel] = []
    
    @IBAction func saveAction(_ sender: Any) {
        
        var  arr:[MqttSendStruct] = []
 
        for item in dataArr {
            
            let model = MqttSendStruct(key: item.key, value: Int(item.setTime) ?? 0, type: "Integer")
            arr.append(model)
        }
        
        let device = OznerManager.instance.currentDevice as! CenterWater
        device.SendDataToDevice(sendData: OznerTools.mqttModelToData(arr)) { (error) in
            if error != nil {
                print(error!)
            }
        }
        
        self.saveDevice()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "设置"
        
        let device = OznerManager.instance.currentDevice as! CenterWater
        
        dataArr = [CenterWaterModel(name: "居家反冲洗周期", setTime: "\(device.centerConfig.HomeWashCycle)",key:"HomeWashCycle"),                   CenterWaterModel(name: "出差反冲洗周期", setTime: "\(device.centerConfig.TravelWashCycle)",key:"TravelWashCycle"),
            CenterWaterModel(name: "周期制水量", setTime: "\(device.centerConfig.WaterLimit_1Cycle)",key:"WaterLimit_1Cycle"),
            CenterWaterModel(name: "居家反洗持续时间", setTime: "\(device.centerConfig.HomeNtvTime)",key:"HomeNtvTime"),
        CenterWaterModel(name: "居家正洗持续时间", setTime: "\(device.centerConfig.HomePtvTime)",key:"HomePtvTime"),
        CenterWaterModel(name: "出差反洗持续时间", setTime: "\(device.centerConfig.TravelNtvTime)",key:"TravelNtvTime"),
        CenterWaterModel(name: "出差正洗持续时间", setTime: "\(device.centerConfig.TravelPtvTime)",key:"TravelPtvTime"),
        CenterWaterModel(name: "执行反冲洗时间点", setTime: "\(device.centerConfig.WashTimeNode)",key:"WashTimeNode")]
        
        tableView = UITableView(frame: view.frame, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "TableHeadView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeadViewID")
        tableView.register(UINib.init(nibName: "CenterHeadView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CenterHeadViewID")
        tableView.register(UINib.init(nibName: "GYCenterWaterCell", bundle: nil), forCellReuseIdentifier: "GYCenterWaterCellD")
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: width_screen, height: 200))
        footView.addSubview(deleBtn)
        deleBtn.addTarget(self, action: #selector(CenterWaterSettingVc.deleteAction), for: UIControlEvents.touchUpInside)
        tableView.tableFooterView = footView
        
    }
    
    func deleteAction() {
        
        super.deleteDevice()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var deleBtn: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 80, y: 80, width: width_screen - 160, height: 50))
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.setTitle("删除此设备", for: UIControlState.normal)
        btn.backgroundColor = UIColor(red: 245.0 / 255.0, green: 71.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
        
        return btn
    }()
    
}
