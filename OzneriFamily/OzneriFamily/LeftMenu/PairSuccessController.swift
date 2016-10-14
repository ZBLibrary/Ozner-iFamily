//
//  PairSuccessController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import Spring
import SnapKit
class PairSuccessController: UIViewController {

    @IBAction func backClick(_ sender: AnyObject) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var sanjiao_XLayout: NSLayoutConstraint!
    @IBOutlet weak var sanjiao_image: UIImageView!
    
    @IBOutlet weak var viewScrollerLayout: NSLayoutConstraint!
    @IBOutlet weak var sucessImageLayout: NSLayoutConstraint!
    
    @IBOutlet weak var searchLb: UILabel!
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var scrollerView: UIView!

    var mainMatchView: DeviceMatchMainView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainMatchView = UINib.init(nibName: "DeviceMatchMainView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DeviceMatchMainView
        
        let cupView = UINib.init(nibName: "CupMatchView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CupMatchView
        cupView.frame = CGRect(x: 0, y: 18, width: width_screen, height: 200)
        mainMatchView.addSubview(cupView)
        view.addSubview(mainMatchView)
        
        mainMatchView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollerView.snp.bottom).offset(2)
//            make.left.equalTo(view.snp.left).offset(0)
            //不明白
//            make.right.equalTo(view.snp.right).offset(40)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(50)
        }
        
        setUpUI()
        
    }

    private func setUpUI() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        sanjiao_XLayout.constant += collectionFlowout.itemSize.width / 2 - 11.5
        
        let animal = CABasicAnimation(keyPath: "transform.scale")
        animal.fromValue = NSNumber(value: 1.0)
        animal.toValue = NSNumber(value: 0.5)
        animal.duration = 3.0
        self.successImage.layer.add(animal, forKey: "transform.scale")
        UIView.animate(withDuration: 2, animations: {
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -80)
            self.sanjiao_image.transform = CGAffineTransform(translationX: 0, y: -100)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -100)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -100)
            self.mainMatchView.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { (_) in
            
            UIView.animate(withDuration: 1, animations: {
                self.successImage.image = UIImage(named: "match_device_successed")
                
            })
            
        }
    }
    
    @IBAction func leftBtnAction(_ sender: AnyObject) {
        
        if sanjiao_XLayout.constant <= collectionFlowout.itemSize.width {
            
            if collectionView.contentOffset.x <= self.collectionFlowout.itemSize.width {
                return
            }
            
            UIView.animate(withDuration: 0.5) {
                self.collectionView.contentOffset.x -= self.collectionFlowout.itemSize.width + self.collectionFlowout.minimumInteritemSpacing
            }

        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.sanjiao_XLayout.constant -= self.collectionFlowout.itemSize.width + self.collectionFlowout.minimumInteritemSpacing
                
            })
        }
    }
    
    //已适配
    @IBAction func rightBtnAction(_ sender: AnyObject) {

        if sanjiao_XLayout.constant >= collectionView.frame.size.width / 2 {
            if (collectionView.contentOffset.x + collectionFlowout.itemSize.width + collectionFlowout.minimumInteritemSpacing) >= collectionView.contentSize.width - collectionView.frame.size.width
            {
                return
            }
            
            UIView.animate(withDuration: 0.5) {
                
                self.collectionView.contentOffset.x += self.collectionFlowout.itemSize.width + self.collectionFlowout.minimumInteritemSpacing
                
            }
            return
        } else {
            UIView.animate(withDuration: 0.5, animations: { 
                self.sanjiao_XLayout.constant += self.collectionFlowout.itemSize.width + self.collectionFlowout.minimumInteritemSpacing

            })
        }

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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pairsuccessCellID", for: indexPath) as! SuccessPairCell

        return cell
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x)")
        
        print("选择了第几个item:\((scrollView.contentOffset.x + collectionView.frame.size.width)/collectionFlowout.itemSize.width)")
        
        
    }
    
    
}
