//
//  FooterOfWaterReplenishDetailCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
//key:"0",脸，key:"1",眼，key:"2",手，key:"3",颈
class FooterOfWaterReplenishDetailCell: UITableViewCell,HeadOfWaterReplenishDetailCell_ENDelegate {

    @IBOutlet weak var organLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var chartContainerView: UIView!
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        drawChartView(sender.selectedSegmentIndex)
    }
    @IBOutlet weak var toWhatWater: UIButton!
    @IBOutlet weak var toWhatYoufen: UIButton!
    
    @IBOutlet weak var toChatButton: UIButton!
    @IBOutlet weak var toBuyEssence: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    /**
     HeadOfWaterReplenishDetailCellDelegate代理方法
     设置当前选中器官
     - parameter organ: 当前器官
     */
    
    func setCurrentOrgan(_ organ: Int) {
        currentOrgan=organ
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
//    /**
//    器官部位切换用这个方法
//    
//    - parameter Organ: 器官对应得数字
//    */
//    func updateCellData(Organ:Int)
//    {
//        currentOrgan=Organ
//    }
    fileprivate var currentOrgan = -1 {
        didSet{
            
            if currentOrgan==oldValue||currentOrgan<0||currentOrgan>3
            {
                return
            }
            organLabel.text=[loadLanguage("脸部"),loadLanguage("眼部"),loadLanguage("手部"),loadLanguage("颈部")][currentOrgan]
   
            drawChartView(segmentControl.selectedSegmentIndex)
            
        }
    }
    //key:"0",脸，key:"1",眼，key:"2",手，key:"3",颈
    fileprivate var weekArray=NSMutableDictionary()
    fileprivate var monthArray=NSMutableDictionary()
    /**
     初始化时，传入器官和周月数据
     
     - parameter weekArr:  周数据
     - parameter monthArr: 月数据
     - parameter Organ:    器官对应得数字
     */
    func updateCellData(_ weekArr:NSMutableDictionary,monthArr:NSMutableDictionary,Organ:Int)
    {
        weekArray=weekArr
        monthArray=monthArr
        currentOrgan=Organ
    }
    
    
    /**
     绘制折线图
     - parameter dateType: 0 周，1 月
     */
    fileprivate func drawChartView(_ dateType:Int)
    {
        for view in chartContainerView.subviews
        {
            view.removeFromSuperview()
        }
        let tmpWeek = weekArray.object(forKey: "\(currentOrgan)") ?? [AnyObject]()
        let tmpMonth = monthArray.object(forKey: "\(currentOrgan)") ?? [AnyObject]()
        _ =  dateType==0 ? tmpWeek:tmpMonth
        
//        let lineView=waterReplenishChartView_EN()
//        lineView.drawLineView(Int32(dateType), dataArr: tmpArr as! [AnyObject])
//        chartContainerView.addSubview(lineView)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
}
