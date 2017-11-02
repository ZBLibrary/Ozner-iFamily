//
//  GloabConfig.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/9/23.
//  Copyright © 2016年 net.ozner. All rights reserved.
//


import UIKit
import SVProgressHUD
//默认尺寸
let height_tabBar:CGFloat = 64
let height_navBar:CGFloat = 64
let height_statusBar:CGFloat = 20
let height_screen:CGFloat = UIScreen.main.bounds.size.height
let width_screen:CGFloat = UIScreen.main.bounds.size.width
let k_height:CGFloat=( LoginManager.instance.currentLoginType == OznerLoginType.ByPhoneNumber ? 1:(667/603))*height_screen/667

enum OznerLoginType:String{
    case ByPhoneNumber="ByPhoneNumber"
    case ByEmail="ByEmail"
}
// app类型
enum OznerAppType:String
{
    
    case OzneriFamily="浩泽净水家"
    case YiQuan="伊泉净品"
}

//手机型号 忽略4
enum EnumIphoneType {
    case Iphone4
    case Ipone5
    case Iphone6
    case Iphone6p
    case IphoneX
}
//登陆控制类
class LoginManager:NSObject{
    
    //单例模式
    private static var _instance: LoginManager! = nil
    
    static var instance: LoginManager! {
        get {
            
            if _instance == nil {
                _instance = LoginManager()
            }
            return _instance
        }
        set {
            _instance = newValue
        }
    }
    lazy var loginViewController_Phone: UIViewController = {
        
        let tmpPhoneVC = UIStoryboard(name: "Login+Register+Guiding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //判断手机登陆需不需要引导页
        let phoneVC=LoginManager.isFristOpenApp ? JCRootViewController(last: tmpPhoneVC):tmpPhoneVC
        return  phoneVC
    }()
    lazy var loginViewController_Email: RNEmailLoginViewController = {
        
        return RNEmailLoginViewController(nibName: "RNEmailLoginViewController", bundle: nil)
    }()
    
    var loginViewController: UIViewController {
        set{
        }
        get{
            var isPhoneLogin=LoginManager.instance.isChinese_Simplified
            if LoginManager.instance.currentLoginType != nil
            {
                isPhoneLogin=LoginManager.instance.currentLoginType==OznerLoginType.ByPhoneNumber
            }
            return isPhoneLogin ? loginViewController_Phone:loginViewController_Email
        }
        
        
    }
    //主视图控制器
    var mainTabBarController: MainTabBarController?
    //退出登录
    func LoginOut()
    {
        LoginManager.instance.currentLoginType=nil
        appDelegate.window?.rootViewController=loginViewController
        if mainTabBarController != nil{
            
            mainTabBarController?.dismiss(animated: true, completion: nil)
            mainTabBarController = nil
        }
        //清理用户文件
        NetworkManager.clearCookies()
        CoreDataManager.defaultManager = nil
        
    }
    //判断是不是第一次登陆
    class var isFristOpenApp:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "IsFristOpenApp")
        }
        get{
            let tmpValue=UserDefaults.standard.object(forKey: "IsFristOpenApp")
            UserDefaults.standard.set(false, forKey: "IsFristOpenApp")
            return  tmpValue == nil ? true:false
        }
    }
    //当前登陆方式，手机登陆，还是邮箱登陆, nil 未登陆过
    var currentLoginType:OznerLoginType?{
        set{
            UserDefaults.standard.set(newValue==nil ? nil:newValue?.rawValue, forKey: "currentLoginType")
        }
        get{
            let s = UserDefaults.standard.object(forKey: "currentLoginType")
            return  s==nil ? nil:OznerLoginType(rawValue: s as! String)
        }
    }
    //是不是中文简体
    lazy var isChinese_Simplified:Bool = {
            return  NSLocalizedString("isChinese_Simplified", comment: "false")=="true"
    }()
    
    
    class func isIphoneX() -> Bool{

        return height_screen == 812
    }
    
    class func currenIphoneType() -> EnumIphoneType{
        switch width_screen {
        case 320:
            return EnumIphoneType.Ipone5
        case 375:
            return EnumIphoneType.Iphone6
        case 414:
            return EnumIphoneType.Iphone6p
        default:
            return EnumIphoneType.Iphone4
        }
    }
    
//    var currentDevice:OznerBaseDevice{
//        return OznerManager.instance.getDevice(identifier: LoginManager.instance.currentDeviceIdentifier!)!
//    }
    
    //var currentDeviceIdentifier:String?=nil//设置和获取当前设备的ID,nil表示无设备
    func setTabbarSelected(index:Int) {
        mainTabBarController?.selectedIndex=UInt(index)
    }
    
    
    //
    
    func showHud() {
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.show()
        
    }
}


//当前设备型号
let cureentIphoneType: EnumIphoneType = LoginManager.currenIphoneType()

public func printLog<T>(_ message: T,file: String = #file,method: String = #function, line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


