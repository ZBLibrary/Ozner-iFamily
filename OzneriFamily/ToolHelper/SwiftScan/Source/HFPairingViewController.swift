//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import SVProgressHUD

open class HFPairingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   open var scanObj: LBXScanWrapper?
   open var scanStyle: LBXScanViewStyle? = LBXScanViewStyle()
   open var qRScanView: LBXScanView?
    //启动区域识别功能
   open var isOpenInterestRect = false
    //识别码的类型
    var arrayCodeType:[String]?
    //是否需要识别后的当前图像
    var isNeedCodeImage = false
    var ssid=""
    var password=""
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
              // [self.view addSubview:_qRScanView];
        self.view.backgroundColor = UIColor.black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");
        scanStyle=style

    }
    
    open func setNeedCodeImage(needCodeImg:Bool)
    {
        isNeedCodeImage = needCodeImg;
    }
    //设置框内识别
    open func setOpenInterestRect(isOpen:Bool){
        isOpenInterestRect = isOpen
    }
 
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawScanView()
       
        perform(#selector(startScan), with: nil, afterDelay: 0.3)
        
    }
    
    open func startScan()
    {
        if(!LBXPermissions .isGetCameraPermission())
        {
            showMsg(title: "提示", message: "没有相机权限，请到设置->隐私中开启本程序相机权限")
            return;
        }
        
        if (scanObj == nil)
        {
            var cropRect = CGRect.zero
            if isOpenInterestRect
            {
                cropRect = LBXScanView.getScanRectWithPreView(preView: self.view, style:scanStyle! )
            }
            
            //识别各种码，
            //let arrayCode = LBXScanWrapper.defaultMetaDataObjectTypes()
            
            //指定识别几种码
            if arrayCodeType == nil
            {
                arrayCodeType = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]
            }
            
            scanObj = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
                
                if let strongSelf = self
                {
                    //停止扫描动画
                    strongSelf.qRScanView?.stopScanAnimation()
                    strongSelf.handleCodeResult(arrayResult: arrayResult)
                }
             })
        }
        
        //结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        //开始扫描动画
        qRScanView?.startScanAnimation()
        
        //相机运行
        scanObj?.start()
    }
    
    open func drawScanView()
    {
        if qRScanView == nil
        {
            qRScanView = LBXScanView(frame: self.view.frame,vstyle:scanStyle! )
            self.view.addSubview(qRScanView!)
        }
        qRScanView?.deviceStartReadying(readyStr: "相机启动中...")
        
    }
   
    
    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理
     */
    var deviceInfo = OznerDeviceInfo(deviceID: "", deviceMac: "", deviceType: "", productID: "", wifiVersion: 3)
    private var smtlk:HFSmartLink!
    open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        startScan()
        if deviceInfo.deviceMac != "" && deviceInfo.deviceID != "" && deviceInfo.productID != "" {
            return
        }
        if let result = arrayResult[0].strScanned{
            print("扫描到的二维码内容："+result)
            if result.contains("type")&&result.contains("id")&&result.contains("http://")&&result.contains("=") {
                let resultArr = result.components(separatedBy: "?")
                let keyValue = resultArr[1].components(separatedBy: "&")
                
                for item in keyValue {
                    let itemArr = item.components(separatedBy: "=")
                    
                    switch itemArr[0] {
                    case "id":
                        deviceInfo.deviceMac=itemArr[1]
                        deviceInfo.deviceID=itemArr[1]
                    case "type":
                        deviceInfo.productID=itemArr[1]
                        deviceInfo.deviceType=itemArr[1]
                    default:
                        break
                    }
                }
                if deviceInfo.deviceMac != "" && deviceInfo.deviceID != "" && deviceInfo.productID != "" {
                    LoginManager.instance.showHud()
                    //开启汉枫配网
                    smtlk = HFSmartLink.shareInstence()
                    smtlk.isConfigOneDevice = true;
                    smtlk.waitTimers = 60;
                    smtlk.stop { (sdad, sda) in                        
                    }
                    smtlk.start(withSSID: ssid, key: password, withV3x: true, processblock: { (progress) in
                        print(progress)
                    }, successBlock: { (hfDeviceInfo) in
                        print(hfDeviceInfo ?? "device")
                        let hfMac = (hfDeviceInfo?.mac.lowercased().replacingOccurrences(of: ":", with: ""))! as NSString
                        let codeMac = self.deviceInfo.deviceMac.lowercased().replacingOccurrences(of: ":", with: "") as NSString
                        if hfMac==codeMac
                        {
                            var identifier = codeMac.substring(to: 2)
                            
                            for i in 1...5 {
                                let tmpstr = codeMac.substring(from: i*2) as NSString
                                identifier=identifier+":"+tmpstr.substring(to: 2)
                            }
                            self.deviceInfo.deviceMac=identifier
                            let device=OznerManager.instance.createDevice(scanDeviceInfo: self.deviceInfo, setting: nil)
                            device.settings.name="智能设备"
                            OznerManager.instance.saveDevice(device: device)
                            OznerManager.instance.currentDevice=device
                            //上传到服务器
                            SVProgressHUD.dismiss()
                            User.AddDevice(mac: device.deviceInfo.deviceMac, type: device.deviceInfo.deviceType, setting: device.settings.toJsonString(), success: {
                                print("设备上传到服务器成功！")
                            }, failure: { (error) in
                                print("设备上传到服务器失败！")
                            })
                            self.dismiss(animated: false, completion: {})
                            
                        }else{
                            SVProgressHUD.dismiss()
                            self.showMsg(title: "提示", message: "配对失败，请返回后重试")
                        }
                    }, fail: { (fail) in
                        print(fail ?? "fail")
                        self.showMsg(title: "提示", message: "配对失败，请返回后重试")
                        SVProgressHUD.dismiss()
                    }) { (end) in
                        print(end ?? "end")
                    }
                    
                    
                }
                
            }
        }
        
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
        SVProgressHUD.dismiss()
        smtlk.stop { (sdad, sda) in
            
        }
    }
    
//    open func openPhotoAlbum()
//    {
//        if(!LBXPermissions.isGetPhotoPermission())
//        {
//            showMsg(title: "提示", message: "没有相册权限，请到设置->隐私中开启本程序相册权限")
//        }
//        
//        let picker = UIImagePickerController()
//        
//        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        
//        picker.delegate = self;
//        
//        picker.allowsEditing = true
//        
//        present(picker, animated: true, completion: nil)
//    }
//    
//    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
//    @nonobjc open func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//        picker.dismiss(animated: true, completion: nil)
//        
//        var image:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
//        
//        if (image == nil )
//        {
//            image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        }
//        
//        if(image != nil)
//        {
//            let arrayResult = LBXScanWrapper.recognizeQRImage(image: image!)
//            if arrayResult.count > 0
//            {
//                handleCodeResult(arrayResult: arrayResult)
//                return
//            }
//        }
//      
//        showMsg(title: "", message: "识别失败")
//    }
    
    func showMsg(title:String?,message:String?)
    {
        if LBXScanWrapper.isSysIos8Later()
        {
        
            //if #available(iOS 8.0, *)
            
            let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title:  "知道了", style: UIAlertActionStyle.default) { [weak self] (alertAction) in
                
                if let strongSelf = self
                {
                    strongSelf.startScan()
                }
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    deinit
    {
        print("LBXScanViewController deinit")
    }
    
}





