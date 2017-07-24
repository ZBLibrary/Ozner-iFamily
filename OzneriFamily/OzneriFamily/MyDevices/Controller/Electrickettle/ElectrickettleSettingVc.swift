//
//  ElectrickettleSettingVcViewController.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/7/19.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/7/19  下午8:51
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class ElectrickettleSettingVc: DeviceSettingController {
    
    //MARK: - Attributes

    @IBOutlet weak var nameLb: GYLabel!
    
    @IBOutlet weak var gySwitch: UISwitch!
    
    @IBOutlet weak var timeConstranit: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLb.text=self.getNameAndAttr()
        
         gySwitch.addTarget(self, action:#selector(ElectrickettleSettingVc.switchChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    func switchChanged(_ sender:UISwitch) {
    
        if sender.isOn {
            timeConstranit.constant = 115
        } else {
            timeConstranit.constant = 48
        }
    }
    
    //MARK: - Override
    
    
    override func nameChange(name:String,attr:String) {
        super.nameChange(name: name, attr: attr)
        nameLb.text="\(name)(\(attr))"
        
    }
    
    //MARK: - Initial Methods
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        self.saveDevice()

    }
        
    @IBAction func deleteAction(_ sender: Any) {
        
        super.deleteDevice()
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 666:
            
            self.performSegue(withIdentifier: "ElectriketIdentifier", sender: nil)
            break
        case 777:
            
            self.performSegue(withIdentifier: "ElectricketTimeIdener", sender: nil)
            break
        case 888:
            
            self.performSegue(withIdentifier: "ElectricketTimeIdener", sender: nil)
            break
        default:
            break
        }
        
    }
    //MARK: - Delegate
    
    
    //MARK: - Target Methods
    
    
    //MARK: - Notification Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    
    //MARK: - Privater Methods
    
    
    //MARK: - Setter Getter Methods
    
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        
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
