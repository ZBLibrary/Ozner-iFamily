//
//  PairFailedController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class PairFailedController: UIViewController {

    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
