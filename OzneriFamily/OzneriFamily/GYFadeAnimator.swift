//
//  GYFadeAnimator.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/1/4.
//  Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/1/4  11:19
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit

class GYFadeAnimator: NSObject,UIViewControllerAnimatedTransitioning{

    private let duration = 1.0
    
    ///转场动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        containerView.addSubview(toView!)
        
        //为目标试图添加动画
        toView?.alpha = 0
        let animation = CATransition()
        animation.duration = 1
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromRight
        
        toView?.layer.add(animation, forKey: nil)
        UIView.animate(withDuration: duration, animations: { 
             toView?.alpha = 1.0
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
        
        
    }
    
}
