//
//  FilterInfoScanVc.swift
//  OzneriFamily
//
//  Created by ZGY on 2017/12/21.
//Copyright © 2017年 net.ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/12/21  下午3:40
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import UIKit
import Foundation
import AVFoundation
import SVProgressHUD

class FilterInfoScanVc: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open var scanObj: LBXScanWrapper?
    
    open var scanStyle: LBXScanViewStyle? = LBXScanViewStyle()
    
    open var qRScanView: LBXScanView?
    
    var block:((String)->Void)?
    
    //启动区域识别功能
    open var isOpenInterestRect = false
    
    //识别码的类型
    var arrayCodeType:[String]?
    
    //是否需要识别后的当前图像
    var isNeedCodeImage = false
    
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
        LoginManager.instance.mainTabBarController?.setTabBarHidden(true, animated: true)
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
    open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        startScan()

        if let result = arrayResult[0].strScanned{

            if result.contains("/web/view/FilterValidate.aspx?id=") {
                let resultArr = result.components(separatedBy: "?id=")
                
                if block != nil {
                    block!(resultArr[1])
                }
                
            } else {
                appDelegate.window?.noticeOnlyText("非浩泽定制二维码,请重试！")
             }
          
            self.navigationController?.popViewController(animated: true)
            //            if result.contains("mac")&&result.contains("deviceid")&&result.contains("productid")&&result.contains("&") {
//                let resultArr = result.components(separatedBy: "&")
//
//                for item in resultArr {
//                    let itemArr = item.components(separatedBy: "=")
//
//                    switch itemArr[0] {
//                    case "mac":
//                        deviceInfo.deviceMac=itemArr[1]
//                    case "deviceid":
//                        deviceInfo.deviceID=itemArr[1]
//                    case "productid":
//                        deviceInfo.productID=itemArr[1]
//                        deviceInfo.deviceType=itemArr[1]
//                    default:
//                        break
//                    }
//                }
//                if deviceInfo.deviceMac != "" && deviceInfo.deviceID != "" && deviceInfo.productID != "" {
//                    let device=OznerManager.instance.createDevice(scanDeviceInfo: deviceInfo, setting: nil)
//                    device.settings.name="智能设备"
//                    OznerManager.instance.saveDevice(device: device)
//                    OznerManager.instance.currentDevice=device
//                    //上传到服务器
//                    LoginManager.instance.showHud()
//                    User.AddDevice(mac: device.deviceInfo.deviceMac, type: device.deviceInfo.deviceType, setting: device.settings.toJsonString(),weight: device.deviceInfo.wifiVersion, success: {
//                        print("设备上传到服务器成功！")
//                        SVProgressHUD.dismiss()
//                    }, failure: { (error) in
//                        SVProgressHUD.dismiss()
//                        print("设备上传到服务器失败！")
//                    })
//                    self.dismiss(animated: false, completion: {})
//
//                }
//
//            }
        }
        
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
    }
    
    open func openPhotoAlbum()
    {
        if(!LBXPermissions.isGetPhotoPermission())
        {
            showMsg(title: "提示", message: "没有相册权限，请到设置->隐私中开启本程序相册权限")
        }
        
        let picker = UIImagePickerController()
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        picker.delegate = self;
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    @nonobjc open func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismiss(animated: true, completion: nil)
        
        var image:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if (image == nil )
        {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        if(image != nil)
        {
            let arrayResult = LBXScanWrapper.recognizeQRImage(image: image!)
            if arrayResult.count > 0
            {
                handleCodeResult(arrayResult: arrayResult)
                return
            }
        }
        
        showMsg(title: "", message: "识别失败")
    }
    
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






