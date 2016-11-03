//
//  PairSuccessController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
//import Spring
import SnapKit

class PairModle: NSObject {
    var isHidden: Bool=true
}


class PairSuccessController: UIViewController {

    //传入设备数组即可
    var deviceArr = [OznerDevice](){
        didSet{
            for _ in 0..<deviceArr.count {
                pairModel.append(PairModle())
            }
            pairModel[0].isHidden=false

        }
    }
    var  CurrDeviceType:String!
    var settings:[String:String] = ["name":"","usingSite":"办公室","sex":"","weight":"","IsTDSPan":"false"]
    
    
    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowout: UICollectionViewFlowLayout!
    

    
    @IBOutlet weak var sucessImageLayout: NSLayoutConstraint!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var searchLb: UILabel!
    
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var scrollerView: UIView!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    //记录选择了第几个设备，默认第一个
    var indexDevice: Int = 0
    
    
    
    private var mainMatchView: UIView!
    
    var pairModel=[PairModle]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageandLb()
        setUpUI()
    }
    
    private func loadImageandLb() {
        
        switch CurrDeviceType {
        case OznerDeviceType.Cup.rawValue:
            mainMatchView = UINib.init(nibName: "CupMatchView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CupMatchView
            (mainMatchView as! CupMatchView).cupNameLb.delegate=self
            (mainMatchView as! CupMatchView).weightLb.delegate=self
            (mainMatchView as! CupMatchView).sucessBtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            successImage.image=UIImage(named: "icon_peidui_select_cup")
          
        case OznerDeviceType.Tap.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "输入水探头名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! SmallAriClearView).nameLb.delegate=self
            successImage.image=UIImage(named: "icon_peidui_select_tan_tou")
 
        case OznerDeviceType.TDSPan.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "输入检测笔名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! SmallAriClearView).nameLb.delegate=self
            successImage.image=UIImage(named: "icon_peidui_select_TDSPan")
   
        case OznerDeviceType.Water_Wifi.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "净水器名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! SmallAriClearView).nameLb.delegate=self
            successImage.image=UIImage(named: "icon_peidui_select_jingshuiqi")
      
        case OznerDeviceType.Air_Blue.rawValue:
            //小空净
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! SmallAriClearView).nameLb.delegate=self
            successImage.image=UIImage(named: "icon_peidui_select_smallAir")
            
        case OznerDeviceType.Air_Wifi.rawValue:
            mainMatchView = UINib.init(nibName: "SmallAriClearView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SmallAriClearView
            (mainMatchView as! SmallAriClearView).placeLb.text = "办公室"
            (mainMatchView as! SmallAriClearView).nameLb.placeholder = "立式空净名称"
            (mainMatchView as! SmallAriClearView).successbtn.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! SmallAriClearView).nameLb.delegate=self
            successImage.image=UIImage(named: "icon_peidui_select_bigAir")
            
        case OznerDeviceType.WaterReplenish.rawValue:
            mainMatchView = UINib.init(nibName: "WaterRefeishView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! WaterRefeishView
            (mainMatchView as! WaterRefeishView).sucessAction.addTarget(self, action: #selector(PairSuccessController.sucessAction), for: UIControlEvents.touchUpInside)
            (mainMatchView as! WaterRefeishView).placeName.delegate=self
            successImage.image=UIImage(named: "WaterReplenish4")
            
        default:
            break
        }
        view.addSubview(mainMatchView)
        mainMatchView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollerView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            if cureentIphoneType == EnumIphoneType.Ipone5
            {
                make.bottom.equalTo(view.snp.bottom).offset(150)
            } else if cureentIphoneType == EnumIphoneType.Iphone6 {
                make.bottom.equalTo(view.snp.bottom).offset(80)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(1)
            }
        }
    }


    func sucessAction() {
        if CheckInputText()==false {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false,
                dynamicAnimatorActive: true
            )
            let alert=SCLAlertView(appearance: appearance)
            _=alert.addButton(loadLanguage("是")) { }
            _=alert.showInfo("", subTitle: loadLanguage("信息不能为空"))
            return
        }
   
        for (key,value) in settings {
            deviceArr[0].settings.put(key, value: value)
        }
        deviceArr[0].settings.name=settings["name"]
        
        OznerManager.instance().save(deviceArr[0])
    
        LoginManager.instance.currentDeviceIdentifier=deviceArr[0].identifier
        self.dismiss(animated: false, completion: {})
    }
    func CheckInputText()->Bool
    {
        var isSuccess = true
        
        switch CurrDeviceType {
        case OznerDeviceType.Cup.rawValue:
            settings["name"]=(mainMatchView as! CupMatchView).cupNameLb.text!
            settings["weight"]=(mainMatchView as! CupMatchView).weightLb.text!
            isSuccess = settings["weight"]=="" ? false:isSuccess
        case OznerDeviceType.TDSPan.rawValue:
            settings["IsTDSPan"]="true"
            settings["name"]=(mainMatchView as! SmallAriClearView).nameLb.text!
        case OznerDeviceType.WaterReplenish.rawValue:
            
            settings["name"]=(mainMatchView as! WaterRefeishView).placeName.text!
            settings["sex"]=(mainMatchView as! WaterRefeishView).segementSex.selectedSegmentIndex==0 ? "女":"男"
            
        default:
            settings["name"]=(mainMatchView as! SmallAriClearView).nameLb.text!
            
        }
        isSuccess = settings["name"]=="" ? false:isSuccess
        return isSuccess
    }
    private func setUpUI() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let animal = CABasicAnimation(keyPath: "transform.scale")
        animal.fromValue = NSNumber(value: 1.0)
        animal.toValue = NSNumber(value: 0.5)
        animal.duration = 2.0

        self.successImage.layer.add(animal, forKey: "transform.scale")
        UIView.animate(withDuration: 1.0, animations: {
            
            if cureentIphoneType == EnumIphoneType.Ipone5
            {
            //5
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: -50)
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -50)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -150)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -150)
            self.mainMatchView.transform = CGAffineTransform(translationX: 0, y: -150)
            } else {
            // 6
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: -80)
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -80)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -100)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -100)
            self.mainMatchView.transform = CGAffineTransform(translationX: 0, y: -100)

            }
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.successImage.image = UIImage(named: "match_device_successed")
                
            })
            
        }
    }
    
    @IBAction func leftBtnAction(_ sender: AnyObject) {
        
        if indexDevice <= 0 {
            return
        }
        pairModel[indexDevice].isHidden = true
        indexDevice -= 1
        collectionView.scrollToItem(at: IndexPath(row: indexDevice, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        pairModel[indexDevice].isHidden = false
        print(indexDevice)
        collectionView.reloadData()
    }
    
    //已适配
    @IBAction func rightBtnAction(_ sender: AnyObject) {
        if indexDevice >= pairModel.count - 1 {
            return
        }
        
        collectionView.scrollToItem(at: IndexPath(row: indexDevice, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        pairModel[indexDevice].isHidden = true
        indexDevice += 1
        pairModel[indexDevice].isHidden = false
        print(indexDevice)
        collectionView.reloadData()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension PairSuccessController: UICollectionViewDelegate,UICollectionViewDataSource ,UIScrollViewDelegate{
    
    // MARK: UICollectionViewDelegate
    //定义每个UICollectionViewCell 的大小
    //override func collection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let tmpInt = pairModel.count > 3 ? 3:pairModel.count
        return CGSize(width: collectionView.bounds.size.width/CGFloat(tmpInt), height: collectionView.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pairsuccessCellID", for: indexPath) as! SuccessPairCell

        let iconImgName = [OznerDeviceType.Cup.rawValue:"icon_peidui_select_cup",
                           OznerDeviceType.Tap.rawValue:"icon_peidui_select_tan_tou",
                           OznerDeviceType.TDSPan.rawValue:"icon_peidui_select_TDSPan",
                           OznerDeviceType.Water_Wifi.rawValue:"icon_peidui_select_jingshuiqi",
                           OznerDeviceType.Air_Blue.rawValue:"icon_peidui_select_smallair",
                           OznerDeviceType.Air_Wifi.rawValue:"icon_peidui_select_bigair",
                           OznerDeviceType.WaterReplenish.rawValue:"WaterReplenish4"][CurrDeviceType]
        cell.iconImage.image=UIImage(named: iconImgName!)
        cell.nameLabel.text=OznerDeviceType(rawValue: CurrDeviceType)?.Name()
        
        //默认锁定第一个
        cell.finishImage.isHidden = pairModel[indexPath.row].isHidden
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexDevice == indexPath.row {
            return
        }
        
        pairModel[indexDevice].isHidden = true
        
        pairModel[indexPath.row].isHidden = false
        
        indexDevice = indexPath.row
        self.collectionView.reloadData()
        
    }

    
    
}
//UITextFieldDelegate
extension PairSuccessController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
