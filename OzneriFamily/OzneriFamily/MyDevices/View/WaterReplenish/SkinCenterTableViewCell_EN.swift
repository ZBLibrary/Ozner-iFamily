//
//  SkinCenterTableViewCell.swift
//  OZner
//
//  Created by 赵兵 on 16/3/10.
//  Copyright © 2016年 sunlinlin. All rights reserved.
//

import UIKit

class SkinCenterTableViewCell_EN: UITableViewCell {

    @IBOutlet weak var timesOfTest: UILabel!
    @IBOutlet weak var stateOfTest: UILabel!
    @IBOutlet weak var dateOfTest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     更新数据
     
     - parameter times: 检测次数
     - parameter Date:  统计时间
     */
    func updateData(_ times:Int,Date:String)
    {
        print(times)
        timesOfTest.text = times<45 ? "\(times)/45":"\(times)"
        stateOfTest.text = times<45 ? loadLanguage("检测次数累计达45次才能给您相对精准的数据"):""
        dateOfTest.text="\("统计时间"):"+Date
    }
}
