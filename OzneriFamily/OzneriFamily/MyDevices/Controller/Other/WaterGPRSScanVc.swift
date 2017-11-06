//
//  WaterGPRSScanVc.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/10/20.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/10/20  上午11:20
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import SVProgressHUD
class WaterGPRSScanVc: PairingScanViewController {
    
    //MARK: - Attributes
    var scanTypeIndex:Int!
    var scanString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Override
    
    var deviceInfo2 = OznerDeviceInfo(deviceID: "", deviceMac: "", deviceType: "", productID: "", wifiVersion: 3)
    override func handleCodeResult(arrayResult:[LBXScanResult])
    {
        startScan()
        if deviceInfo2.deviceMac != "" && deviceInfo2.deviceID != "" && deviceInfo2.productID != "" {
            return
        }
        if let result = arrayResult[0].strScanned{
            print("扫描到的二维码内容："+result)
            if result.contains("&deviceId=")&&result.contains("deviceType=") {

                let arr = result.components(separatedBy: "deviceType=")
                let arr2 = arr[1].components(separatedBy: "&deviceId=")
                
                deviceInfo2.deviceType = arr2[0]
                deviceInfo2.deviceMac = arr2[1]
                deviceInfo2.deviceID = arr2[1]
                deviceInfo2.productID = arr2[0]
//                for item in resultArr {
//                    let itemArr = item.components(separatedBy: "=")
//
//                    switch itemArr[0] {
//                    case "mac":
//                        deviceInfo2.deviceMac=itemArr[1]
//                    case "deviceid":
//                        deviceInfo2.deviceID=itemArr[1]
//                    case "productid":
//                        deviceInfo2.productID=itemArr[1]
//                        deviceInfo2.deviceType=itemArr[1]
//                    default:
//                        break
//                    }
            } else {
              
                appDelegate.window?.noticeOnlyText("请检查二维码是否正确")
                self.navigationController?.popViewController(animated: true)
                return
            }
                if deviceInfo2.deviceMac != "" && deviceInfo2.deviceID != "" && deviceInfo2.productID != "" {
           
                    if deviceInfo2.productID != scanString {
                        appDelegate.window?.noticeOnlyText("请确认当期配对类型")
                        self.navigationController?.popViewController(animated: true)
                        return
                    }

                    let storeB = UIStoryboard.init(name: "LeftMenu", bundle: nil)
                    let pair = storeB.instantiateViewController(withIdentifier: "PairSuccessController") as! PairSuccessController
                    pair.productInfo=ProductInfo.products["\(scanTypeIndex!)"]!
                    
                    pair.deviceArr = [deviceInfo2]
                                    
                    self.navigationController?.pushViewController(pair, animated: true)
                }
                
            }
        }
        
        
    
    //MARK: - Initial Methods
    
    
    //MARK: - Delegate
    
    
    //MARK: - Target Methods
    
    
    //MARK: - Notification Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    
    //MARK: - Privater Methods
    
    
    //MARK: - Setter Getter Methods
    
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        
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
