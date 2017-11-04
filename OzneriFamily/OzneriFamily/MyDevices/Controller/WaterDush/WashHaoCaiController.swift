//
//  WashHaoCaiController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2017/9/15.
//  Copyright © 2017年 net.ozner. All rights reserved.
//

import UIKit

class WashHaoCaiController: BaseViewController {

    
    @IBOutlet var PTitleLabel: UILabel!
    @IBOutlet var RTitleLabel: UILabel!
    @IBOutlet var STitleLabel: UILabel!
    @IBOutlet var DTitleLabel: UILabel!
    @IBOutlet var PImg: UIImageView!
    @IBOutlet var RImg: UIImageView!
    @IBOutlet var SImg: UIImageView!
    @IBOutlet var DImg: UIImageView!
    @IBOutlet var animalView1: UIView!
    @IBOutlet var animalView2: UIView!
    @IBOutlet var animalView3: UIView!
    @IBOutlet var animalView4: UIView!
    
    @IBAction func bugHaoCaiClick(_ sender: Any) {
        let vc=UIStoryboard(name: "MyDevices", bundle: nil).instantiateViewController(withIdentifier: "AboutDeviceController") as! AboutDeviceController
        vc.setLoadContent(content: (NetworkManager.defaultManager?.UrlNameWithRoot("BuyWashHaoCai"))!, Type: 0)
        vc.title=""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let filterStatus=(OznerManager.instance.currentDevice as! WashDush_Wifi).filterStatus
        let valueArr = [0:filterStatus.jingshui,
                        1:filterStatus.ruanshui,
                        2:filterStatus.liangjie,
                        3:filterStatus.jingjie]
        let titles = [PTitleLabel,STitleLabel,RTitleLabel,DTitleLabel]
        let Imgs = [PImg,SImg,RImg,DImg]
        for (index,value) in valueArr {
            IsAnimals[index]=false
            var titleStr = ""
            var imgStr = "wash_"+["P","S","R","D"][index]
            switch true {
            case value>=100:
                titleStr="充足"
                imgStr+="5"
            case value>66&&value<100:
                titleStr="充足"
                imgStr+="4"
            case value>33&&value<=66:
                titleStr="中量"
                imgStr+="3"
            case value>0&&value<=33:
                titleStr="少量"
                imgStr+="2"
            default:
                titleStr="缺乏"
                imgStr+="1"
                IsAnimals[index]=true
            }
            titles[index]?.text=titleStr
            Imgs[index]?.image=UIImage.init(named: imgStr)
        }
        // Do any additional setup after loading the view.
    }
    var timer1:Timer?
    var timer2:Timer?
    var timer3:Timer?
    var timer4:Timer?
    var IsAnimals = [false,false,false,false]
    func ViewAnimal(_ timer:Timer?)  {
        switch (timer?.userInfo as! Int) {
        case 0:
             animalView1.isHidden = !animalView1.isHidden
        case 1:
            animalView2.isHidden = !animalView2.isHidden
        case 2:
            animalView3.isHidden = !animalView3.isHidden
        case 3:
            animalView4.isHidden = !animalView4.isHidden
        default:
            break
        }
    }
    func starAnimal()  {
        if IsAnimals[0] {//开启循环数据模式
            timer1?.invalidate()
            timer1 = nil
            timer1 = Timer(timeInterval: 0.8, target: self, selector: #selector(ViewAnimal(_:)), userInfo: 0, repeats: true)
            RunLoop.main.add(timer1!, forMode: RunLoopMode.commonModes)
        }
        if IsAnimals[1] {//开启循环数据模式
            timer2?.invalidate()
            timer2 = nil
            timer2 = Timer(timeInterval: 0.8, target: self, selector: #selector(ViewAnimal(_:)), userInfo: 1, repeats: true)
            RunLoop.main.add(timer2!, forMode: RunLoopMode.commonModes)
        }
        if IsAnimals[2] {//开启循环数据模式
            timer3?.invalidate()
            timer3 = nil
            timer3 = Timer(timeInterval: 0.8, target: self, selector: #selector(ViewAnimal(_:)), userInfo: 2, repeats: true)
            RunLoop.main.add(timer3!, forMode: RunLoopMode.commonModes)
        }
        if IsAnimals[3] {//开启循环数据模式
            timer4?.invalidate()
            timer4 = nil
            timer4 = Timer(timeInterval: 0.8, target: self, selector: #selector(ViewAnimal(_:)), userInfo: 3, repeats: true)
            RunLoop.main.add(timer4!, forMode: RunLoopMode.commonModes)
        }
    }
    func stopAnimal()  {
        timer1?.invalidate()
        timer1 = nil
        timer2?.invalidate()
        timer2 = nil
        timer3?.invalidate()
        timer3 = nil
        timer4?.invalidate()
        timer4 = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        starAnimal()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopAnimal()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="washBugLink" {
            let vc=segue.destination as! AboutDeviceController
            vc.setLoadContent(content: (NetworkManager.defaultManager?.URL?["jxszd"]?.stringValue)!, Type: 0)
            vc.title="补充耗材"
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
