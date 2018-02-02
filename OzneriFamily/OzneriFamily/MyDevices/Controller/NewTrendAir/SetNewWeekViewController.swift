//
//  SetNewWeekViewController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2018/1/31.
//  Copyright © 2018年 net.ozner. All rights reserved.
//

import UIKit

class SetNewWeekViewController: BaseViewController {

    var weekValue = 0
    var callblock:((Int)->Void)!
    @IBOutlet var switch0: UISwitch!
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var switch3: UISwitch!
    @IBOutlet var switch4: UISwitch!
    @IBOutlet var switch5: UISwitch!
    @IBOutlet var switch6: UISwitch!
    @IBAction func switchClick(_ sender: UISwitch) {
        let changeValue=(1<<sender.tag)
        weekValue=weekValue+(sender.isOn ? changeValue:(-changeValue))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch0.isOn = weekValue%2==1
        switch1.isOn = (weekValue>>1)%2==1
        switch2.isOn = (weekValue>>2)%2==1
        switch3.isOn = (weekValue>>3)%2==1
        switch4.isOn = (weekValue>>4)%2==1
        switch5.isOn = (weekValue>>5)%2==1
        switch6.isOn = (weekValue>>6)%2==1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callblock(weekValue)
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
