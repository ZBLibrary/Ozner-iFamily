//
//  CenterWaterView.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/11/2.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/2  上午9:12
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class CenterWaterView: OznerDeviceView{

    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var leftWaveView: ASongWaterWaveView!
    
    @IBOutlet weak var rightWaveView: ASongWaterWaveView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        leftWaveView.layer.cornerRadius = leftWaveView.frame.width/2
        leftWaveView.layer.masksToBounds = true
        
        rightWaveView.layer.cornerRadius = leftWaveView.frame.width/2
        rightWaveView.layer.masksToBounds = true
        centerBtn.layer.cornerRadius = 23
        centerBtn.layer.masksToBounds = true
        centerBtn.layer.borderColor = UIColor(red: 22.0 / 255.0, green: 142.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0).cgColor
        centerBtn.layer.borderWidth = 2
        
    }
    
}
