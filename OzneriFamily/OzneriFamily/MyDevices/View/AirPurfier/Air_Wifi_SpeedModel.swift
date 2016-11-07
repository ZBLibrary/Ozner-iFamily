//
//  Air_Wifi_SpeedModel.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/5.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class Air_Wifi_SpeedModel: UIView {

    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var bottonButton: UIButton!
    @IBAction func buttonClick(_ sender: AnyObject) {
        SpeedCallBack(sender.tag)
        self.removeFromSuperview()
    }
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let tabBarHeight=CGFloat(LoginManager.instance.isChinese_Simplified ? 64:0)
        bottomConstraint.constant=((height_screen-tabBarHeight)*0.25844-97)/2+tabBarHeight
    }
    private var SpeedCallBack:((Int)->Void)!
    //[0,4,5]
    func SetSpeed(speed:Int,speedCallBack:@escaping ((Int)->Void)) {
        SpeedCallBack=speedCallBack
        let speedIndex = [0:0,4:1,5:2][speed]
        
        bottonButton.setImage(UIImage(named: ["air01002","airnightOn","airdayOn"][speedIndex!]), for: .normal)
        bottonButton.tag=speed
        leftButton.setImage(UIImage(named: ["air22012","airnightOff","airdayOff"][(speedIndex!+1)%3]), for: .normal)
        leftButton.tag=[0,4,5][(speedIndex!+1)%3]
        rightButton.setImage(UIImage(named: ["air22012","airnightOff","airdayOff"][(speedIndex!+2)%3]), for: .normal)
        rightButton.tag=[0,4,5][(speedIndex!+2)%3]
        
    }

}
