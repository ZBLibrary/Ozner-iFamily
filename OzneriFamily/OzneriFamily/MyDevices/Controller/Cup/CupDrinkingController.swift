//
//  CupDrinkingController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/19.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupDrinkingController: UIViewController {

    //header
    @IBAction func shareClick(_ sender: AnyObject) {
    }
    @IBOutlet var drinkValueLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBAction func Consulting(_ sender: UIButton) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    @IBOutlet var tdsStateImg: UIImageView!
    @IBOutlet var tdsStateLabel: UILabel!
    //center
    @IBAction func segValueChange(_ sender: UISegmentedControl) {
        
        leftLabel1.text=["500\nml","3000\nml","3000\nml"][sender.selectedSegmentIndex]
        leftLabel2.text=["300","2000","2000"][sender.selectedSegmentIndex]
        leftLabel3.text=["100","1000","1000"][sender.selectedSegmentIndex]
        bottomLabel1.text=["0h","周一","01"][sender.selectedSegmentIndex]
        bottomLabel2.text=["","周二",""][sender.selectedSegmentIndex]
        bottomLabel3.text=["8","周三","11"][sender.selectedSegmentIndex]
        bottomLabel4.text=["","周四",""][sender.selectedSegmentIndex]
        bottomLabel5.text=["16","周五","21"][sender.selectedSegmentIndex]
        bottomLabel6.text=["","周六",""][sender.selectedSegmentIndex]
        bottomLabel7.text=["23","周日","\(NSDate().daysInMonth())"][sender.selectedSegmentIndex]
        chartView.updateView(segindex: sender.selectedSegmentIndex)
    }
    @IBOutlet var chartView: CupDrinkingChartView!
    
    @IBOutlet var leftLabel1: UILabel!
    @IBOutlet var leftLabel2: UILabel!
    @IBOutlet var leftLabel3: UILabel!
    @IBOutlet var bottomLabel1: UILabel!
    @IBOutlet var bottomLabel2: UILabel!
    @IBOutlet var bottomLabel3: UILabel!
    @IBOutlet var bottomLabel4: UILabel!
    @IBOutlet var bottomLabel5: UILabel!
    @IBOutlet var bottomLabel6: UILabel!
    @IBOutlet var bottomLabel7: UILabel!
    //footer
    @IBAction func buyWaterPurfier(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 1)
    }
    var drinkGoal = 0
    var todayDrink=0
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = LoginManager.instance.currentDevice as! Cup
        let dateStr=NSDate().formattedDate(withFormat: "YYYY-MM-DD")+" 00:00:00"
        drinkGoal=Int(device.settings.get("drink", default: "2000") as! String)!
        if let record = device.volumes.getRecordBy(NSDate(string: dateStr, formatString: "YYYY-MM-DD hh:mm:ss") as Date!)
        {
            if drinkGoal==0 {
                todayDrink=100
                
            }else{
                todayDrink=Int((CGFloat(record.volume)/CGFloat(drinkGoal)) * CGFloat(100))
            }
            drinkValueLabel.text="\(todayDrink)%"
        }else{
            drinkValueLabel.text="-"
        }
        
        switch true
        {
        case todayDrink>=0&&todayDrink<=50:
            tdsStateImg.image=UIImage(named: "waterState3")
            tdsStateLabel.text=loadLanguage("当前喝水量还不够，离“水货”还有一段距离")
        case 50<todayDrink&&todayDrink<=100:
            tdsStateImg.image=UIImage(named: "waterState2")
            tdsStateLabel.text=loadLanguage("健康的身体，需要配合良好的饮水习惯，加油哦！")
        case 100<todayDrink:
            tdsStateImg.image=UIImage(named: "waterState1")
            tdsStateLabel.text=loadLanguage("今日水量已达标，休息，休息一会儿！")
        default:
            tdsStateLabel.text="-"
            break
        }
        //TDS排名
        User.VolumeFriendRank(success: {
            rank in
            self.rankLabel.text = rank==0 ? "-":"\(rank)"
            }, failure: {
            (error) in
                self.rankLabel.text="-"
        })
        
        //chart
        chartView.volumes=device.volumes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.CupTDSDetail)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showHealthyKnow"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["jxszd"]?.stringValue)!, isUrl: true)
            vc.title="健康水知道"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
