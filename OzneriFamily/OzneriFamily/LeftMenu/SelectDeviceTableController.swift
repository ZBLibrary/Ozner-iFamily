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
    
    var panGesture: UIGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = loadLanguage("选择设备")
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SelectDeviceTableController.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGesture!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight=120*height_screen/667
    }

    func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        if panGesture.state == UIGestureRecognizerState.began {
            
            let point_inView = panGesture.translation(in: self.view)
            print(point_inView.x)
            
//            self.dismiss(animated: false, completion: nil)
            
        } else if panGesture.state == .changed {
            let point_inView = panGesture.translation(in: self.view)
            
            if point_inView.x > 10 {
               self.dismiss(animated: false, completion: nil)
            }
         
            
        }
        
        /*
        let presentVc = panGesture.view
        var rootView:UIViewController?

        if panGesture.state == UIGestureRecognizerState.began {
            appDelegate.window?.rootViewController = LoginManager.instance.mainTabBarController
            rootView = (appDelegate.window?.rootViewController)!
            var frame = rootView?.view.frame
            frame = CGRect(x: -appDelegate.window!.frame.width, y: 0, width: (appDelegate.window?.frame.width)!, height: (appDelegate.window?.frame.height)!)
            rootView?.view.frame = frame!
            appDelegate.window?.insertSubview((rootView?.view!)!, at: 0)
            
        } else if panGesture.state == .changed {
            let point_inView = panGesture.translation(in: self.view)
            
            if point_inView.x >= 10 {
                presentVc?.transform = CGAffineTransform.init(translationX: point_inView.x - 10, y: 0)
                rootView?.view.transform = CGAffineTransform.init(translationX: point_inView.x, y: 0)
            }
            
        } else if panGesture.state == .ended {
            
            let point_inView = panGesture.translation(in: self.view)
            
            if (point_inView.x > 100) {
                
                UIView.animate(withDuration: 0.3, animations: { 
                    
                    presentVc?.transform = CGAffineTransform.init(translationX: self.view.width, y: 0)
                    
                }, completion: { (finished) in
                    rootView?.view.frame = CGRect(x: 0, y: 0, width: (appDelegate.window?.frame.width)!, height: (appDelegate.window?.frame.height)!)
//                    appDelegate.window?.willRemoveSubview((rootView?.view)!)
                    self.dismiss(animated: false, completion: nil)
                    presentVc?.transform = CGAffineTransform.identity
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                      presentVc?.transform = CGAffineTransform.identity
                }, completion: { (finished) in
                    
                })
            }
            
            
        }
        
        */
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectdevice", for: indexPath) as! SelectDeviceCell
        
        cell.setDeviceType(deviceType: [OznerDeviceType.Tap,.Water_Wifi,.Air_Wifi,.WaterReplenish][indexPath.row])//deviceType=
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //deviceType = [OznerDeviceType.Cup,.Tap,.TDSPan,.Water_Wifi,.Air_Blue,.Air_Wifi,.WaterReplenish][indexPath.row]
        self.performSegue(withIdentifier: "pushPairID", sender: indexPath.row)

    }
    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {      
        let pair = segue.destination as! PairingController
        pair.currDeviceType = [OznerDeviceType.Tap,.Water_Wifi,.Air_Wifi,.WaterReplenish][sender as! Int]

    }
    

}
