//
//  GYCenterWaterCell.swift
//  WSWaterWaveDemo
//
//  Created by ZGY on 2017/11/3.
//Copyright © 2017年 SongLan. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/3  下午3:04
//  GiantForJade:  Efforts to do my best
//  Real developers ship.


import UIKit

class GYCenterWaterCell: UITableViewCell {

    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func reloadUI(_ model:CenterWaterModel,index:Int) {
        
        nameLb.text = model.name
        
        switch index {
        case 0:
            timeLb.text = model.setTime + "天"
            break
        case 1:
            timeLb.text = model.setTime + "天"
            break
        case 2:
            timeLb.text = model.setTime + "顿"
            break
        case 3:
            timeLb.text = model.setTime + "分钟"
            break
        case 4:
            timeLb.text = model.setTime + "分钟"
            break
        case 5:
            timeLb.text = model.setTime + "分钟"
            break
        case 6:
            timeLb.text = model.setTime + "分钟"
            break
        default:
            break
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
