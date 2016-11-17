//
//  MyDeviceRankViewController.swift
//  OzneriFamily
//
//  Created by zhuguangyang on 16/10/25.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class MyDeviceRankViewController: UIViewController {

    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpUI()
        
    }

    
    func setUpUI() {
        tableView = UITableView(frame: self.view.bounds)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.separatorStyle = .none
        tableView?.register(UINib.init(nibName: "My_Rank_TDSCell", bundle: nil), forCellReuseIdentifier: "My_Rank_TDSCellID")
        
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

extension MyDeviceRankViewController : UITableViewDelegate, UITableViewDataSource ,My_Rank_TDSCellDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "My_Rank_TDSCellID", for: indexPath) as! My_Rank_TDSCell
        cell.selectionStyle = .none
        
        cell.loadUI(index:indexPath)
        cell.delegate = self
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 79
    }
    
    func pushToLikeAction(index: IndexPath) {
        print("点击了\(index.row)")
        self.performSegue(withIdentifier: "pushtoMyLikeID", sender: nil)
    }
    
}


