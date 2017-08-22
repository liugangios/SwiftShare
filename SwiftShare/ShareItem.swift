//
//  ShareItem.swift
//  SwiftShare
//
//  Created by 刘刚 on 2017/8/18.
//  Copyright © 2017年 刘刚. All rights reserved.
//

import UIKit
import Social
import MessageUI

typealias shareHandle = (_ item:ShareItem)-> Void

class ShareItem: NSObject {

    var image: UIImage!
    var title: String!
    weak var presentVC:ViewController!
    var callBack:shareHandle!
    var shareText: String!
    var shareImage: UIImage!
    var shareUrl: URL!
    var dismissShareView: Bool = true
    deinit {
        print("ShareItem")
    }
    
    init(image:UIImage, title:String, callBack:@escaping shareHandle) {
        self.image = image
        self.title = title
        self.callBack = callBack
    }
    
    init(image:UIImage, title:String, actionName : String ) {
        super.init()
        self.image = image
        self.title = title
        self.callBack = self.actionFromString(handleName: actionName)
    }
    
    init(platformName:String) {

        super.init()
        
        var messageDict:[String:String]!
        
        switch platformName {
        case PlatformNameSina:
            messageDict = ["image":"share_sina","title":"新浪微博","action":PlatformHandleSina]
        case PlatformNameQQ:
            messageDict = ["image":"share_qq","title":"QQ","action":PlatformHandleQQ]
        case PlatformNameEmail:
            messageDict = ["image":"share_email","title":"邮件","action":PlatformHandleEmail]
            self.dismissShareView = false
        case PlatformNameSms:
            messageDict = ["image":"share_sms","title":"短信","action":PlatformHandleSms]
            self.dismissShareView = false
        case PlatformNameWechat:
            messageDict = ["image":"share_weixin","title":"微信","action":PlatformHandleWechat]
        case PlatformNameAlipay:
            messageDict = ["image":"share_alipay","title":"支付宝","action":PlatformHandleAlipay]
        default:
            messageDict = ["image":"share_unknown","title":"未知类型","action":PlatformHandleUnknown]
        }
        
        self.title = messageDict["title"]
        self.image = UIImage.init(named: ("IFMShareImage.bundle/" + messageDict["image"]!))
        self.callBack = self.actionFromString(handleName: messageDict["action"]!);
    }
    
    // MARK: - 私有方法
    private func actionFromString(handleName:String) -> shareHandle {
        
        let handle = { [unowned self] (item:ShareItem) -> Void in
            
            var platformID: String!
            var tipPlatform:String!
            
            switch handleName {
            case PlatformHandleEmail:
                self.sendmail(to: "")
                return
            case PlatformHandleSms:
                self.sendMessage(to: "")
                return
            case PlatformHandleSina:
                platformID = "com.apple.share.SinaWeibo.post"
                tipPlatform = "新浪微博"
            case PlatformHandleQQ:
                platformID = "com.tencent.mqq.ShareExtension"
                tipPlatform = "QQ"
            case PlatformHandleWechat:
                platformID = "com.tencent.xin.sharetimeline"
                tipPlatform = "微信"
            case PlatformHandleAlipay:
                platformID = "com.alipay.iphoneclient.ExtensionSchemeShare"
                tipPlatform = "支付宝"
            case PlatformHandleTwitter:
                platformID = "com.apple.share.Twitter.post"
                tipPlatform = "推特"
            case PlatformHandleFacebook:
                platformID = "com.apple.share.Facebook.post"
                tipPlatform = "脸书"
            case PlatformHandleInstagram:
                platformID = "com.burbn.instagram.shareextension"
                tipPlatform = "instagram"
            case PlatformHandleNotes:
                platformID = "com.apple.mobilenotes.SharingExtension"
                tipPlatform = "备忘录"
            case PlatformHandleReminders:
                platformID = "com.apple.reminders.RemindersEditorExtension"
                tipPlatform = "提醒事项"
            case PlatformHandleiCloud:
                platformID = "com.apple.mobileslideshow.StreamShareService"
                tipPlatform = "iCloud"
            case PlatformHandleUnknown:
                ShareView.alertMsg("提示", "handleName未知", self.presentVC)
                return
            default:
                ShareView.alertMsg("提示", "handleName未知", self.presentVC)
                return
            }
            
            let UNLoginTip = "没有配置" + tipPlatform + "相关的帐号"
            let UNInstallTip = "没有安装" + tipPlatform
            
            let composeVc = SLComposeViewController(forServiceType: platformID)
            if (composeVc == nil){
                ShareView.alertMsg("提示", UNLoginTip, self.presentVC);
                return;
            }
            if (!SLComposeViewController.isAvailable(forServiceType:platformID)) {
                ShareView.alertMsg("提示", UNInstallTip, self.presentVC);
                return;
            }

            if self.shareText != nil {composeVc?.setInitialText(self.shareText)}
            if self.shareImage != nil { composeVc?.add(self.shareImage)}
            if self.shareUrl != nil { composeVc?.add(self.shareUrl)}
            
            self.presentVC.present(composeVc!, animated: false, completion: nil)
            
            composeVc?.completionHandler = {(result)->Void in
                if (result == SLComposeViewControllerResult.cancelled) {
                    print("点击了取消")
                } else {
                    print("点击了发送")
                }
            }
        };
        
        return handle;
    }
    
    private func sendmail(to email: String) {
        if !MFMailComposeViewController.canSendMail() {
            ShareView.alertMsg("提示", "手机未设置邮箱", presentVC);
            return
        }
        let controller = MFMailComposeViewController()
        controller.setToRecipients([email])
        if (shareText != nil) {
            controller.setSubject(shareText)
        }
        if (shareUrl != nil) {
            controller.setMessageBody(String(describing: shareUrl!), isHTML: true)
        }
        if (shareImage != nil) {
            let imageData: Data? = UIImagePNGRepresentation(shareImage)
            controller.addAttachmentData(imageData!, mimeType: "image/png", fileName: "图片.png")
        }
        controller.mailComposeDelegate = self
        presentVC.present(controller, animated: true) { _ in }
    }
    
    private func sendMessage(to phoneNum: String) {
        if !MFMessageComposeViewController.canSendText() {
            ShareView.alertMsg("提示", "设备不能发短信", presentVC);
            return
        }
        let controller = MFMessageComposeViewController()
        controller.recipients = [phoneNum]
        controller.body = shareText + String(describing: shareUrl!)
        controller.messageComposeDelegate = self
        presentVC.present(controller, animated: true) { _ in }
    }
}

// MARK: - 邮件、短息代理方法
extension ShareItem: MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        presentVC.dismiss(animated: true) { _ in }
        NotificationCenter.default.post(name:NotifyShareCompleted, object: self, userInfo: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        presentVC.dismiss(animated: true) { _ in }
        NotificationCenter.default.post(name:NotifyShareCompleted, object: self, userInfo: nil)
    }
}
