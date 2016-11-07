//
//  SetDeviceNameController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SetDeviceNameController: UIViewController {

   
    @IBAction func SaveClick(_ sender: AnyObject) {
        let vcs=self.navigationController?.viewControllers
        let vc=self.navigationController?.viewControllers[(vcs?.count)!-2] as! DeviceSettingController
        vc.nameChange(name: nameTextFeild.text!, attr: [attributeName0.text!,attributeName1.text!][currSelectAttrIndex])
        _=self.navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet var nameTextFeild: UITextField!
    
    @IBAction func writeNameClick(_ sender: AnyObject) {
        nameTextFeild.isEnabled=true
        nameTextFeild.backgroundColor=UIColor.white
        nameTextFeild.becomeFirstResponder()
    }
    @IBOutlet var attributeName0: UILabel!
    @IBOutlet var attributeName1: UILabel!
    @IBOutlet var attributeImg0: UIImageView!
    @IBOutlet var attributeImg1: UIImageView!
    @IBAction func selectAttributeClick(_ sender: UITapGestureRecognizer) {
        currSelectAttrIndex=(sender.view?.tag)!
    }
    var currSelectAttrIndex = 0{
        didSet{
            attributeImg0.isHidden = currSelectAttrIndex != 0
            attributeImg1.isHidden = currSelectAttrIndex != 1
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var attri:[Int:String]!        
        switch LoginManager.instance.currentDevice.type {
        case OznerDeviceType.Cup.rawValue:
            attri=[0:"我的水杯",1:"家人水杯"]
        case OznerDeviceType.Tap.rawValue,OznerDeviceType.TDSPan.rawValue:
            attri=[0:"洗手间",1:"厨房"]
        case OznerDeviceType.Water_Wifi.rawValue:
            attri=[0:"家",1:"办公室"]
        case OznerDeviceType.Air_Blue.rawValue,OznerDeviceType.Air_Wifi.rawValue:
            attri=[0:"客厅",1:"卧室"]
        case OznerDeviceType.WaterReplenish.rawValue:
            attri=[0:"办公室",1:"家"]
        default:
            attri=[0:"",1:""]
            break
        }
        attributeName0.text=attri[0]
        attributeName1.text=attri[1]
        
        nameTextFeild.text = LoginManager.instance.currentDevice.settings.name
        currSelectAttrIndex = (LoginManager.instance.currentDevice.settings.get("usingSite", default: "") as! String)==attri[1] ? 1:0
        // Do any additional setup after loading the view.
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
extension SetDeviceNameController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.backgroundColor=UIColor.clear
        textField.isEnabled=false
        return true
    }
}
