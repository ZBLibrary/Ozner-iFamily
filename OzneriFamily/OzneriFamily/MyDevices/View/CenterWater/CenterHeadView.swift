//
//  CenterHeadView.swift
//  WSWaterWaveDemo
//
//  Created by ZGY on 2017/11/2.
//Copyright © 2017年 SongLan. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/11/2  下午4:42
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class CenterHeadView: UITableViewHeaderFooterView {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var defaultBtn: UIButton!
    

    var block:((Int)->Void)!
    
    var isDefault = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        cornerBtn(setBtn)
        cornerBtn(defaultBtn)
        if isDefault {
            btnBgColor(setBtn, color: UIColor.blue)
        }
        
    }
    @IBAction func setBtnAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1) {
            
            self.rightImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
        }
        
        switch sender.tag {
        case 555:
            
            btnBgColor(defaultBtn, color: UIColor.blue)
            cornerBtn(setBtn)
            
            break
        default:
            
            btnBgColor(setBtn, color: UIColor.blue)
            cornerBtn(defaultBtn)
            
            break
        }
        
        block(sender.tag)
    }
    
    func btnBgColor(_ btn:UIButton,color:UIColor) {
        
        btn.backgroundColor =  color
        
    }
    
    func cornerBtn(_ btn:UIButton) {
        
        btnBgColor(btn, color: UIColor.white)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.blue.cgColor
    }

}
