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
        default:
            break
        }
 
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
                self.isCanEdit = index == 555 ? false :true
                self.tableView.reloadData()
                
            }
            
            objc_setAssociatedObject(self, &gy_associatedKeys.imageKey, headView.rightImage, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return headView
        }
        
        let headView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeadViewID") as! TableHeadView
        headView.actionBtn.tag = section + 666
        if section == 0 {
            headView.nameLb.text = self.getNameAndAttr()
        }
        headView.actionBtn.addTarget(self, action: #selector(CenterWaterSettingVc.actionBtn(_:)), for: UIControlEvents.touchUpInside)
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
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
    
    var isCanEdit:Bool = false
    
    var dataArr:[CenterWaterModel] = [] {
        didSet{
//            tableView.reloadData()
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        self.saveDevice()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "设置"
        
        
        
        dataArr = [CenterWaterModel(name: "居家反冲洗周期", setTime: "7"),                   CenterWaterModel(name: "出差反冲洗周期", setTime: "3"),
            CenterWaterModel(name: "周期制水量", setTime: "2.5"),
            CenterWaterModel(name: "居家反洗持续时间", setTime: "15"),
        CenterWaterModel(name: "居家正洗持续时间", setTime: "8"),
        CenterWaterModel(name: "出差反洗持续时间", setTime: "4"),
        CenterWaterModel(name: "出差正洗持续时间", setTime: "4"),
        CenterWaterModel(name: "执行反冲洗时间点", setTime: "02：00")]
        
        tableView = UITableView(frame: view.frame, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "TableHeadView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeadViewID")
        tableView.register(UINib.init(nibName: "CenterHeadView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CenterHeadViewID")
        tableView.register(UINib.init(nibName: "GYCenterWaterCell", bundle: nil), forCellReuseIdentifier: "GYCenterWaterCellD")
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
