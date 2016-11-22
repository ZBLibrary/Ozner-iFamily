//
//  OznerShareManager.swift
//  OzneriFamily
//
//  Created by 赵兵 on 2016/11/21.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

import UIKit

class OznerShareManager: NSObject {

    class func ShareImgToWeChat(sence:WXScene,url:String,title:String,shareImg:UIImage){
        if WXApi.isWXAppInstalled()
        {
            let message = WXMediaMessage()
            message.title = title;
            message.setThumbImage(UIImage(named: "icon85_85"))
           
            
            let imageObject = WXImageObject()
            imageObject.imageData = UIImagePNGRepresentation(shareImg)
            message.mediaObject = imageObject
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(sence.rawValue)
            WXApi.send(req)
        }
        else
        {
            let alertView=SCLAlertView()
            _=alertView.showTitle("", subTitle: "您还没有安装手机微信", duration: 2.0, completeText: "确定", style: SCLAlertViewStyle.notice)
        }
    }
    class func ShareLinkToWeChat(sence:WXScene,url:String,title:String,titleImg:UIImage,LinkDes:String){
        if WXApi.isWXAppInstalled()
        {
            //创建发送对象实例
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = Int32(sence.rawValue)
            //创建分享内容对象
            let message = WXMediaMessage()
            message.title = title
            message.description=LinkDes
            message.setThumbImage(titleImg)
            
            //创建多媒体对象
            let webObject=WXWebpageObject()
            webObject.webpageUrl=url
            
            //完成发送对象实例
            message.mediaObject=webObject
            req.message = message
            
            //发送分享信息
            WXApi.send(req)
        
        }
        else
        {
            let alertView=SCLAlertView()
            _=alertView.showTitle("", subTitle: "您还没有安装手机微信", duration: 2.0, completeText: "确定", style: SCLAlertViewStyle.notice)
        }
    }
    //rank:Int 排名,5
    //type:Int 类型 0代表饮水量，1代表tds,0
    //value:Int 饮水量值,200
    //beat:Int 打败了35%,35
    //maxWater:Int
    
    class func getshareImage(_ rank:Int,type:Int,value:Int,beat:Int,maxWater:Int)->UIImage
    {
        let shareView = GYShareImage(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen))

        shareView.backgroundColor = UIColor.white
        shareView.share_rank.text="\(loadLanguage("排名"))\(rank==0 ? 1:rank)"
        shareView.share_title.text=type==0 ? loadLanguage("当前饮水量为"):loadLanguage("当前水质纯净值为")
        shareView.share_value.text="\(value)"+(type==0 ? "ml":"")
        shareView.share_beat.text="\(loadLanguage("击败了"))\(beat>=100 ? 99:beat)％\(loadLanguage("的用户"))"
        if type==0&&maxWater>0
        {
            let water=Double(value)/Double(maxWater)>1 ? 1:Double(value)/Double(maxWater)
            switch true
            {
            case water<0.3333:
                shareView.share_stateImage.image=UIImage(named: "share_Water1")                
            case 0.3333<=water&&water<0.6666:
                shareView.share_stateImage.image=UIImage(named: "share_Water2")
            case 0.6666<=water:
                shareView.share_stateImage.image=UIImage(named: "share_Water3")
            default:
                break
            }
            shareView.share_beat.text=""
        }
        else if type==1
        {
            switch true
            {
            case Int32(value)<tds_good:
                shareView.share_stateImage.image=UIImage(named: "share_TDS3")
                break
            case tds_good<Int32(value)&&Int32(value)<tds_bad:
                shareView.share_stateImage.image=UIImage(named: "share_TDS2")
                break
            case tds_bad<Int32(value):
                shareView.share_stateImage.image=UIImage(named: "share_TDS1")
                break
            default:
                break
            }
        }
        //获取用户头像
        
        let headImgStr=User.currentUser?.headimage
        if headImgStr != nil && headImgStr != ""
        {
            shareView.share_OwnerImage.image=UIImage(data: try! Data(contentsOf: URL(string: headImgStr!)!))
           shareView.share_OwnerName.text=User.currentUser?.username ?? "浩小泽"           
        }
        else
        {
            shareView.share_OwnerImage.image=UIImage(named: "shareOwnerimg")
            shareView.share_OwnerName.text = "浩小泽"
        }
  
        UIGraphicsBeginImageContext(shareView.bounds.size)
        shareView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage!
    }
    
    
}
