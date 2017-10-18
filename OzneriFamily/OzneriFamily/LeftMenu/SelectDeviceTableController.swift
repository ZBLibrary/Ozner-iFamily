//
//  SelectDeviceTableController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit


class SelectDeviceTableController: UITableViewController ,UIGestureRecognizerDelegate{

    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
       self.dismiss(animated: false, completion: nil)
    }
    
//    var panGesture: UIGestureRecognizer?
    var leftPanGesture: UISwipeGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = loadLanguage("选择设备")
       
        leftPanGesture = UISwipeGestureRecognizer(target: self, action: #selector(SelectDeviceTableController.leftHandPanGesture(_:)))
        self.view.addGestureRecognizer(leftPanGesture!)
         self.tableView.rowHeight=120*height_screen/667
    }
    
    func leftHandPanGesture(_ panGesture: UISwipeGestureRecognizer) {
        
        
        if panGesture.direction == .left{
            
                self.dismiss(animated: false, completion: nil)
            
        }
        
    }

    func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        
        if panGesture.state == UIGestureRecognizerState.began {
            
            let point_inView = panGesture.translation(in: self.view)
        } else if panGesture.state == .changed {
            let point_inView = panGesture.translation(in: self.view)
            
            if point_inView.x > 10 {
                self.dismiss(animated: false, completion: nil)
            }
            
            
        }
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.navigationController!.navigationBar .setBackgroundImage(UIImage(named: "bg_clear_addDevice"), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage(named: "bg_clear_addDevice")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ProductInfo.products.count
//        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectdevice", for: indexPath) as! SelectDeviceCell
        cell.setProductInfo(productInfo: ProductInfo.products["\(indexPath.row)"]!)
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let className=ProductInfo.products["\(indexPath.row)"]!["ClassName"].stringValue
        switch className {
        case OZDeviceClass.NewTrendAir_Wifi.rawValue://扫码配网,OZDeviceClass.WashDush_Wifi.rawValue
            let vc = PairingScanViewController()
            self.navigationController?.pushViewController(vc, animated: true)
//        case OZDeviceClass.AirPurifier_Wifi.rawValue://汉枫测试
//            let vc = HFPairingViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            self.performSegue(withIdentifier: "pushPairID", sender: indexPath.row)
        }
        

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {      
        let pair = segue.destination as! PairingController
        pair.productInfo = ProductInfo.products["\(sender as! Int)"]!

    }
    

}
