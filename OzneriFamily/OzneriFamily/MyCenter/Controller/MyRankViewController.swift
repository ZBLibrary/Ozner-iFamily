//
//  MyRankViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

@objc protocol MyRankViewControllerDelegate{
    
    @objc func pushToStoryBoardMyRank(index: IndexPath)
    
    @objc func pushToStoryBoardMyLike(index: IndexPath)
    
}

class MyRankViewController: UIViewController {
    
    var tableView: UITableView?

    var delegate: MyRankViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
//        getDatas()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width_screen, height: 25))
        label.text = loadLanguage("暂无排名")
        label.textAlignment = .center
//        label.center = (tableView?.center)!
        tableView?.backgroundView = label
        
      
    }
    
    func getDatas() {
        
        User.VolumeFriendRank([:], { (data) in
            
            print(data)
            }) { (error) in
                print(error)
        }
        
    }

    
    func setUpUI() {
        tableView = UITableView(frame: self.view.bounds)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.separatorStyle = .none
        tableView?.register(UINib.init(nibName: "MyRankTableViewCell", bundle: nil), forCellReuseIdentifier: "MyRankTableViewCellID")
        
        view.addSubview(tableView!)
        
        
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

    
extension MyRankViewController : UITableViewDelegate, UITableViewDataSource ,MyRankTableViewCellDelegate{
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRankTableViewCellID", for: indexPath) as! MyRankTableViewCell
            cell.selectionStyle = .none
            
            cell.loadUI(index: indexPath)
            cell.delegate = self
            
            return cell
            
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 200
        }

    
        func pushToFriendLike(index: IndexPath) {
        
            print("点击了\(index.row)点赞按钮")
            self.delegate.pushToStoryBoardMyRank(index:index)
        
        }
    
        func pushToFriendRank(index: IndexPath) {
            print("点击了\(index.row)排行榜按钮")
            self.delegate.pushToStoryBoardMyLike(index: index)
        }

}
