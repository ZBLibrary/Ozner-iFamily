//
//  NewAirSetTimeController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/25.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class NewAirSetTimeController: BaseViewController {

    @IBOutlet var segmentButton: UISegmentedControl!
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        containerHeight.constant = sender.selectedSegmentIndex==0 ? 0:150
        dateOnValue=appointTime.onEveryDay
        dateOffValue=sender.selectedSegmentIndex==0 ? appointTime.offOnce:appointTime.offEveryDay
    }
    //PowerOn
    @IBOutlet var PowerOnButton: UIButton!
    @IBAction func PowerOnClick(_ sender: UIButton) {
        dateOnValue = (dateOnValue == -1 ? 0 : -1)
    }
    var dateOnValue = -1{
        didSet{
            PowerOnButton.setTitleColor(dateOnValue != -1 ? UIColor.gray:UIColor.blue, for: .normal)
            PowerOnDatePicker.isEnabled = dateOnValue != -1
        }
    }
    var dateOffValue = -1{
        didSet{
            PowerOffButton.setTitleColor(dateOffValue != -1 ? UIColor.gray:UIColor.blue, for: .normal)
            PowerOffDatePicker.isEnabled = dateOnValue != -1
        }
    }
    @IBOutlet var PowerOnDatePicker: UIDatePicker!
    @IBAction func PowerOnDateClick(_ sender: UIDatePicker) {
        print(sender.date.description)
    }
    //PowerOff
    @IBOutlet var containerHeight: NSLayoutConstraint!
    @IBOutlet var PowerOffButton: UIButton!
    @IBAction func PowerOffClick(_ sender: UIButton) {
        dateOffValue = (dateOffValue == -1 ? 0 : -1)
    }
    @IBOutlet var PowerOffDatePicker: UIDatePicker!
    @IBAction func PowerOffDateClick(_ sender: UIDatePicker) {
        print(sender.date.description)
    }
    @IBAction func SaveClick(_ sender: Any) {
        
        (OznerManager.instance.currentDevice as! NewTrendAir_Wifi).setAppoint(onOffType: appointTime.onOffType, onEveryDay: appointTime.onEveryDay, offEveryDay: appointTime.offEveryDay, offOnce: appointTime.offOnce) { (error) in
        }
    }
    
    var appointTime:(onOffType:Int,onEveryDay:Int,offEveryDay:Int,offOnce:Int) = (-1,-1,-1,-1){
        didSet{
            if appointTime == oldValue {
                return
            }
            
            switch appointTime.onOffType {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            default:
                break
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="预约设置"
        let device=OznerManager.instance.currentDevice as! NewTrendAir_Wifi
        appointTime=device.appointTime
                // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
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
