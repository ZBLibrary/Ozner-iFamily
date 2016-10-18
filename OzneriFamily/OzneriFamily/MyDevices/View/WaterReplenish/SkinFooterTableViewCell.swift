//
//  SkinFooterTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class  SkinFooterTableViewCell: UITableViewCell {

    //五个按钮背景view的宽度
    @IBOutlet weak var widthOfButtonBG1: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG2: NSLayoutConstraint!
    @IBOutlet weak var widthOfButtonBG3: NSLayoutConstraint!

    fileprivate let buttonContainWidth=(375-50)*width_screen/375
    //五个按钮
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
 
    //肤质图片及说明
    @IBOutlet weak var skinImg: UIImageView!
    @IBOutlet weak var skinState: UITextView!
    //购买精华液
    @IBOutlet weak var bugEssenceButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()

        widthOfButtonBG1.constant=buttonContainWidth/3
        widthOfButtonBG2.constant=buttonContainWidth/3
        widthOfButtonBG3.constant=buttonContainWidth/3

        for button in [button1,button2,button3]
        {
            button?.addTarget(self, action: #selector(skinButtonClick), for: .touchUpInside)
        }
    }
    fileprivate let selectColor=UIColor(red: 64/255.0, green: 140/255.0, blue: 241/255.0, alpha: 1)
    fileprivate var sexImgHeadStr="woman"
    fileprivate var skinStateArr=[
       loadLanguage("干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱，定期使用适量精华补水也能改善您的干性特质哦！"),
       loadLanguage("皮肤通道是先吸收水，再吸收油。当肌底极度缺水干燥的时候，为保护皮肤，油脂才会分泌过盛。水油已严重失衡啦，请注意控油补水！"),
      loadLanguage("干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱！")
    ]
    func skinButtonClick(_ button:UIButton)
    {
        //设置按钮背景色
        for tmpButton in [button1,button2,button3]
        {
            tmpButton?.backgroundColor=UIColor.clear
        }
        button.backgroundColor=selectColor
        //设置选中按钮对应图片
        skinImg.image=UIImage(named: sexImgHeadStr+"SkinOfChaXun\(button.tag)")
        skinState.text=skinStateArr[button.tag-1]
        skinState.textColor=UIColor.white
    }
    
    /**
     传入我的肤质来设置其他皮肤有哪几种
     
     - parameter myFuZhi: 0：无，1油，2干，3中，4混合，5敏感
     */
    func MyCurrentFuZhi(_ myFuZhi:Int,sex:SexType)
    {
        sexImgHeadStr=sex==SexType.Man ? "man":"woman"
        let tmpwidth = myFuZhi==0 ? buttonContainWidth/3:buttonContainWidth/2
        widthOfButtonBG1.constant=tmpwidth
        widthOfButtonBG2.constant=tmpwidth
        widthOfButtonBG3.constant=tmpwidth
        
        if myFuZhi != 0
        {
            [widthOfButtonBG1,widthOfButtonBG2,widthOfButtonBG3][myFuZhi-1].constant=0
            
        }
        //设置首次进入选中
        skinButtonClick(myFuZhi==1 ? button2:button1)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
