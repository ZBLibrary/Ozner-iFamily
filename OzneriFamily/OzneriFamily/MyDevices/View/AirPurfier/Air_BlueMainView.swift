//
//  Air_BlueMainView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/16.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class Air_BlueMainView: OznerDeviceView {

    @IBOutlet var sliderTouchView: UIView!
    @IBOutlet var sliderImgWidth: NSLayoutConstraint!
    @IBOutlet var sliderShowValueViewToRight: NSLayoutConstraint!
    @IBOutlet var sliderShowValueView: UIView!
    @IBOutlet var sliderValueLabel: UILabel!
    @IBOutlet var sliderValueStateLabel: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        sliderShowValueView.layer.shadowColor=UIColor(red: 0, green: 104/255, blue: 246/255, alpha: 1).cgColor
        sliderShowValueView.layer.shadowOffset=CGSize(width: 0, height: 0)//阴影偏移量
        //添加拖动手势
        let panGesture=UIPanGestureRecognizer(target: self, action: #selector(panImage))
        sliderTouchView.addGestureRecognizer(panGesture)
        //添加点击手势
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(tapImage))
        tapGesture.numberOfTapsRequired=1//设置点按次数
        sliderTouchView.addGestureRecognizer(tapGesture)
        updateSliderView(touchX: 0)
        // Drawing code
    }
    
    func panImage(_ gesture:UIPanGestureRecognizer)
    {
        let tapPoint:CGPoint = gesture.location(in: sliderTouchView)
         print(tapPoint.x)
        updateSliderView(touchX: tapPoint.x)
        
        
    }
    
    func tapImage(_ gesture:UITapGestureRecognizer)
    {
        if (gesture.state == UIGestureRecognizerState.ended) {
            if (gesture.numberOfTouches <= 0) {
                return
            }
            let tapPoint:CGPoint = gesture.location(ofTouch: 0, in: sliderTouchView)
            print(tapPoint.x)

            updateSliderView(touchX: tapPoint.x)
        }
    }
    //264,333
    //0-333,触碰点范围
    //34.5-298.5 中心点范围
    private func updateSliderView(touchX:CGFloat) {
        var needValue=max(34.5*width_screen/375, touchX)
        needValue=min(298.5*width_screen/375, needValue)
        sliderImgWidth.constant=needValue-34.5*width_screen/375
        sliderShowValueViewToRight.constant=333*width_screen/375-needValue-30
        let tmpValue = (needValue-34.5*width_screen/375)/(264*width_screen/375)
        let tmpValueInt=Int(100*tmpValue)
        sliderValueLabel.text="\(tmpValueInt)"
        switch true {
        case tmpValueInt==0:
            sliderValueStateLabel.text="关机"
        case tmpValueInt>0&&tmpValueInt<=33:
            sliderValueStateLabel.text="低速"
        case tmpValueInt>33&&tmpValueInt<=66:
            sliderValueStateLabel.text="中速"
        default:
            sliderValueStateLabel.text="高速"
        }
                
    }

}
