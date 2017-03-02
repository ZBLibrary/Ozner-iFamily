//
//  NoDeviceView.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/11.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class NoDeviceView: OznerDeviceView {
   
    
    
    @IBOutlet weak var addDevieceLb: UILabel!
    @IBOutlet weak var deviceBtn: UIButton!
    @IBAction func addDeviceClick(_ sender: AnyObject) {
        let addDeviceNav=UIStoryboard(name: "LeftMenu", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuNav") as! UINavigationController
        self.delegate.PresentModelController!(controller: addDeviceNav)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        deviceBtn.setTitle(loadLanguage("添加设备"), for: UIControlState.normal)
//        addDevieceLb.text = loadLanguage("请添加设备\n开启浩泽智能生活")
        addDevieceLb.text = loadLanguage("请添加设备") + "\n" + loadLanguage("开启浩泽伊泉净品智慧生活")
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
