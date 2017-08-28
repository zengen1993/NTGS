//
//  UIButton.swift
//  SwiftWB
//
//  Created by Apple on 17/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(ImageName: String, backgroundName: String)
    {
        self.init()
        setImage(UIImage(named: ImageName), for: .normal)
        setImage(UIImage(named: ImageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backgroundName), for: .normal)
        setBackgroundImage(UIImage.init(named: backgroundName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
}
extension UIImage{
    static func ImageFromColor(_ color: UIColor, frame: CGRect) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
