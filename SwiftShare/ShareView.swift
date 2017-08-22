//
//  ShareView.swift
//  SwiftShare
//
//  Created by 刘刚 on 2017/8/18.
//  Copyright © 2017年 刘刚. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let NotifyShareCompleted = NSNotification.Name(rawValue:"shareCompletedNotification")

class ShareView: UIView {
    
    var headerView: UIView!{
        willSet{
            if self.headerView != nil {self.headerView.removeFromSuperview()}
            self.headerView = newValue
            containView.addSubview(self.headerView!)
        }
    }

    var footerView: UIView!{
        willSet{
            if self.footerView != nil { self.footerView.removeFromSuperview()}
            self.footerView = newValue
            containView.addSubview(self.footerView!)
        }
    }
    
    var cancleButton: UIButton!
    var containViewColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0.9)
    var itemTitleFont = UIFont.systemFont(ofSize: 10)
    var itemTitleColor = UIColor.black
    var middleLineColor = UIColor(white: 0.5, alpha: 0.3)
    var itemSize = CGSize(width: 80, height: 80)
    var itemImageSize = CGSize(width: 50, height: 50)
    var showBorderLine: Bool = false
    var bodyViewEdgeInsets = UIEdgeInsets()
    var itemImageTopSpace: CGFloat = 15
    var iconAndTitleSpace: CGFloat = 5
    var itemSpace: CGFloat = 0.0
    var middleTopSpace: CGFloat = 0.0
    var middleBottomSpace: CGFloat = 0.0
    var middleLineEdgeSpace: CGFloat = 0.0
    var showsHorizontalScrollIndicator: Bool = false
    var showCancleButton: Bool = true
    
    fileprivate var shareItems = [Any]()
    fileprivate var functionItems = [Any]()
    fileprivate var containView: UIView!
    fileprivate var bodyView: UIView!
    fileprivate var middleLine: UIView!
    fileprivate var shareCollectionView: UICollectionView!
    fileprivate var functionCollectionView: UICollectionView!
    fileprivate var isOneLine: Bool = false
    fileprivate var itemCountEveryRow: Int = 0
    fileprivate var presentVC: UIViewController!
    fileprivate var shareText: String!
    fileprivate var shareImage: UIImage!
    fileprivate var shareUrl: URL!
    
    deinit {
        print("ShareView")
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        
        let maskView = UIControl(frame: frame)
        maskView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.6)
        maskView.tag = 100
        
        maskView.addTarget(self, action: #selector(ShareView.maskViewClick(_:)), for: .touchUpInside)
        self.addSubview(maskView)
        
        containView = UIView()
        containView.isUserInteractionEnabled = true
        self.addSubview(containView!)
        bodyView = UIView()
        bodyView.backgroundColor = UIColor.clear
        bodyView.isUserInteractionEnabled = true
        self.containView.addSubview(bodyView!)
        
        self.middleLine = UIView()
//        self.middleLine.backgroundColor = middleLineColor
        bodyView.addSubview(self.middleLine!)
        
        cancleButton = UIButton(type: .custom)
        cancleButton.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 50)
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0), for: .normal)
        cancleButton.setBackgroundImage(image(with: UIColor.white, size: CGSize(width: 1.0, height: 1.0)), for: .normal)
        cancleButton.setBackgroundImage(image(with: UIColor(red: 234 / 255.0, green: 234 / 255.0, blue: 234 / 255.0, alpha: 1.0), size: CGSize(width: 1.0, height: 1.0)), for: .highlighted)
        cancleButton.addTarget(self, action: #selector(self.cancleButtonAction), for: .touchUpInside)
        containView.addSubview(cancleButton!)
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(shareCompleted(_:)), name: NotifyShareCompleted, object: nil)
    }
    
    // MARK: - 监听通知
    func shareCompleted(_ note: Notification) {
        self.dismiss(true)
    }
    
    convenience init(items: [Any], itemSize: CGSize, displayLine oneLine: Bool) {
        self.init()
        
        self.shareItems = items
        self.itemSize = itemSize
        self.isOneLine = oneLine
    }
    
    convenience init(shareItems: [Any], functionItems: [Any], itemSize: CGSize) {
        self.init()
        
        self.shareItems = shareItems
        self.functionItems = functionItems
        self.itemSize = itemSize
        self.isOneLine = true
        
    }
    
    convenience init(items: [Any], countEveryRow count: Int) {
        self.init()
        
        shareItems = items
        itemSize = CGSize(width: SCREEN_WIDTH / CGFloat(count) , height: SCREEN_WIDTH / CGFloat(count))
        isOneLine = false
        showBorderLine = true
        showCancleButton = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 暴露方法
    func show(fromControlle controller: UIViewController) {
        presentVC = controller
        show(in: controller.view)
    }
    
    func dismiss(_ animated: Bool) {
        if animated {
            tappedCancel()
        }
        else {
            self.removeFromSuperview()
        }
    }
    
    func addText(_ text: String) {
        shareText = text
    }
    
    func addImage(_ image: UIImage!) -> Void {
        shareImage = image
    }
    
    func addUrl(_ url: URL!) -> Void {
        shareUrl = url
    }

    // MARK: - 私有方法
    private func show(in view: UIView) {
        containView.backgroundColor = containViewColor
        if !showCancleButton {
            cancleButton.setTitle("", for: .normal)
            cancleButton.frame = CGRect.zero
        }
        //计算屏幕容纳几个 cell
        let count: Int = shareItems.count
        let numberOfPerRow: Int = Int(SCREEN_WIDTH / itemSize.width)
        let number: Int = count / numberOfPerRow
        let remainder: Int = count % numberOfPerRow
        var height: CGFloat = CGFloat(number) * itemSize.height + (remainder > 0 ? itemSize.height : 0)
        if isOneLine == true {
            //如果在一行内展示
            height = itemSize.height
        }
        let flowLayout = UICollectionViewFlowLayout()
        if isOneLine == true {
            flowLayout.scrollDirection = .horizontal
        }
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = (isOneLine ? itemSpace : 0.0)
        
        shareCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: height), collectionViewLayout: flowLayout)
        shareCollectionView.delegate = self
        shareCollectionView.dataSource = self
        shareCollectionView.showsVerticalScrollIndicator = false
        shareCollectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        shareCollectionView.bounces = isOneLine
        shareCollectionView.backgroundColor = UIColor.clear
        shareCollectionView.register(ShareItemCell.self, forCellWithReuseIdentifier: kCellIdentifier_ShareItemCell)
        bodyView.addSubview(shareCollectionView!)
        
        if !functionItems.isEmpty {
            //分割线
            middleLine.frame = CGRect(x: middleLineEdgeSpace, y: shareCollectionView.frame.origin.y + shareCollectionView.frame.size.height + middleTopSpace, width: frame.size.width - 2 * middleLineEdgeSpace, height: 0.5)
            middleLine.backgroundColor = middleLineColor
            let functionflowLayout = UICollectionViewFlowLayout()
            functionflowLayout.scrollDirection = .horizontal
            functionflowLayout.itemSize = itemSize
            functionflowLayout.minimumInteritemSpacing = 0.0
            functionflowLayout.minimumLineSpacing = (isOneLine ? itemSpace : 0.0)
            
            functionCollectionView = UICollectionView(frame: CGRect(x: 0, y: middleLine.frame.origin.y + middleLine.frame.size.height + middleBottomSpace, width: frame.size.width, height: itemSize.height), collectionViewLayout: functionflowLayout)
            functionCollectionView.delegate = self
            functionCollectionView.dataSource = self
            functionCollectionView.showsVerticalScrollIndicator = false
            functionCollectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
            functionCollectionView.backgroundColor = UIColor.clear
            functionCollectionView.register(ShareItemCell.self, forCellWithReuseIdentifier: kCellIdentifier_ShareItemCell)
            bodyView.addSubview(functionCollectionView!)
        }
        view.addSubview(self);
    }
    
    // MARK: - Action
    func cancleButtonAction(_ sender: UIButton) {
        tappedCancel()
    }
    
    func maskViewClick(_ sender: UIControl) {
        tappedCancel()
    }
    
    func tappedCancel() {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            let zhezhaoView: UIControl = self.viewWithTag(100)! as! UIControl
            zhezhaoView.alpha = 0
            if (self.containView != nil) {
                self.containView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: self.containView.frame.size.height)
            }
        }, completion: {(_ finished: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
    
    // MARK: - 工具方法
    static func alertMsg(_ title: String,_ message: String, _ controller: ViewController){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //颜色生成图片方法
    func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //计算总高度
        
        var height: CGFloat = bodyViewEdgeInsets.top + bodyViewEdgeInsets.bottom
        if (cancleButton != nil) {
            height += cancleButton.frame.size.height
        }
        if (headerView != nil) {
            height += headerView.frame.size.height
        }
        if (footerView != nil) {
            height += footerView.frame.size.height
        }
        if (middleLine != nil) {
            height += middleLine.frame.size.height
        }
        var bodyHeight: CGFloat = 0
        if (bodyView != nil) {
            if (shareCollectionView != nil) {
                bodyHeight += shareCollectionView.frame.size.height
            }
            if (functionCollectionView != nil) {
                bodyHeight += (functionCollectionView.frame.size.height + 0.5 + +middleTopSpace + middleBottomSpace)
            }
            height += bodyHeight
        }
        
        //动画前置控件位置
        
        if (containView != nil) {
            containView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: height)
        }
        if (headerView != nil) {
            headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerView.frame.size.height)
        }
        
        if (bodyView != nil) {
            let bodyY: CGFloat = (headerView != nil) ? headerView.frame.maxY : CGFloat(0.0)
            bodyView.frame = CGRect(x: bodyViewEdgeInsets.left, y: bodyY + bodyViewEdgeInsets.top, width: SCREEN_WIDTH - bodyViewEdgeInsets.left - bodyViewEdgeInsets.right, height: bodyHeight)
            var shareViewSize: CGRect = shareCollectionView!.frame
            shareViewSize.size.width = bodyView.frame.size.width
            shareCollectionView.frame = shareViewSize
            if (functionCollectionView != nil){
                var functionViewSize: CGRect = functionCollectionView!.frame
                functionViewSize.size.width = bodyView.frame.size.width
                functionCollectionView.frame = functionViewSize
            }
        }
        
        if (footerView != nil) {
            footerView.frame = CGRect(x: 0, y: bodyView.frame.maxY + bodyViewEdgeInsets.bottom, width: SCREEN_WIDTH, height: footerView.frame.size.height)
        }
        if (cancleButton != nil) {
            cancleButton.frame = CGRect(x: 0, y: height - cancleButton.frame.size.height, width: SCREEN_WIDTH, height: cancleButton.frame.size.height)
        }
        
        let zhezhaoView: UIView = self.viewWithTag(100)!
        zhezhaoView.alpha = 0
        //执行动画
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            if (self.containView != nil) {
                self.containView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - height, width: SCREEN_WIDTH, height: height)
            }
            zhezhaoView.alpha = 0.6
        }) { _ in }
        
    }
}

