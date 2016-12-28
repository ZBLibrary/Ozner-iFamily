//
//  PairFailedController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class PairFailedController: UIViewController {

    var isBlueToothDevice:Bool!
    @IBAction func backClick(_ sender: AnyObject) {        
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func rePairClick(_ sender: AnyObject) {
        if isBlueToothDevice==true {
            let vcs=self.navigationController?.viewControllers
            let vc=vcs?[(vcs?.count)!-2] as! PairingController
            vc.StarBluePair()
        }
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var botoomState: UILabel!
    
    @IBOutlet weak var problmLb: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    @IBOutlet weak var pairLb: UILabel!
    @IBOutlet weak var failedLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = loadLanguage("配对超时")
        self.failedLb.text = loadLanguage("未成功")
        self.pairLb.text = loadLanguage("重新配对")
        self.pairBtn.setTitle(loadLanguage("重新配对"), for: UIControlState.normal)
        self.problmLb.text = loadLanguage("常见问题")
        botoomState.text = isBlueToothDevice==true ?  loadLanguage("您可以检查设备和手机蓝牙连接状态后再进行配对"): loadLanguage("您可以检查设备和手机Wifi连接状态后再进行配对")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
