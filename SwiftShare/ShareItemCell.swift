//
//  ShareItemCell.swift
//  SwiftShare
//
//  Created by 刘刚 on 2017/8/18.
//  Copyright © 2017年 刘刚. All rights reserved.
//

import UIKit

public let kCellIdentifier_ShareItemCell:String = "ShareItemCell"  

class ShareItemCell: UICollectionViewCell {
    
    var shareItem: ShareItem!{
        didSet{
            self.imageView.image = shareItem.image
            self.titleLable.text = shareItem.title
            self.titleLable.sizeToFit()
        }
    }
    var showBorderLine: Bool! {
        didSet{
            if (showBorderLine == true) {
                self.addSubview(self.bottomLine)
                self.addSubview(self.rightLine)
            }
        }
    }
    
    lazy var bottomLine: UIView = {
        let bottomLine = UIView(frame:CGRect(x: 0, y: self.frame.size.height-0.5, width: self.frame.size.width, height: 0.5))
        bottomLine.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3);
        return bottomLine
    }()
    
    lazy var rightLine: UIView = {
        let rightLine = UIView(frame:CGRect(x: self.frame.size.width-0.5, y: 0, width: 0.5, height: self.frame.size.height))
        rightLine.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3);
        return rightLine
    }()
    
    var imageView: UIImageView!
    var titleLable: UILabel!
    var itemImageSize: CGSize!
    var itemImageTopSpace: CGFloat!
    var iconAndTitleSpace: CGFloat!
    
    
    deinit {
        print("ShareItemCell")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView!)
        self.titleLable = UILabel()
        self.contentView.addSubview(self.titleLable!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        imageView.frame = CGRect(x:0, y:0 ,width:itemImageSize.width, height:itemImageSize.height);
        
        var imageCenter = self.center;
        imageCenter.y = self.imageView.frame.size.height/2 + self.itemImageTopSpace!;
        imageCenter.x = self.frame.size.width/2;
        imageView.center = imageCenter;
        
        titleLable.sizeToFit();
        var titleCenter = self.imageView.center;
        
        titleCenter.y = imageCenter.y + imageView.frame.size.height/2 + iconAndTitleSpace! + titleLable.frame.size.height/2;
        titleLable.center = titleCenter;
    }

}
