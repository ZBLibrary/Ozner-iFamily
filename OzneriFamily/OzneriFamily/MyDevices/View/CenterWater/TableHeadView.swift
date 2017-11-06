//
//  TableHeadView.swift
//  WSWaterWaveDemo
//
//  Created by ZGY on 2017/11/2.
//Copyright © 2017年 SongLan. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/2  下午3:15
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class TableHeadView: UITableViewHeaderFooterView {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }

}
