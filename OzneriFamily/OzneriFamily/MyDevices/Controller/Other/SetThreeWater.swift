//
//  SetDeviceNameController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class SetThreeWater: BaseViewController {

   
    @IBOutlet weak var addressLb: GYLabel!
    @IBAction func SaveClick(_ sender: AnyObject) {
        let vcs=self.navigationController?.viewControllers
        let vc=self.navigationController?.viewControllers[(vcs?.count)!-2] as! DeviceSettingController
        vc.nameChange(name: nameTextFeild.text!, attr: [attributeName0.text!,attributeName1.text!,attributeName2.text!,attributeName3.text!][currSelectAttrIndex])
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
    @IBOutlet weak var attributeName2: UILabel!
    @IBOutlet weak var attributeName3: UILabel!
    @IBOutlet weak var attributeImg2: UIImageView!
    @IBOutlet weak var attributrImg3: UIImageView!
    
    
    @IBAction func selectAttributeClick(_ sender: UITapGestureRecognizer) {
        currSelectAttrIndex=(sender.view?.tag)!
    }
    var currSelectAttrIndex = 0{
        didSet{
            attributeImg0.isHidden = currSelectAttrIndex != 0
            attributeImg1.isHidden = currSelectAttrIndex != 1
            attributeImg2.isHidden = currSelectAttrIndex != 2
            attributrImg3.isHidden = currSelectAttrIndex != 3
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.rightBarButtonItem?.title = loadLanguage("保存")
        addressLb.text = loadLanguage("使用地点")
        var attri:[Int:String]!
        attri = [0:loadLanguage("学校"),1:loadLanguage("工厂"),2:loadLanguage("公司"),3:loadLanguage("其他")]
        attributeName0.text=attri[0]
        attributeName1.text=attri[1]
        attributeName2.text = attri[2]
        attributeName3.text = attri[3]
       
        nameTextFeild.text = OznerManager.instance.currentDevice?.settings.name
        currSelectAttrIndex = 0
        attri.forEach { (key,value) in
            
            if (OznerManager.instance.currentDevice?.settings.GetValue(key: "usingSite", defaultValue: "")) == value {
                currSelectAttrIndex = key
            }
        }
        
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
extension SetThreeWater:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.backgroundColor=UIColor.clear
        textField.isEnabled=false
        return true
    }
}
