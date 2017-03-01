//
//  ReplenishSexController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/9.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class ReplenishSexController: BaseViewController {

    var currSetting:DeviceSetting!
    @IBAction func saveClick(_ sender: AnyObject) {
        let newSexStr = sexImg1.isHidden ? loadLanguage("男"):loadLanguage("女")
        let oldSexStr = currSetting.get("sex", default:loadLanguage("女")) as! String
        if newSexStr != oldSexStr {
            currSetting.put("sex", value: newSexStr)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BuShuiYiSexChanged"), object: nil, userInfo: ["sex":newSexStr])
        }
        
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var sexLabel1: UILabel!
    @IBOutlet var sexLabel2: UILabel!
    @IBOutlet var sexImg1: UIImageView!
    @IBOutlet var sexImg2: UIImageView!
    @IBAction func selectClick(_ sender: UIButton) {
        sexImg1.isHidden = !(sender.tag==0)
        sexImg2.isHidden =  !sexImg1.isHidden
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("性别")
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        let sexStr=currSetting.get("sex", default:loadLanguage("女")) as! String
        sexImg1.isHidden = sexStr != loadLanguage("女")
        sexImg2.isHidden = !sexImg1.isHidden
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
