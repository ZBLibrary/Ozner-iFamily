//
//  SkinHeadTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinHeadTableViewCell_EN: UITableViewCell {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skinLabel: UILabel!
    @IBOutlet weak var skinStateLabel: UILabel!
    @IBOutlet weak var skinImg: UIImageView!
    @IBOutlet weak var skinDescripe: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        skinDescripe.textColor=UIColor.white
        //updateCell(0, sexImgHeadStr: "woman")
        // Configure the view for the selected state
    }
    
    fileprivate let skinTextArr=["暂无","干性皮肤","油性皮肤","中性皮肤"]
    fileprivate let skinDescripeText=[
        "数据累计不足，无法查询到您的肤质类型，请再接再厉",
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱，定期使用适量精华补水也能改善您的干性特质哦！",
        "皮肤通道是先吸收水，再吸收油。当肌底极度缺水干燥的时候，为保护皮肤，油脂才会分泌过盛。水油已严重失衡啦，请注意控油补水！",
        "干性肌需要进行深层补水，另外，肌肤营养缺乏会加速保水能力衰弱！"
    ]
    /**
     传入皮肤类型更新视图
     
     - parameter currentSkin: 0 无类型，1 干，2 油，3 中     - parameter sexImgHeadStr:"man" 或"woman"
     */
    func updateCell(_ currentSkin:Int,sex:SexType)
    {
        skinLabel.text=skinTextArr[currentSkin]
        skinStateLabel.text = currentSkin==0 ? "您还从未检测过哦":"通过数据累计统计，仅供参考。"
        skinImg.image=UIImage(named: (sex==SexType.Man ? "man":"woman")+"SkinOfChaXun\(currentSkin)")
        skinDescripe.text=skinDescripeText[currentSkin]
       // skinStateLabel.adjustsFontSizeToFitWidth
        
    }
}
