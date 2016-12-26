//
//  AboutDeviceController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class AboutDeviceController: BaseViewController {

    @IBOutlet var webView: UIWebView!
    private var type=0//0代表网址，1代表图片,2代表本地网页
    private var Content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case 0:
            webView.loadRequest(URLRequest(url: URL(string: Content)!))
        case 1:
            webView.loadHTMLString(htmlForJPGImage(imageName: Content), baseURL: nil)
        case 2:
            webView.loadHTMLString(Content, baseURL: nil)
        default:
            break
        }
      
    }
    ////Type 0代表网址，1代表图片,2代表本地网页
    func setLoadContent(content:String,Type:Int){
        type=Type
        Content=content
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //编码图片
    private func htmlForJPGImage(imageName:String)->String
    {
        let aboutImage = UIImage(named: imageName)
        let imageData = UIImageJPEGRepresentation(aboutImage!,1.0);
        
        let imageStr = "<img src = \"data:image/jpg;base64,"+(imageData?.base64EncodedString())!+"\" />"
        //构造内容
        var content = "<html>"
        content += "<style type=\"text/css\">"
        content += "<!--"
        content += "body{font-size:40pt;line-height:60pt;}"
        content += "-->"
        content += "</style>"
        content += "<body>"
        content += imageStr
        content += "</body>"
        content += "</html>"
        return content
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.SetCustomBarStyle(style: OznerNavBarStyle.DeviceSetting)
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
