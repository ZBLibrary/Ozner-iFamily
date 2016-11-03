//
//  CupSettingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/13.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupSettingController: DeviceSettingController {

    @IBOutlet var nameAndAttrLabel: UILabel!
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var drinkingLabel: UITextField!
    @IBAction func deletClick(_ sender: AnyObject) {
        super.deleteDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func nameChange(name:String,attr:String) {
        nameAndAttrLabel.text="\(name)(\(attr))"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
