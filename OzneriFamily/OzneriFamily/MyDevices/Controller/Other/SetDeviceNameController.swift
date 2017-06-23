//
//  SetDeviceNameController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SetDeviceNameController: BaseViewController {

   
    @IBOutlet weak var addressLb: GYLabel!
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
       
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        addressLb.text = loadLanguage("使用地点")
        var attri:[Int:String]!
        
        switch OznerDeviceType.getType(type: LoginManager.instance.currentDevice.type){
        case OznerDeviceType.Cup:
            attri=[0:loadLanguage("我的水杯"),1:loadLanguage("家人水杯")]
        case .Tap,.TDSPan:
            attri=[0:loadLanguage("洗手间"),1:loadLanguage("厨房")]
        case .Water_Wifi,.Water_Wifi_JZYA1XBA8CSFFSF,.Water_Wifi_JZYA1XBA8DRF,.Water_Wifi_JZYA1XBLG_DRF:
            attri=[0:loadLanguage("家"),1:loadLanguage("办公室")]
        case .Air_Blue,.Air_Wifi:
            attri=[0:loadLanguage("客厅"),1:loadLanguage("卧室")]
        case .WaterReplenish:
            attri=[0:loadLanguage("办公室"),1:loadLanguage("家")]
        case .Water_Bluetooth,.Water_KitchenBLe:
            attri=[0:loadLanguage("家"),1:loadLanguage("办公室")]
    
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
