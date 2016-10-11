//
//  JCRootViewController.h
//
//  Created by JC_R on 16/1/11.
//  Copyright © 2016年 JC_R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCRootViewController : UIViewController 

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (instancetype)initWithLastController:(UIViewController *)viewControll;

@end