// MARK: - UICollectionViewDelegate、UICollectionViewDataSource

extension ShareView:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shareCollectionView {
            return shareItems.count
        }
        if collectionView == functionCollectionView {
            return functionItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let shareItemCell:ShareItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier_ShareItemCell, for: indexPath) as! ShareItemCell
        
        shareItemCell.titleLable.textColor = itemTitleColor
        shareItemCell.titleLable.font = itemTitleFont
        shareItemCell.itemImageTopSpace = itemImageTopSpace
        shareItemCell.iconAndTitleSpace = iconAndTitleSpace
        shareItemCell.itemImageSize = itemImageSize
        shareItemCell.showBorderLine = showBorderLine
        
        if collectionView == shareCollectionView {
            if (shareItems[indexPath.row] is String) {
                shareItemCell.shareItem = ShareItem(platformName: shareItems[indexPath.row] as! String)
            }
            else {
                shareItemCell.shareItem = shareItems[indexPath.row] as! ShareItem
            }
        }
        else {
            if (functionItems[indexPath.row] is String) {
                shareItemCell.shareItem = ShareItem(platformName: functionItems[indexPath.row] as! String)
            }
            else {
                shareItemCell.shareItem = functionItems[indexPath.row] as! ShareItem
            }
        }
        
        shareItemCell.shareItem.shareText = shareText
        shareItemCell.shareItem.shareImage = shareImage
        shareItemCell.shareItem.shareUrl = shareUrl
        shareItemCell.shareItem.presentVC = presentVC as! ViewController
        return shareItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: ShareItemCell = (collectionView.cellForItem(at: indexPath) as! ShareItemCell)
        if ((cell.shareItem.callBack) != nil) {
            cell.shareItem.callBack!((cell.shareItem)!)
            if cell.shareItem.dismissShareView{
                dismiss(true)
            }
        }
    }

}
