//
//  CupSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/13.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupSettingController: DeviceSettingController {

    @IBAction func backClick(_ sender: AnyObject) {
        self.back()
    }
    @IBAction func saveClick(_ sender: AnyObject) {
        self.saveDevice()
    }
    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var drinkingLabel: UITextField!
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        segLabel1.text = sender.selectedSegmentIndex==0 ? "25°C以下":"健康"
        segLabel2.text = sender.selectedSegmentIndex==0 ? "25°C-50°C":"一般"
        segLabel3.text = sender.selectedSegmentIndex==0 ? "50°C以上":"较差"
    
    }
    @IBOutlet var segLabel1: UILabel!
    @IBOutlet var segLabel2: UILabel!
    @IBOutlet var segLabel3: UILabel!
    
    @IBAction func deletClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAndAttrLabel.text=self.getNameAndAttr()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func nameChange(name:String,attr:String) {
        super.nameChange(name: name, attr: attr)
        nameAndAttrLabel.text="\(name)(\(attr))"
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showAboutDevice" {
            let VC=segue.destination as!  AboutDeviceController
            VC.setLoadContent(content: (NetworkManager.defaultManager?.URL?["AboutCup"]?.stringValue)!, isUrl: true)
        }
    }
 

}
