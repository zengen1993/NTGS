//
//  BackView.swift
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//

import UIKit
class BackView: UIButton {
    
    init(frame: CGRect, image: UIImage, title: String) {
        super.init(frame: frame)
        self.setBackgroundImage(image, for: UIControlState())
        //        self.titleLabel?.textAlignment = NSTextAlignment.Left
        //        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        //        self.setImage(image, forState: UIControlState.Normal)
        //        self.setTitle(title, forState: UIControlState.Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
    //        return CGRectMake(0, 0, 0, 0)
    //    }
    //
    //    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
    //        return CGRectMake(0, 0, kXLImageWidth, contentRect.size.height)
    //    }
    
}
