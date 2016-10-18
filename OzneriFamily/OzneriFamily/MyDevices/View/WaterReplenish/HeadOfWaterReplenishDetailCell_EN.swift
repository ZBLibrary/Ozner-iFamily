//
//  HeadOfWaterReplenishDetailCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/8.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit
protocol HeadOfWaterReplenishDetailCell_ENDelegate
{
    func setCurrentOrgan(_ organ:Int)
}
struct HeadOfWaterReplenishStruct {
    var skinValueOfToday:Double=0
    var lastSkinValue:Double=0
    var averageSkinValue:Double=0
    var checkTimes=0
}
class HeadOfWaterReplenishDetailCell_EN: UITableViewCell {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var organImg1: UIImageView!
    @IBOutlet weak var organImg2: UIImageView!
    @IBOutlet weak var organImg3: UIImageView!
    @IBOutlet weak var organImg4: UIImageView!
    
    
    @IBAction func organButton1(_ sender: UIButton) {
        currentOrgan=0
    }
    @IBAction func organButton2(_ sender: UIButton) {
        currentOrgan=1
    }
    @IBAction func organButton3(_ sender: UIButton) {
        currentOrgan=2
    }
    @IBAction func organButton4(_ sender: UIButton) {
        currentOrgan=3
    }
   
    @IBOutlet weak var skinStateOfToday: UILabel!
    @IBOutlet weak var descOfSkinState: UILabel!
    
    @IBOutlet weak var lastCheckValue: UILabel!
    @IBOutlet weak var averageCheckValue: UILabel!
    
    // delege
    var delegate:HeadOfWaterReplenishDetailCell_ENDelegate?
    //当前选中器官
    fileprivate var isFistLoad=true
    var currentOrgan = -1{
        didSet{
            
            if currentOrgan==oldValue
            {
                return
            }
            let tmpName=NSString(format: "WaterReplDetail%d", currentOrgan+1) as String
            
            [organImg1,organImg2,organImg3,organImg4][currentOrgan].image=UIImage(named: "\(tmpName)_1")
    
            if oldValue != -1
            {
                let tmpNameOld=NSString(format: "WaterReplDetail%d", oldValue+1) as String
                [organImg1,organImg2,organImg3,organImg4][oldValue].image=UIImage(named: tmpNameOld)
            }
            if dataDic.count==0
            {
                return
            }
            let tmpStru=dataDic["\(currentOrgan)"]
            print((tmpStru?.skinValueOfToday))
            skinStateOfToday.text = "\(Int((tmpStru?.skinValueOfToday)!))"
            
            if Int((tmpStru?.skinValueOfToday)!)<WaterTypeValue[[.Face,.Eyes,.Hands,.Neck][currentOrgan]]![0]
            {
                descOfSkinState.text=loadLanguage("今日肌肤状态  干燥")
            }
            else if Int((tmpStru?.skinValueOfToday)!)>WaterTypeValue[[.Face,.Eyes,.Hands,.Neck][currentOrgan]]![1]{
                descOfSkinState.text=loadLanguage("今日肌肤状态  水润")
            }
            else
            {
                descOfSkinState.text=loadLanguage("今日肌肤状态  正常")
            }
            
            lastCheckValue.text="\(loadLanguage("上次检测"))"+(NSString(format: "%.1f", (tmpStru?.lastSkinValue)!) as String)+"%"
            averageCheckValue.text="\(loadLanguage("上次检测"))"+(NSString(format: "%.1f", (tmpStru?.averageSkinValue)!) as String)+"%("+(NSString(format: "%d", (tmpStru?.checkTimes)!) as String)+"\(loadLanguage("次")))"
            if isFistLoad==false{
                delegate?.setCurrentOrgan(currentOrgan)
            }
            else{
                isFistLoad=false
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    //key:"0"
    var dataDic=[String:HeadOfWaterReplenishStruct]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    fileprivate let WaterTypeValue=[BodyParts.Face:[32,42],
                                BodyParts.Eyes:[35,45],
                                BodyParts.Hands:[30,38],
                                BodyParts.Neck:[35,45]
    ]
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
