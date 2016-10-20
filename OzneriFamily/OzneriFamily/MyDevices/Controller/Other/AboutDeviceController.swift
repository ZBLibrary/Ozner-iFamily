//
//  AboutDeviceController.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/10/20.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class AboutDeviceController: UIViewController {

    @IBOutlet var webView: UIWebView!
    private var IsUrl:Bool=true//url代表网址，false代表图片
    private var Content:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if IsUrl {
            webView.loadRequest(URLRequest(url: URL(string: Content)!))
        }else{
            webView.loadHTMLString(htmlForJPGImage(imageName: Content), baseURL: nil)
        }
        
    }
    func setLoadContent(content:String,isUrl:Bool){
        IsUrl=isUrl
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
