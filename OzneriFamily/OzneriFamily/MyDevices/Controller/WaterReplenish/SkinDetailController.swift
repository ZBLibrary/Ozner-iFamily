//
//  SkinDetailController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/2.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SkinDetailController: BaseViewController {

    var currentBody=BodyParts.Face
    
    //header
    @IBAction func shareClick(_ sender: AnyObject) {
    }
    @IBOutlet var bodyPartButton1: UIButton!
    @IBOutlet var bodyPartButton2: UIButton!
    @IBOutlet var bodyPartButton3: UIButton!
    @IBOutlet var bodyPartButton4: UIButton!
    let WaterTypeValue=[BodyParts.Face:[32,42],
                                    BodyParts.Eyes:[35,45],
                                    BodyParts.Hands:[30,38],
                                    BodyParts.Neck:[35,45]]
    var lastTag = -1
    
    @IBAction func bodyPartClick(_ sender: UIButton) {
        if lastTag==sender.tag {
            return
        }
        lastTag=sender.tag
        currentBody=[BodyParts.Face,.Eyes,.Hands,.Neck][sender.tag]
        //header
        for button in [bodyPartButton1,bodyPartButton2,bodyPartButton3,bodyPartButton4] {
            button?.setImage(UIImage(named: "WaterReplDetail\((button?.tag)!+1)"), for: .normal)
        }
        sender.setImage(UIImage(named: "WaterReplDetail\(sender.tag+1)_1"), for: .normal)
        if AvgAndTimesArr.count > sender.tag
        {
            skinValueLabel.text="\(Int((AvgAndTimesArr[sender.tag]?.skinValueOfToday)!))"
            skinStateLabel.text=getTodaySkinState(value: Int((AvgAndTimesArr[sender.tag]?.skinValueOfToday)!))
            lastValueLabel.text="\(loadLanguage("上次检测"))"+(NSString(format: "%.1f", (AvgAndTimesArr[sender.tag]?.lastSkinValue)!) as String)+"%"
            avgValueLabel.text="\(loadLanguage("平均值"))"+(NSString(format: "%.1f", (AvgAndTimesArr[sender.tag]?.averageSkinValue)!) as String)+"%("+(NSString(format: "%d", (AvgAndTimesArr[sender.tag]?.checkTimes)!) as String)+"\(loadLanguage("次")))"
            //更新图标视图
            if let tmpdata = ([WeakData,MonthData][segmentControl.selectedSegmentIndex])[sender.tag] {
                chartView.drawChartView(data: tmpdata, charttype: segmentControl.selectedSegmentIndex)
            }
            
        }else{
            skinValueLabel.text=loadLanguage("暂无")
            skinStateLabel.text=loadLanguage("今日肌肤状态  暂无")
            lastValueLabel.text=loadLanguage("上次检测")+" -%"
            avgValueLabel.text=loadLanguage("平均值")+" -%(-"+loadLanguage("次")+")"
        }
       
        //center
        bodyNameLabel.text=[loadLanguage("脸部"),loadLanguage("眼部"),loadLanguage("手部"),loadLanguage("颈部")][sender.tag]
    }
    @IBOutlet var skinValueLabel: UILabel!
    @IBOutlet var skinStateLabel: UILabel!
    @IBOutlet var lastValueLabel: UILabel!
    @IBOutlet var avgValueLabel: UILabel!
    
    //center
    @IBOutlet var bodyNameLabel: UILabel!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        
        if let tmpdata = ([WeakData,MonthData][segmentControl.selectedSegmentIndex])[currentBody.hashValue] {
            chartView.drawChartView(data: tmpdata, charttype: segmentControl.selectedSegmentIndex)
        }
        weakLabel1.text = sender.selectedSegmentIndex==0 ? loadLanguage("周一"):"\(NSDate().month())月1日"
        weakLabel2.text = sender.selectedSegmentIndex==0 ? loadLanguage("周二"):""
        weakLabel3.text = sender.selectedSegmentIndex==0 ? loadLanguage("周三"):"11"
        weakLabel4.text = sender.selectedSegmentIndex==0 ? loadLanguage("周四"):""
        weakLabel5.text = sender.selectedSegmentIndex==0 ? loadLanguage("周五"):"21"
        weakLabel6.text = sender.selectedSegmentIndex==0 ? loadLanguage("周六"):""
        weakLabel7.text = sender.selectedSegmentIndex==0 ? loadLanguage("周日"):"\(NSDate().daysInMonth())"
    }
    @IBOutlet var chartView: ChartViewOfSkinDetail!
    @IBOutlet var skinDataStateLabel: UILabel!
    @IBOutlet var weakLabel1: UILabel!
    @IBOutlet var weakLabel2: UILabel!
    @IBOutlet var weakLabel3: UILabel!
    @IBOutlet var weakLabel4: UILabel!
    @IBOutlet var weakLabel5: UILabel!
    @IBOutlet var weakLabel6: UILabel!
    @IBOutlet var weakLabel7: UILabel!
    //footer
    @IBAction func ConsultingClick(_ sender: AnyObject) {
        LoginManager.instance.setTabbarSelected(index: 2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllWeakAndMonthData()
        skinDataStateLabel.text=""
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
    //更新图标视图
    func updateChartView(){
        //segmentControl.selectedSegmentIndex //周月
        //currentBody.hashValue //哪个器官数据
    }
    func getTodaySkinState(value:Int) -> String {
        
        if value<WaterTypeValue[currentBody]![0]
        {
            return loadLanguage("今日肌肤状态  干燥")
        }
        else if value>WaterTypeValue[currentBody]![1]{
            return loadLanguage("今日肌肤状态  水润")
        }
        else
        {
            return loadLanguage("今日肌肤状态  正常")
        }
    }
    var AvgAndTimesArr=[Int:HeadOfWaterReplenishStruct]()
    var WeakData=[Int:[WaterReplenishDataStuct]]()
    var MonthData=[Int:[WaterReplenishDataStuct]]()
    //下载周月数据
    func getAllWeakAndMonthData()
    {
        User.GetBuShuiFenBu(mac: LoginManager.instance.currentDeviceIdentifier!, action: currentBody.rawValue, success: { (_, AvgAndTimes, weakdata, monthdata) in
            self.AvgAndTimesArr=AvgAndTimes
            self.WeakData=weakdata
            self.MonthData=monthdata
            print(weakdata)
            print(monthdata)
            self.bodyPartClick([self.bodyPartButton1,self.bodyPartButton2,self.bodyPartButton3,self.bodyPartButton4][self.currentBody.hashValue])
            }, failure: { (error) in
                self.bodyPartClick([self.bodyPartButton1,self.bodyPartButton2,self.bodyPartButton3,self.bodyPartButton4][self.currentBody.hashValue])
        })
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="showBuyWater" {
            let vc = segue.destination as! AboutDeviceController
            vc.title=loadLanguage("购买精华水")
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["buyEssenceWater"]?.stringValue)!, Type: 0)
        }
        if segue.identifier=="showWhatIsWater"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是水分"]?.stringValue)!, Type: 2)
            vc.title=loadLanguage("什么是水分")
        }
        if segue.identifier=="showWhatIsOil"
        {
            let vc=segue.destination as! AboutDeviceController
            
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["什么是油分"]?.stringValue)!, Type: 2)
            vc.title=loadLanguage("什么是油分")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
