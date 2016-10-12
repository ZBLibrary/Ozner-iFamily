//
//  PairSuccessController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/10.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit
import Spring

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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        print(sanjiao_image.bounds)
        sanjiao_XLayout.constant += collectionFlowout.itemSize.width / 2 - 11.5
        
        var successBounds = successImage.bounds
        successBounds.origin.y -= 80
        UIView.animate(withDuration: 1) {
//            self.successImage.bounds = successBounds
//            self.view.layoutIfNeeded()
            self.successImage.transform = CGAffineTransform(translationX: 0, y: -100)
            self.sanjiao_image.transform = CGAffineTransform(translationX: 0, y: -150)
            self.scrollerView.transform = CGAffineTransform(translationX: 0, y: -150)
            self.searchLb.transform = CGAffineTransform(translationX: 0, y: -150)
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
