//
//  HUDTool.swift
//  A猫监理
//
//  Created by Apple on 16/9/11.
//  Copyright © 2016年 Apple. All rights reserved.
//  
import UIKit

class HUDTool: NSObject {
    
    var hud: MBProgressHUD!
    var parentView: UIView!
    var counter: Int = 0 {
        didSet {
            if counter > 0 {
                hud.show(true)
            } else {
                hud.hide(true)
            }
            print("**************************\(counter)")
        }
    }
    init(view:UIView) {
        self.parentView = view
        hud = MBProgressHUD(frame: view.bounds)
        hud.labelText = "正在加载..."
        view.addSubview(hud)
    }
    func show() {
        counter += 1
    }
    func hide() {
        print(counter)
        counter -= 1
    }
    func webShow() {
        if parentView.subviews.contains(hud) {
            hud.show(true)
        }
    }
    func webHide() {
        counter = 0
    }
}
