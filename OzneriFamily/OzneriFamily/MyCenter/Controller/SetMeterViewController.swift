//
//  SetMeterViewController.swift
//  My
//
//  Created by test on 15/11/27.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class SetMeterViewController: UIViewController {

    var Temperature=0
    var WaterMeter=0

    @IBAction func Save(sender: AnyObject) {
        print("保存数据")
        
    }
   
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet var DanWe1: UIImageView!
    @IBOutlet var DanWei2: UIImageView!
    @IBOutlet var DanWei3: UIImageView!
    @IBOutlet var DanWei4: UIImageView!
    @IBOutlet var DanWei5: UIImageView!
    
    @IBAction func DanWeiClick(sender: AnyObject) {
        DanWe1.isHidden=false
        DanWei2.isHidden=true
        Temperature=0
    }
    @IBAction func DanWei2Click(sender: AnyObject) {
        DanWe1.isHidden=true
        DanWei2.isHidden=false
        Temperature=1
    }
    @IBAction func DanWei3Click(sender: AnyObject) {
        DanWei3.isHidden=false
        DanWei4.isHidden=true
        DanWei5.isHidden=true
        WaterMeter=0
    }
    @IBAction func DanWei4Click(sender: AnyObject) {
        DanWei3.isHidden=true
        DanWei4.isHidden=false
        DanWei5.isHidden=true
        WaterMeter=1
    }
    @IBAction func DanWei5Click(sender: AnyObject) {
        DanWei3.isHidden=true
        DanWei4.isHidden=true
        DanWei5.isHidden=false
        WaterMeter=2
    }
    
    @IBOutlet var TemperatureLable: UILabel!
    @IBOutlet var CelsiusLable: UILabel!
    @IBOutlet var FahrenheitLable: UILabel!
    @IBOutlet var WaterLable: UILabel!
    @IBOutlet var MLLable: UILabel!
    @IBOutlet var DLLable: UILabel!
    @IBOutlet var OZLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.title = loadLanguage("保存")
       self.title=loadLanguage("计量单位")
      TemperatureLable.text=loadLanguage("温度")
      CelsiusLable.text=loadLanguage("摄氏度")
      FahrenheitLable.text=loadLanguage("华氏度" )
      WaterLable.text=loadLanguage("水量")
      MLLable.text=loadLanguage("毫升")
      DLLable.text=loadLanguage("分升")
      OZLable.text=loadLanguage("盅司" )

        DanWe1.isHidden=true
        DanWei2.isHidden=true
        DanWei3.isHidden=true
        DanWei4.isHidden=true
        DanWei5.isHidden=true

        if Temperature==0
        {
            DanWe1.isHidden=false
        }
        else
        {
            DanWei2.isHidden=false
        }
        if WaterMeter==0
        {
            DanWei3.isHidden=false
        }
        else if WaterMeter==1
        {
            DanWei4.isHidden=false
        }
        else
        {
            DanWei5.isHidden=false
        }
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
