//
//  ViewController.swift
//  SwiftShareDemo
//
//  Created by 刘刚 on 2017/8/18.
//  Copyright © 2017年 刘刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var shareArray: [Any] = {
        var shareArray = [Any]()
        
        ///使用预制默认图片、title和分享事件
        shareArray.append(PlatformNameSms)
        shareArray.append(PlatformNameEmail)
        shareArray.append(PlatformNameSina)
        shareArray.append(PlatformNameWechat)
        
        ///自定义图片和title,使用预制默认分享事件
        shareArray.append(ShareItem(image: UIImage(named: "IFMShareImage.bundle/share_qq")!, title: "QQ", actionName: PlatformHandleQQ))
        
        ///自定义图片、title和事件
        shareArray.append(ShareItem(image: UIImage(named: "IFMShareImage.bundle/share_alipay")!, title: "支付宝", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了支付宝", self)
        }))
        
        return shareArray
    }()
    
    lazy var functionArray: [Any] = {
        var functionArray = [Any]()
        functionArray.append(ShareItem(image: UIImage(named: "function_collection")!, title: "收藏", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了收藏", self)
        }))
        functionArray.append(ShareItem(image: UIImage(named: "function_copy")!, title: "复制", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了复制", self)
        }))
        functionArray.append(ShareItem(image: UIImage(named: "function_expose")!, title: "举报", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了举报", self)
        }))
        functionArray.append(ShareItem(image: UIImage(named: "function_font")!, title: "调整字体", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了调整字体", self)
        }))
        functionArray.append(ShareItem(image: UIImage(named: "function_link")!, title: "复制链接", callBack: {(_ item: ShareItem) -> Void in
            ShareView.alertMsg("提示", "点击了复制链接", self)
        }))
        functionArray.append(ShareItem(image: UIImage(named: "function_refresh")!, title: "刷新", actionName:PlatformHandleUnknown))

        return functionArray
    }()
    
    
    @IBAction func showOneLineStyle(_ sender: UIButton) {
        var shareView = ShareView(items: shareArray, itemSize: CGSize(width: 80, height: 100), displayLine: true)
        shareView = addShareContent(shareView)
        shareView.itemSpace = 10
        shareView.show(fromControlle: self)
    }

    @IBAction func showDoubleLineStyle(_ sender: UIButton) {
        var shareView = ShareView(shareItems: shareArray, functionItems: functionArray, itemSize: CGSize(width: 80, height: 100))
        shareView = addShareContent(shareView)
        shareView.itemSpace = 10
        shareView.show(fromControlle: self)
    }
    
    @IBAction func showMultiLineStyle(_ sender: UIButton) {
        var totalArry = [Any]()
        totalArry += shareArray
        totalArry += functionArray
        var shareView = ShareView(items: totalArry, itemSize: CGSize(width: 80, height: 100), displayLine: false)
        shareView = addShareContent(shareView)
        shareView.itemSpace = 100
        shareView.show(fromControlle: self)
    }
    
    @IBAction func showSquaredStyle(_ sender: UIButton) {
        var shareView = ShareView(items: shareArray, countEveryRow: 4)
        shareView.itemImageSize = CGSize(width: 45, height: 45)
        shareView = addShareContent(shareView)
        //    shareView.itemSpace = 10;
        shareView.show(fromControlle: self)
    }
    
    @IBAction func showHeadFootStyle(_ sender: UIButton) {
        var shareView = ShareView(shareItems: shareArray, functionItems: functionArray, itemSize: CGSize(width: 80, height: 100))
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        headerView.backgroundColor = UIColor.clear
        var label = UILabel(frame: CGRect(x: 0, y: 10, width: headerView.frame.size.width, height: 15))
        label.textAlignment = .center
        label.textColor = UIColor(red: 51 / 255.0, green: 68 / 255.0, blue: 79 / 255.0, alpha: 1.0)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "我是头部可以自定义的View"
        headerView.addSubview(label)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        footerView.backgroundColor = UIColor.clear
        label = UILabel(frame: CGRect(x: 0, y: 10, width: headerView.frame.size.width, height: 15))
        label.textAlignment = .center
        label.textColor = UIColor(red: 5 / 255.0, green: 27 / 255.0, blue: 40 / 255.0, alpha: 1.0)
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "我是底部可以自定义的View"
        footerView.addSubview(label)
        
        shareView.headerView = headerView
        shareView.footerView = footerView
        shareView = addShareContent(shareView)
        shareView.show(fromControlle: self)
    }
    
    @IBAction func showUserDefineStyle(_ sender: UIButton) {
        var shareView = ShareView(shareItems: shareArray, functionItems: functionArray, itemSize: CGSize(width: 80, height: 100))
        shareView.cancleButton.setTitle("我是可以自定义的按钮", for: .normal)
        shareView.middleLineColor = UIColor.red
        shareView.middleLineEdgeSpace = 20
        shareView.middleTopSpace = 10
        shareView.middleBottomSpace = 30
        shareView = addShareContent(shareView)
        shareView.show(fromControlle: self)
    }

    func addShareContent(_ shareView: ShareView) -> ShareView {
        shareView.addText("分享测试")
        shareView.addUrl(URL(string: "http://www.baidu.com"))
        shareView.addImage(UIImage(named: "function_collection"))
        return shareView
    }
}

