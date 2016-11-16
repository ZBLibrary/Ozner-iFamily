//
//  CupColorBoardView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/14.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class CupColorBoardView: UIView {

    var _colorCenterView:UIView!
    var colorWheel2:YJHColorPickerHSWheel2!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        _colorCenterView=UIView(frame: CGRect(x: 80, y: 80, width: 64, height: 64))
        _colorCenterView.backgroundColor=UIColor.white
        _colorCenterView.layer.masksToBounds=true;
        _colorCenterView.layer.cornerRadius=32;
        let wheel2 = YJHColorPickerHSWheel2(frame: CGRect(x: width_screen/2-112, y: rect.height/2-112, width: 224, height: 224))
        
        self.colorWheel2 = wheel2
        let cup = LoginManager.instance.currentDevice as! Cup
        wheel2.confirmBlock = {(color) in
            self._colorCenterView.backgroundColor = color
            let components = (color?.cgColor)?.components
            var tmpColor = (components?[0])!*255*256*256
            tmpColor+=(components?[1])!*255*256+(components?[2])!*255
            cup.settings.haloColor=uint(tmpColor)
            OznerManager.instance().save(cup)
            
        }
        wheel2.addSubview(_colorCenterView)
        self.addSubview(wheel2)
        
        //色环颜色初始化
        let tmpCgcolor=cup.settings.haloColor
        self._colorCenterView.backgroundColor = UIColorFromRGB(UInt(tmpCgcolor))
    }
    

}
