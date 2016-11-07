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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        botoomState.text = isBlueToothDevice==true ? "您可以检查设备和手机蓝牙连接状态后再进行配对":"您可以检查设备和手机Wifi连接状态后再进行配对"
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
