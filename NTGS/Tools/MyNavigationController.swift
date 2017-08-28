//
//  MyNavigationController.swift
//  Swift
//
//  Created by Apple on 17/2/7.
//  Copyright © 2017年 hrscy. All rights reserved.
//
//  自定义导航控制器

import UIKit

class MyNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            //那么当这个视图控制器被推入一个带有底部栏的控制器层级(像一个标签栏)时，底部的条就会滑出
            viewController.hidesBottomBarWhenPushed = true
            
            let barItem = UIBarButtonItem.getBackBarButtonItem("返回", target: self, action: #selector(navigationBack))
            let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            spaceItem.width = -10
            viewController.navigationItem.leftBarButtonItems = [spaceItem,barItem]
        }
        super.pushViewController(viewController, animated: true)
    }
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
}
