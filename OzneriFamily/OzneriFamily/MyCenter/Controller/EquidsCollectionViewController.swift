//
//  EquidsCollectionViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/25.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class EquidsCollectionViewController: UIViewController {
    

    var colltionView: UICollectionView?
    var layout: UICollectionViewFlowLayout?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "已有设备"
        
        layout = UICollectionViewFlowLayout()
        colltionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout!)
        
        colltionView?.backgroundColor = UIColor.init(colorLiteralRed: 227/225.0, green: 228/255.0, blue: 226/255.0, alpha: 1.0)
        colltionView?.delegate = self
        colltionView?.dataSource = self
        colltionView?.register(UINib.init(nibName: "EquidsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EquidsCollectionViewCellID")
        
        layout?.itemSize = CGSize(width: (width_screen - 20 ) / 3, height: (width_screen - 40 ) / 3)
        layout?.minimumLineSpacing = 10
        layout?.minimumInteritemSpacing = 10
        self.view.addSubview(colltionView!)
        
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        appDelegate.mainTabBarController?.setTabBarHidden(true, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EquidsCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colltionView?.dequeueReusableCell(withReuseIdentifier: "EquidsCollectionViewCellID", for: indexPath) as! EquidsCollectionViewCell
        
        return cell
        
    }
    
    
    
}
