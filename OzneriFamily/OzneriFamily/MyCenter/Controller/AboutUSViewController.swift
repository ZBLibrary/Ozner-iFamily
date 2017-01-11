//
//  AboutUSViewController.swift
//  My
//
//  Created by test on 15/11/27.
//  Copyright © 2015年 HAOZE. All rights reserved.
//

import UIKit

class AboutUSViewController: BaseViewController {

  
    @IBOutlet var ScoreLable: UILabel!
    
    @IBOutlet weak var currenLb: UILabel!

    @IBOutlet weak var versionLb: UILabel!
    @IBOutlet var HaozeLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        currenLb.text = loadLanguage("当前版本")
     self.title=loadLanguage("关于君融科技" )
        //UpdateLable.text=loadLanguage("检查更新版本" )
        ScoreLable.text=loadLanguage("评个分吧")
        HaozeLable.text=loadLanguage("君融科技")
        versionLb.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    //评个分吧
    @IBAction func GiveScore(sender: AnyObject) {
        let str = "itms-apps://itunes.apple.com/app/id955305764"
        UIApplication.shared.openURL(NSURL(string: str)! as URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
