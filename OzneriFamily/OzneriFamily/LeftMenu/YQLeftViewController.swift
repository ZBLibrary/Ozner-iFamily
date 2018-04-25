//
//  YQLeftViewController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2018/4/18.
//  Copyright © 2018年 net.ozner. All rights reserved.
//

import UIKit

class YQLeftViewController: UIViewController {

    @IBAction func nextClick(_ sender: UIButton) {
        let vc = YQPairingScanViewController()
        vc.pairID="JZY-A2B3"
        
        self.navigationController?.pushViewController(vc, animated: true)
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
